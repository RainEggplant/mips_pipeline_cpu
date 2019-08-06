module Control(OpCode, Funct,
               PCSrc, Branch, RegWrite, RegDst,
               MemRead, MemWrite, MemtoReg,
               ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUOp);
input [5:0] OpCode;
input [5:0] Funct;
output [1:0] PCSrc;
output Branch;
output RegWrite;
output [1:0] RegDst;
output MemRead;
output MemWrite;
output [1:0] MemtoReg;
output ALUSrc1;
output ALUSrc2;
output ExtOp;
output LuOp;
output [3:0] ALUOp;

// Your code below
assign PCSrc[1:0] =
       (OpCode == 6'h02 || OpCode == 6'h03)? 2'b01:
       (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))? 2'b10:
       2'b00;

assign Branch = (OpCode == 6'h04);

assign RegWrite =
       ~((OpCode == 6'h2b || OpCode == 6'h04 || OpCode == 6'h02)
         || (OpCode == 6'h00 && Funct == 6'h08));

assign RegDst[1:0] =
       (OpCode == 6'h03)? 2'b10:
       (OpCode == 6'h00)? 2'b01:
       2'b00;

assign MemRead = (OpCode == 6'h23);

assign MemWrite = (OpCode == 6'h2b);

assign MemtoReg[1:0] =
       (OpCode == 6'h23)? 2'b01:
       (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'b10:
       2'b00;

assign ALUSrc1 =
       (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03));

assign ALUSrc2 =
       ~(OpCode == 6'h00 || OpCode == 6'h04);

assign ExtOp =
       ~(OpCode == 6'h0c);

assign LuOp = (OpCode == 6'h0f);

// Your code above

assign ALUOp[2:0] =
       (OpCode == 6'h00)? 3'b010: // R-type and jr, jalr
       (OpCode == 6'h04)? 3'b001: // beq
       (OpCode == 6'h0c)? 3'b100: // andi
       (OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: // slti or sltiu
       3'b000; // addi, addiu, etc.

assign ALUOp[3] = OpCode[0];

endmodule
