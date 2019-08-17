module ForwardControl(
         reset, rs_addr, rt_addr,
         ex_mem_RegWrite, ex_mem_write_addr,
         mem_wb_RegWrite, mem_wb_write_addr,
         ForwardA, ForwardB);
input reset;
input [4:0] rs_addr;
input [4:0] rt_addr;
input ex_mem_RegWrite;
input mem_wb_RegWrite;
input [4:0] ex_mem_write_addr;
input [4:0] mem_wb_write_addr;
output reg [1:0] ForwardA;
output reg [1:0] ForwardB;

always @ (*)
  begin
    if (~reset)
      begin
        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == rs_addr)
        )
          ForwardA = 2'b10;
        else if (
          mem_wb_RegWrite
          && (mem_wb_write_addr != 0)
          && (mem_wb_write_addr == rs_addr)
        )
          ForwardA = 2'b01;
        else
          ForwardA = 2'b00;

        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == rt_addr)
        )
          ForwardB = 2'b10;
        else if (
          mem_wb_RegWrite
          && (mem_wb_write_addr != 0)
          && (mem_wb_write_addr == rt_addr)
        )
          ForwardB = 2'b01;
        else
          ForwardB = 2'b00;

      end
    else
      begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;
      end
  end

endmodule
