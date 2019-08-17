/*
TODO:
  1. Stall and flush support
  2. Forwarding
  3. Exception and interruption
  4. More instructions support 
*/

module CPU(reset, clk);
input reset;
input clk;

// STAGE 1: IF
wire [31:0] pc;
wire [31:0] pc_next;
wire [31:0] pc_plus_4;
wire Hazard;
ProgramCounter program_counter(.clk(clk), .reset(reset), .PCWrite(~Hazard), .pc_next(pc_next), .pc(pc));
assign pc_plus_4 = pc + 32'd4;

// Fetch instruction
wire [31:0] instruction;
InstructionMemory instr_mem_1(.address(pc), .instruction(instruction));
IF_ID_Reg if_id(.clk(clk), .wr_en(~Hazard), .reset(reset), .instr_in(instruction), .pc_next_in(pc_plus_4));

// STAGE 2: ID
wire ExtOp;
wire LuOp;

wire [1:0] RegDst;
wire [3:0] ALUOp;
wire ALUSrc1;
wire ALUSrc2;

wire MemRead;
wire MemWrite;

wire [1:0] MemtoReg;
wire RegWrite;

wire [1:0] PCSrc;
wire Branch;

// Generate control signals after fetching instructions
Control control_1(
          .opcode(if_id.instr[31:26]), .funct(if_id.instr[5:0]),
          .ExtOp(ExtOp), .LuOp(LuOp),
          .ALUOp(ALUOp), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2),
          .MemRead(MemRead), .MemWrite(MemWrite), .RegDst(RegDst),
          .MemtoReg(MemtoReg), .RegWrite(RegWrite), .PCSrc(PCSrc), .Branch(Branch)
        );

HazardUnit hazard_unit(
             .if_id_rs_addr(if_id.instr[25:21]), .if_id_rt_addr(if_id.instr[20:16]),
             .id_ex_MemRead(id_ex.MemRead), .id_ex_rt_addr(id_ex.rt_addr), .Hazard(Hazard)
           );

// Read register A and B
// WB's writing register also implemented here
wire [31:0] rs;
wire [31:0] rt;
wire [31:0] mem_data;
RegisterFile reg_file_1(
               .clk(clk), .reset(reset),
               .RegWrite(mem_wb.RegWrite), .write_addr(mem_wb.write_addr), .write_data(mem_data),
               .read_addr_1(if_id.instr[25:21]), .read_addr_2(if_id.instr[20:16]),
               .read_data_1(rs), .read_data_2(rt)
             );

// Handle jump or branch
wire [31:0] jump_target;
wire [31:0] branch_target;
assign jump_target = {if_id.pc_next[31:28], if_id.instr[25:0], 2'b00};

// TODO: It also needs to flush registers when branch or jump happens
assign branch_target = (Branch & (rs == rt)) ? if_id.pc_next + {imm_out[29:0], 2'b00} : pc_plus_4;
assign pc_next = (PCSrc == 2'b00) ? branch_target : (PCSrc == 2'b01) ? jump_target : rs;

// Extend immediate
wire [31:0] ext_out;
assign ext_out = {ExtOp ? {16{if_id.instr[15]}} : 16'h0000, if_id.instr[15:0]};

wire [31:0] imm_out;
assign imm_out = LuOp ? {if_id.instr[15:0], 16'h0000} : ext_out;

// Store control signals, reg A, B and immediate in IF/ID Register
ID_EX_Reg id_ex(
            .clk(clk), .wr_en(1), .reset(reset), .Hazard(Hazard),
            .rs_addr_in(if_id.instr[25:21]), .rt_addr_in(if_id.instr[20:16]), .rd_addr_in(if_id.instr[15:11]),
            .shamt_in(if_id.instr[10:6]), .funct_in(if_id.instr[5:0]),
            .rs_in(rs), .rt_in(rt), .imm_in(imm_out), .pc_next_in(if_id.pc_next),
            .ALUOp_in(ALUOp), .ALUSrc1_in(ALUSrc1), .ALUSrc2_in(ALUSrc2), .RegDst_in(RegDst),
            .MemRead_in(MemRead),	.MemWrite_in(MemWrite),
            .MemtoReg_in(MemtoReg), .RegWrite_in(RegWrite)
          );

// STAGE 3: EX
wire [4:0] ALUCtl;
wire Sign;
ALUControl alu_control_1(.ALUOp(id_ex.ALUOp), .funct(id_ex.funct), .ALUCtl(ALUCtl), .Sign(Sign));

wire [1:0] ForwardA;
wire [1:0] ForwardB;
ForwardControl forward_ctr(
                 .reset(reset), .rs_addr(id_ex.rs_addr), .rt_addr(id_ex.rt_addr),
                 .ex_mem_RegWrite(ex_mem.RegWrite), .ex_mem_write_addr(ex_mem.write_addr),
                 .mem_wb_RegWrite(mem_wb.RegWrite), .mem_wb_write_addr(mem_wb.write_addr),
                 .ForwardA(ForwardA), .ForwardB(ForwardB)
               );

wire [31:0] latest_rs;
wire [31:0] latest_rt;
wire [31:0] alu_in_1;
wire [31:0] alu_in_2;
assign latest_rs =
       ForwardA == 2'b00 ? id_ex.rs :
       ForwardA == 2'b10 ? ex_mem.alu_out :
       mem_data;
assign latest_rt =
       ForwardB == 2'b00 ? id_ex.rt :
       ForwardB == 2'b10 ? ex_mem.alu_out :
       mem_data;
assign alu_in_1 = id_ex.ALUSrc1 ? {27'h00000, id_ex.shamt} : latest_rs;
assign alu_in_2 = id_ex.ALUSrc2 ? id_ex.imm : latest_rt;

wire [31:0] alu_out;
wire Zero;

ALU alu1(.in_1(alu_in_1), .in_2(alu_in_2), .ALUCtl(ALUCtl), .Sign(Sign), .out(alu_out), .zero(Zero));

wire [4:0] write_addr;
assign write_addr = (id_ex.RegDst == 2'b00) ? id_ex.rt_addr : (id_ex.RegDst == 2'b01) ? id_ex.rd_addr : 5'b11111;

EX_MEM_Reg ex_mem(
             .clk(clk), .wr_en(1), .reset(reset),
             .alu_out_in(alu_out), .rt_in(id_ex.rt), .write_addr_in(write_addr), .pc_next_in(id_ex.pc_next),
             .MemRead_in(id_ex.MemRead), .MemWrite_in(id_ex.MemWrite),
             .MemtoReg_in(id_ex.MemtoReg), .RegWrite_in(id_ex.RegWrite)
           );

// STAGE 4: MEM
wire [31:0] mem_out;
DataMemory data_mem_1(
             .clk(clk), .MemRead(ex_mem.MemRead), .MemWrite(ex_mem.MemWrite), .address(ex_mem.alu_out),
             .write_data(ex_mem.rt), .read_data(mem_out)
           );

MEM_WB_Reg mem_wb(
             .clk(clk), .wr_en(1), .reset(reset),
             .alu_out_in(ex_mem.alu_out), .write_addr_in(ex_mem.write_addr), .mem_out_in(mem_out), .pc_next_in(ex_mem.pc_next),
             .MemtoReg_in(ex_mem.MemtoReg), .RegWrite_in(ex_mem.RegWrite)
           );

// STAGE 5: WB
assign mem_data = (mem_wb.MemtoReg == 2'b00) ? mem_wb.alu_out : (mem_wb.MemtoReg == 2'b01) ? mem_wb.mem_out: mem_wb.pc_next;

endmodule
