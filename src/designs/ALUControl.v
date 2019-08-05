
module ALUControl(ALUOp, Funct, ALUCtl, Sign);
	input [3:0] ALUOp;
	input [5:0] Funct;
	output reg [4:0] ALUCtl;
	output Sign;
	
	parameter aluAND = 5'b00000;
	parameter aluOR  = 5'b00001;
	parameter aluADD = 5'b00010;
	parameter aluSUB = 5'b00110;
	parameter aluSLT = 5'b00111;
	parameter aluNOR = 5'b01100;
	parameter aluXOR = 5'b01101;
	parameter aluSLL = 5'b10000;
	parameter aluSRL = 5'b11000;
	parameter aluSRA = 5'b11001;
	
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
			6'b00_0000: aluFunct <= aluSLL;
			6'b00_0010: aluFunct <= aluSRL;
			6'b00_0011: aluFunct <= aluSRA;
			6'b10_0000: aluFunct <= aluADD;
			6'b10_0001: aluFunct <= aluADD;
			6'b10_0010: aluFunct <= aluSUB;
			6'b10_0011: aluFunct <= aluSUB;
			6'b10_0100: aluFunct <= aluAND;
			6'b10_0101: aluFunct <= aluOR;
			6'b10_0110: aluFunct <= aluXOR;
			6'b10_0111: aluFunct <= aluNOR;
			6'b10_1010: aluFunct <= aluSLT;
			6'b10_1011: aluFunct <= aluSLT;
			default: aluFunct <= aluADD;
		endcase
	
	always @(*)
		case (ALUOp[2:0])
			3'b000: ALUCtl <= aluADD;
			3'b001: ALUCtl <= aluSUB;
			3'b100: ALUCtl <= aluAND;
			3'b101: ALUCtl <= aluSLT;
			3'b010: ALUCtl <= aluFunct;
			default: ALUCtl <= aluADD;
		endcase

endmodule
