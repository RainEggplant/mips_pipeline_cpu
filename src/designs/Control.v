module Control(
         opcode, funct,
         ExtOp, LuOp,
         ALUOp, ALUSrc1, ALUSrc2, RegDst,
         MemRead, MemWrite,
         MemtoReg, RegWrite, PCSrc, Branch
       );
input [5:0] opcode;
input [5:0] funct;

// ID control
output ExtOp;
output LuOp;

// EX control
output [3:0] ALUOp;
output ALUSrc1;
output ALUSrc2;
output [1:0] RegDst;

// Mem control
output MemRead;
output MemWrite;

// WB control
output [1:0] MemtoReg;
output RegWrite;

output [1:0] PCSrc;
output Branch;


assign ExtOp = ~(opcode == 6'h0c);

assign LuOp = (opcode == 6'h0f);

assign ALUOp[2:0] =
       (opcode == 6'h00)? 3'b010: // R-type and jr, jalr
       (opcode == 6'h04)? 3'b001: // beq
       (opcode == 6'h0c)? 3'b100: // andi
       (opcode == 6'h0a || opcode == 6'h0b)? 3'b101: // slti or sltiu
       3'b000; // addi, addiu, etc.

assign ALUOp[3] = opcode[0];

assign ALUSrc1 =
       (opcode == 6'h00 && (funct == 6'h00 || funct == 6'h02 || funct == 6'h03));

assign ALUSrc2 =
       ~(opcode == 6'h00 || opcode == 6'h04);

assign RegDst[1:0] =
       (opcode == 6'h03)? 2'b10:
       (opcode == 6'h00)? 2'b01:
       2'b00;

assign MemRead = (opcode == 6'h23);

assign MemWrite = (opcode == 6'h2b);

assign MemtoReg[1:0] =
       (opcode == 6'h23)? 2'b01:
       (opcode == 6'h03 || (opcode == 6'h00 && funct == 6'h09))? 2'b10:
       2'b00;

assign RegWrite =
       ~((opcode == 6'h2b || opcode == 6'h04 || opcode == 6'h02)
         || (opcode == 6'h00 && funct == 6'h08));

assign PCSrc[1:0] =
       (opcode == 6'h02 || opcode == 6'h03)? 2'b01: // j, jal
       (opcode == 6'h00 && (funct == 6'h08 || funct == 6'h09))? 2'b10: // jr, jalr
       2'b00;

assign Branch = (opcode == 6'h04);

endmodule
