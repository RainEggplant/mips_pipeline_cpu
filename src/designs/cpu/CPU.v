/*
TODO:
  1. More instructions support 
*/

module CPU(
         clk, reset,
         uart_on, uart_mode, uart_ram_id, Rx_Serial,
         led, ssd, Tx_Serial
       );
input clk;
input reset;
input uart_on;
input uart_mode;
input uart_ram_id;
input Rx_Serial;
output [7:0] led;
output [11:0] ssd;
output Tx_Serial;

wire IRQ;
wire ExceptionOrInterrupt;
wire DataHazard;
wire JumpHazard;
wire BranchHazard;

// STAGE 1: IF
// Update PC
wire [31:0] pc;
wire [31:0] pc_next;
wire [31:0] pc_plus_4;
ProgramCounter program_counter(
                 .clk(clk), .reset(reset), .wr_en(~DataHazard || ExceptionOrInterrupt),
                 .pc_next(pc_next), .pc(pc)
               );
assign pc_plus_4 = pc + 32'd4;

// Fetch instruction
wire [31:0] instruction;
// The instr_mem has been moved to pseudo bus
IF_ID_Reg if_id(
            .clk(clk), .reset(reset), .wr_en(~DataHazard || ExceptionOrInterrupt),
            .Flush(ExceptionOrInterrupt || JumpHazard || BranchHazard),
            .instr_in(instruction), .pc_next_in(pc_plus_4)
          );

// STAGE 2: ID
// Define control signals
wire [2:0] PCSrc;
wire Branch;
wire ExtOp;
wire LuOp;
wire [1:0] RegDst;
wire [3:0] ALUOp;
wire ALUSrc1;
wire ALUSrc2;
wire MemRead;
wire MemWrite;
wire [1:0] MemToReg;
wire RegWrite;

// Generate control signals after fetching instructions
Control control(
          .Supervised(pc[31] || if_id.pc_next[31]), .IRQ(IRQ), // it is safe to use pc_next
          .opcode(if_id.instr[31:26]), .funct(if_id.instr[5:0]),
          .ExceptionOrInterrupt(ExceptionOrInterrupt),
          .PCSrc(PCSrc), .Branch(Branch),
          .ExtOp(ExtOp), .LuOp(LuOp),
          .ALUOp(ALUOp), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2),
          .MemRead(MemRead), .MemWrite(MemWrite), .RegDst(RegDst),
          .MemToReg(MemToReg), .RegWrite(RegWrite)
        );

assign JumpHazard = PCSrc == 3'b001 || PCSrc == 3'b010;

wire [31:0] pc_on_break;
PCOnBreak pc_on_brk(
            .clk(clk), .reset(reset),
            .wr_en(~(DataHazard || JumpHazard || BranchHazard || Branch)),
            .pc_in(pc), .pc_on_break(pc_on_break)
          );

