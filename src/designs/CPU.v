module CPU(reset, clk);
input reset, clk;

reg [31:0] pc;
wire [31:0] pc_next;
always @(posedge reset or posedge clk)
  if (reset)
    pc <= 32'h00000000;
  else
    pc <= pc_next;

wire [31:0] pc_plus_4;
assign pc_plus_4 = pc + 32'd4;

wire [31:0] instruction;
InstructionMemory instr_mem_1(.address(pc), .instruction(instruction));

wire [1:0] RegDst;
wire [1:0] PCSrc;
wire Branch;
wire MemRead;
wire [1:0] MemtoReg;
wire [3:0] ALUOp;
wire ExtOp;
wire LuOp;
wire MemWrite;
wire ALUSrc1;
wire ALUSrc2;
wire RegWrite;

Control control_1(.OpCode(instruction[31:26]), .Funct(instruction[5:0]),
                  .PCSrc(PCSrc), .Branch(Branch), .RegWrite(RegWrite), .RegDst(RegDst),
                  .MemRead(MemRead),	.MemWrite(MemWrite), .MemtoReg(MemtoReg),
                  .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp),	.ALUOp(ALUOp));

wire [31:0] data_bus_reg_a;
wire [31:0] data_bus_reg_b;
wire [31:0] data_bus_mem;
wire [4:0] write_addr;
assign write_addr = (RegDst == 2'b00)? instruction[20:16]: (RegDst == 2'b01)? instruction[15:11]: 5'b11111;
RegisterFile reg_file_1(.clk(clk), .reset(reset),
                        .RegWrite(RegWrite), .write_addr(write_addr), .write_data(data_bus_mem),
                        .read_addr_1(instruction[25:21]), .read_addr_2(instruction[20:16]),
                        .read_data_1(data_bus_reg_a), .read_data_2(data_bus_reg_b));

wire [31:0] ext_out;
assign ext_out = {ExtOp? {16{instruction[15]}}: 16'h0000, instruction[15:0]};

wire [31:0] lu_out;
assign lu_out = LuOp? {instruction[15:0], 16'h0000}: ext_out;

wire [4:0] ALUCtl;
wire Sign;
ALUControl alu_control_1(.ALUOp(ALUOp), .Funct(instruction[5:0]), .ALUCtl(ALUCtl), .Sign(Sign));

wire [31:0] alu_in_1;
wire [31:0] alu_in_2;
wire [31:0] alu_out;
wire Zero;
assign alu_in_1 = ALUSrc1? {27'h00000, instruction[10:6]}: data_bus_reg_a;
assign alu_in_2 = ALUSrc2? lu_out: data_bus_reg_b;
ALU alu1(.in_1(alu_in_1), .in_2(alu_in_2), .ALUCtl(ALUCtl), .Sign(Sign), .out(alu_out), .zero(Zero));

wire [31:0] read_data;
DataMemory data_mem_1(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .address(alu_out),
                      .write_data(data_bus_reg_b), .read_data(read_data));
assign data_bus_mem = (MemtoReg == 2'b00)? alu_out: (MemtoReg == 2'b01)? read_data: pc_plus_4;

wire [31:0] jump_target;
assign jump_target = {pc_plus_4[31:28], instruction[25:0], 2'b00};

wire [31:0] branch_target;
assign branch_target = (Branch & Zero)? pc_plus_4 + {lu_out[29:0], 2'b00}: pc_plus_4;

assign pc_next = (PCSrc == 2'b00)? branch_target: (PCSrc == 2'b01)? jump_target: data_bus_reg_a;

endmodule

