module InstructionMemory(address, instruction);
input [31:0] address;
output reg [31:0] instruction;

always @(*)
  case (address[9:2])
    8'd0:
      instruction = 32'h20040003; // addi $a0, $zero, 3
    8'd1:
      instruction = 32'h0c000003; // jal sum
    8'd2:
      instruction = 32'h1000ffff; // Loop: beq $zero, $zero, Loop
    8'd3:
      instruction = 32'h23bdfff8; // Sum: addi $sp, $sp, -8
    8'd4:
      instruction = 32'hafbf0004; // sw $ra, 4($sp)
    8'd5:
      instruction = 32'hafa40000; // sw $a0, 0($sp)
    8'd6:
      instruction = 32'h28880001; // slti $t0, $a0, 1
    8'd7:
      instruction = 32'h11000003; // beq $t0, $zero, L1
    8'd8:
      instruction = 32'h00001026; // xor $v0, $zero, $zero
    8'd9:
      instruction = 32'h23bd0008; // addi $sp, $sp, 8
    8'd10:
      instruction = 32'h03e00008; // jr $ra
    8'd11:
      instruction = 32'h2084ffff; // L1: addi $a0, $a0, -1
    8'd12:
      instruction = 32'h0c000003; // jal sum
    8'd13:
      instruction = 32'h8fa40000; // lw $a0, 0($sp)
    8'd14:
      instruction = 32'h8fbf0004; // lw $ra, 4($sp)
    8'd15:
      instruction = 32'h13ff0000; // beq $ra, $ra, L2
    8'd16:
      instruction = 32'h23bd0008; // L2: addi $sp, $sp, 8
    8'd17:
      instruction = 32'h00821020; // add $v0, $a0, $v0
    8'd18:
      instruction = 32'h03e00008; // jr $ra
    default:
      instruction = 32'h00000000;
  endcase

endmodule