// Determine dest register
wire [4:0] write_addr;
assign write_addr =
       ExceptionOrInterrupt ? 5'd26 : // $k0
       (RegDst == 2'b00) ? if_id.instr[20:16] :
       (RegDst == 2'b01) ? if_id.instr[15:11] :
       5'd31; // $ra

// Read register A and B
// WB's writing register also implemented here
wire [31:0] rs;
wire [31:0] rt;
RegisterFile reg_file(
               .clk(clk), .reset(reset),
               .RegWrite(mem_wb.RegWrite), .write_addr(mem_wb.write_addr), .write_data(mem_wb.mem_data),
               .read_addr_1(if_id.instr[25:21]), .read_addr_2(if_id.instr[20:16]),
               .read_data_1(rs), .read_data_2(rt)
             );

// Forward to ID if necessary
wire [1:0] ForwardA_ID;
wire ForwardB_ID;
wire [1:0] ForwardA_EX;
wire [1:0] ForwardB_EX;
ForwardControl forward_ctr(
                 .reset(reset), .rs_addr(if_id.instr[25:21]), .rt_addr(if_id.instr[20:16]),
                 .id_ex_RegWrite(id_ex.RegWrite), .id_ex_write_addr(id_ex.write_addr),
                 .ex_mem_RegWrite(ex_mem.RegWrite), .ex_mem_write_addr(ex_mem.write_addr),
                 .mem_wb_RegWrite(mem_wb.RegWrite), .mem_wb_write_addr(mem_wb.write_addr),
                 .ForwardA_ID(ForwardA_ID), .ForwardB_ID(ForwardB_ID),
                 .ForwardA_EX(ForwardA_EX), .ForwardB_EX(ForwardB_EX)
               );

wire [31:0] latest_rs_id =
     ForwardA_ID == 2'b00 ? rs :
     ForwardA_ID == 2'b10 ? ex_mem.alu_out :
     mem_wb.mem_data;

wire [31:0] latest_rt_id = ForwardB_ID ? mem_wb.mem_data : rt;

// Detect hazard
HazardUnit hazard_unit(
             .PCSrc(PCSrc), .if_id_rs_addr(if_id.instr[25:21]), .if_id_rt_addr(if_id.instr[20:16]),
             .id_ex_RegWrite(id_ex.RegWrite), .id_ex_MemRead(id_ex.MemRead), .id_ex_write_addr(id_ex.write_addr),
             .ex_mem_MemRead(ex_mem.MemRead), .ex_mem_write_addr(ex_mem.write_addr),
             .DataHazard(DataHazard)
           );

// Handle exception, jump or branch
wire [31:0] jump_target;
wire [31:0] branch_target;
assign jump_target = {if_id.pc_next[31:28], if_id.instr[25:0], 2'b00};
assign pc_next =
       BranchHazard ? branch_target :
       PCSrc == 3'b000 ? pc_plus_4 :
       PCSrc == 3'b001 ? jump_target :
       PCSrc == 3'b010 ? latest_rs_id :
       PCSrc == 3'b011 ? 32'h80000004 :
       32'h80000008;

// Extend immediate
wire [31:0] ext_out;
assign ext_out = {ExtOp ? {16{if_id.instr[15]}} : 16'h0000, if_id.instr[15:0]};
wire [31:0] imm_out;
assign imm_out = LuOp ? {if_id.instr[15:0], 16'h0000} : ext_out;

// Store control signals, reg A, B and immediate in ID/EX Register
ID_EX_Reg id_ex(
            .clk(clk), .reset(reset), .Flush(DataHazard || BranchHazard),
            .shamt_in(if_id.instr[10:6]), .funct_in(if_id.instr[5:0]), .write_addr_in(write_addr),
            .rs_in(latest_rs_id), .rt_in(latest_rt_id), .imm_in(imm_out),
            .pc_next_in(ExceptionOrInterrupt ? pc_on_break : if_id.pc_next),
            .Branch_in(Branch), .ALUOp_in(ALUOp), .ALUSrc1_in(ALUSrc1), .ALUSrc2_in(ALUSrc2), .RegDst_in(RegDst),
            .ForwardA_EX_in(ForwardA_EX), .ForwardB_EX_in(ForwardB_EX),
            .MemRead_in(MemRead),	.MemWrite_in(MemWrite),
            .MemToReg_in(MemToReg), .RegWrite_in(RegWrite)
          );

// STAGE 3: EX
wire [4:0] ALUCtl;
wire Sign;
ALUControl alu_control(.ALUOp(id_ex.ALUOp), .funct(id_ex.funct), .ALUCtl(ALUCtl), .Sign(Sign));

wire [31:0] latest_rs =
     id_ex.ForwardA_EX == 2'b00 ? id_ex.rs :
     id_ex.ForwardA_EX == 2'b10 ? ex_mem.alu_out :
     mem_wb.mem_data;
wire [31:0] latest_rt =
     id_ex.ForwardB_EX == 2'b00 ? id_ex.rt :
     id_ex.ForwardB_EX == 2'b10 ? ex_mem.alu_out :
     mem_wb.mem_data;
wire [31:0] alu_in_1 = id_ex.ALUSrc1 ? {27'h00000, id_ex.shamt} : latest_rs;
wire [31:0] alu_in_2 = id_ex.ALUSrc2 ? id_ex.imm : latest_rt;

wire [31:0] alu_out;
wire Zero;
ALU alu1(.in_1(alu_in_1), .in_2(alu_in_2), .ALUCtl(ALUCtl), .Sign(Sign), .out(alu_out), .zero(Zero));

wire Equal = latest_rs == latest_rt;
assign BranchHazard = id_ex.Branch & Equal;
assign branch_target =  id_ex.pc_next + {id_ex.imm[29:0], 2'b00};

EX_MEM_Reg ex_mem(
             .clk(clk), .reset(reset),
             .alu_out_in(alu_out), .rt_in(latest_rt), .write_addr_in(id_ex.write_addr), .pc_next_in(id_ex.pc_next),
             .MemRead_in(id_ex.MemRead), .MemWrite_in(id_ex.MemWrite),
             .MemToReg_in(id_ex.MemToReg), .RegWrite_in(id_ex.RegWrite)
           );

// STAGE 4: MEM
wire [31:0] mem_out;
Bus bus(
      .clk(clk), .reset(reset), .pc({1'b0, pc[30:0]}),
      .MemRead(ex_mem.MemRead), .MemWrite(ex_mem.MemWrite),
      .address(ex_mem.alu_out), .write_data(ex_mem.rt),
      .uart_on(uart_on), .uart_mode(uart_mode), .uart_ram_id(uart_ram_id), .Rx_Serial(Rx_Serial),
      .instruction(instruction), .read_data(mem_out),
      .IRQ(IRQ), .led(led), .ssd(ssd), .Tx_Serial(Tx_Serial)
    );

wire [31:0] mem_data =
     (ex_mem.MemToReg == 2'b00) ? ex_mem.alu_out :
     (ex_mem.MemToReg == 2'b01) ? mem_out :
     ex_mem.pc_next;

MEM_WB_Reg mem_wb(
             .clk(clk), .reset(reset),
             .write_addr_in(ex_mem.write_addr), .mem_data_in(mem_data),
             .MemToReg_in(ex_mem.MemToReg), .RegWrite_in(ex_mem.RegWrite)
           );

// STAGE 5: WB
// This only contains a memory write operation, thus the codes are specified in ID stage.

endmodule
