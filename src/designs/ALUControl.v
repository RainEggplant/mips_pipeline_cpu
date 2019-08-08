module ALUControl(ALUOp, Funct, ALUCtl, Sign);
input [3:0] ALUOp;
input [5:0] Funct;
output reg [4:0] ALUCtl;
output Sign;

parameter ALU_AND = 5'b00000;
parameter ALU_OR  = 5'b00001;
parameter ALU_ADD = 5'b00010;
parameter ALU_SUB = 5'b00110;
parameter ALU_SLT = 5'b00111;
parameter ALU_NOR = 5'b01100;
parameter ALU_XOR = 5'b01101;
parameter ALU_SLL = 5'b10000;
parameter ALU_SRL = 5'b11000;
parameter ALU_SRA = 5'b11001;

// ALUOp[2:0] == 3'b010 includes the following instructions (R-type and jr, jalr):
//   add, addu, sub, subu, and, or, xor, nor, sll, srl, sra, slt, sltu, jr, jalr
// Funct[0] == 1 for addu, subu, or, nor, sra, sltu, jalr.
// If ALUOp[2:0] != 3'b010, we look at ALUOp[3], which equals OpCode[0].
// We only care about instructions that use the ALU, so they are:
//   lw, sw, lui, addi, addiu, andi, slti, sltiu, beq
// ALUOp[3] == 1 for lw, sw, lui, addiu, sltiu.
// Then we see that ALUOp[3] of the unsigned instructions is 1.
// Thus, for all unsigned instructions, Sign = 0.
assign Sign = (ALUOp[2:0] == 3'b010)? ~Funct[0]: ~ALUOp[3];

reg [4:0] aluFunct;
always @(*)
  // For R-type instructions
  case (Funct)
    6'b00_0000:
      aluFunct = ALU_SLL;
    6'b00_0010:
      aluFunct = ALU_SRL;
    6'b00_0011:
      aluFunct = ALU_SRA;
    6'b10_0000:
      aluFunct = ALU_ADD;
    6'b10_0001:
      aluFunct = ALU_ADD;
    6'b10_0010:
      aluFunct = ALU_SUB;
    6'b10_0011:
      aluFunct = ALU_SUB;
    6'b10_0100:
      aluFunct = ALU_AND;
    6'b10_0101:
      aluFunct = ALU_OR;
    6'b10_0110:
      aluFunct = ALU_XOR;
    6'b10_0111:
      aluFunct = ALU_NOR;
    6'b10_1010:
      aluFunct = ALU_SLT;
    6'b10_1011:
      aluFunct = ALU_SLT;
    default:
      aluFunct = ALU_ADD;
  endcase

always @(*)
  case (ALUOp[2:0])
    3'b000:
      ALUCtl = ALU_ADD;
    3'b001:
      ALUCtl = ALU_SUB;
    3'b100:
      ALUCtl = ALU_AND;
    3'b101:
      ALUCtl = ALU_SLT;
    3'b010:
      ALUCtl = aluFunct;
    default:
      ALUCtl = ALU_ADD;
  endcase

endmodule
