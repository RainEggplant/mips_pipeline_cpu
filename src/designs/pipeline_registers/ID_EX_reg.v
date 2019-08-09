/* verilator lint_off UNUSED */

module ID_EX_reg(clk, wr_en,
                 PCSrc_in, Branch_in, RegWrite_in, RegDst_in, MemRead_in, MemWrite_in, MemtoReg_in,
                 ALUSrc1_in, ALUSrc2_in, ALUOp_in, reg_a_in, reg_b_in, imm_in);
input clk;
input wr_en;
input [1:0] PCSrc_in;
input Branch_in;
input RegWrite_in;
input [1:0] RegDst_in;
input MemRead_in;
input MemWrite_in;
input [1:0] MemtoReg_in;
input ALUSrc1_in;
input ALUSrc2_in;
input [3:0] ALUOp_in;
input [31:0] reg_a_in;
input [31:0] reg_b_in;
input [31:0] imm_in;

reg [1:0] PCSrc;
reg Branch;
reg RegWrite;
reg [1:0] RegDst;
reg MemRead;
reg MemWrite;
reg [1:0] MemtoReg;
reg ALUSrc1;
reg ALUSrc2;
reg [3:0] ALUOp;
reg [31:0] reg_a;
reg [31:0] reg_b;
reg [31:0] imm;

always @ (posedge clk)
  begin
    if (wr_en)
      begin
        PCSrc <= PCSrc_in;
        Branch <= Branch_in;
        RegWrite <= RegWrite_in;
        RegDst <= RegDst_in;
        MemRead <= MemRead_in;
        MemWrite <= MemWrite_in;
        MemtoReg <= MemtoReg_in;
        ALUSrc1 <= ALUSrc1_in;
        ALUSrc2 <= ALUSrc2_in;
        ALUOp <= ALUOp_in;
        reg_a <= reg_a_in;
        reg_b <= reg_b_in;
        imm <= imm_in;
      end
  end

endmodule
