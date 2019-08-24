module Control(
         Supervised, IRQ, opcode, funct,
         ExceptionOrInterrupt,
         PCSrc, Branch, ExtOp, LuOp,
         ALUOp, ALUSrc1, ALUSrc2, RegDst,
         MemRead, MemWrite,
         MemtoReg, RegWrite
       );
input Supervised;
input IRQ;
input [5:0] opcode;
input [5:0] funct;

// ID control
output ExceptionOrInterrupt;
output reg [2:0] PCSrc;
output Branch;
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

wire Unsupported;
assign Unsupported =
       ~ ((opcode >= 6'h01 && opcode <= 6'h0d) ||
          (opcode == 6'h0f || opcode == 6'h23 || opcode == 6'h2b) ||
          (opcode == 6'h00 &&
           (funct == 6'h00 ||
            funct == 6'h02 ||
            funct == 6'h03 ||
            funct == 6'h08 ||
            funct == 6'h09 ||
            funct == 6'h2a ||
            funct == 6'h2b ||
            (funct >= 6'h20 && funct <= 6'h27)
           )
          ));

assign ExceptionOrInterrupt = ~Supervised && (IRQ || Unsupported);

always @ (*)
  begin
    if (~Supervised && IRQ)
      PCSrc = 3'b011;
    else if (~Supervised && Unsupported)
      PCSrc = 3'b100;
    else
      PCSrc =
        (opcode == 6'h02 || opcode == 6'h03) ? 3'b001 : // j, jal
        (opcode == 6'h00 && (funct == 6'h08 || funct == 6'h09)) ? 3'b010 : // jr, jalr
        3'b000;
  end

assign Branch = (opcode == 6'h04) && ~ExceptionOrInterrupt;

assign ExtOp = ~(opcode == 6'h0c || opcode == 6'h0d); // andi, ori

assign LuOp = (opcode == 6'h0f);

assign ALUOp[2:0] =
       (opcode == 6'h00) ? 3'b010: // R-type and jr, jalr
       (opcode == 6'h04) ? 3'b001: // beq
       (opcode == 6'h0c) ? 3'b100: // andi
       (opcode == 6'h0d) ? 3'b101: // ori
       (opcode == 6'h0a || opcode == 6'h0b)? 3'b110: // slti or sltiu
       3'b000; // addi, addiu, etc.

assign ALUOp[3] = opcode[0];

assign ALUSrc1 =
       (opcode == 6'h00 && (funct == 6'h00 || funct == 6'h02 || funct == 6'h03));

assign ALUSrc2 =
       ~(opcode == 6'h00 || opcode == 6'h04);

assign RegDst[1:0] =
       ExceptionOrInterrupt ? 2'b11 :
       (opcode == 6'h03) ? 2'b10 : // jal
       (opcode == 6'h00) ? 2'b01 : // R-type
       2'b00; // I-type

assign MemRead = (opcode == 6'h23) & ~ExceptionOrInterrupt;

assign MemWrite = (opcode == 6'h2b) & ~ExceptionOrInterrupt;

assign MemtoReg[1:0] =
       (ExceptionOrInterrupt || (opcode == 6'h03 || (opcode == 6'h00 && funct == 6'h09))) ? 2'b10 :  // next PC
       (opcode == 6'h23) ? 2'b01: // MEM out
       2'b00; // ALU out

assign RegWrite =
       ExceptionOrInterrupt ||
       ~((opcode == 6'h2b || opcode == 6'h04 || opcode == 6'h02) || // not branch or jump
         (opcode == 6'h00 && funct == 6'h08));  // not jr

endmodule
