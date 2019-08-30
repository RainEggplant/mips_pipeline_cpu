/* verilator lint_off UNUSED */

module ID_EX_Reg(
         clk, reset, Flush,
         rs_addr_in, rt_addr_in, rd_addr_in, shamt_in, funct_in, write_addr_in,
         rs_in, rt_in, imm_in, pc_next_in,
         Branch_in, ALUOp_in, ALUSrc1_in, ALUSrc2_in, RegDst_in,
         MemRead_in, MemWrite_in,
         MemtoReg_in, RegWrite_in
       );
input clk;
input reset;
input Flush;

// ID data
input [4:0] rs_addr_in;
input [4:0] rt_addr_in;
input [4:0] rd_addr_in;
input [4:0] shamt_in;
input [5:0] funct_in;
input [4:0] write_addr_in;
input [31:0] rs_in;
input [31:0] rt_in;
input [31:0] imm_in;
input [31:0] pc_next_in;

// EX control
input Branch_in;
input [3:0] ALUOp_in;
input ALUSrc1_in;
input ALUSrc2_in;
input [1:0] RegDst_in;

// Mem control
input MemRead_in;
input MemWrite_in;

// WB control
input [1:0] MemtoReg_in;
input RegWrite_in;

reg [4:0] rs_addr;
reg [4:0] rt_addr;
reg [4:0] rd_addr;
reg [4:0] shamt;
reg [5:0] funct;
reg [4:0] write_addr;
reg [31:0] rs;
reg [31:0] rt;
reg [31:0] imm;
reg [31:0] pc_next;
reg Branch;
reg [3:0] ALUOp;
reg ALUSrc1;
reg ALUSrc2;
reg [1:0] RegDst;
reg MemRead;
reg MemWrite;
reg [1:0] MemtoReg;
reg RegWrite;

always @ (posedge clk)
  begin
    if (~reset)
      begin
        rs_addr <= rs_addr_in;
        rt_addr <= rt_addr_in;
        rd_addr <= rd_addr_in;
        shamt <= shamt_in;
        funct <= funct_in;
        write_addr <= write_addr_in;
        rs <= rs_in;
        rt <= rt_in;
        imm <= imm_in;
        pc_next <= pc_next_in;
        Branch <= Branch_in;
        ALUOp <= ALUOp_in;
        ALUSrc1 <= ALUSrc1_in;
        ALUSrc2 <= ALUSrc2_in;
        RegDst <= RegDst_in;
        MemRead <= Flush ? 0 : MemRead_in;
        MemWrite <= Flush ? 0 : MemWrite_in;
        MemtoReg <= MemtoReg_in;
        RegWrite <= Flush ? 0 : RegWrite_in;
      end
    else
      begin
        rs_addr <= 5'b00000;
        rt_addr <= 5'b00000;
        rd_addr <= 5'b00000;
        shamt <= 5'b00000;
        funct <= 6'b000000;
        write_addr <= 5'b00000;
        rs <= 32'h00000000;
        rt <= 32'h00000000;
        imm <= 32'h00000000;
        pc_next <= 32'h00000000;
        Branch <= 0;
        ALUOp <= 4'b0000;
        ALUSrc1 <= 0;
        ALUSrc2 <= 0;
        RegDst <= 2'b00;
        MemRead <= 0;
        MemWrite <= 0;
        MemtoReg <= 2'b00;
        RegWrite <= 0;
      end
  end
endmodule
