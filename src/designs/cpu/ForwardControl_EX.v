module ForwardControl_EX(
         reset, id_ex_rs_addr, id_ex_rt_addr,
         ex_mem_RegWrite, ex_mem_write_addr,
         mem_wb_RegWrite, mem_wb_write_addr,
         ForwardA_EX, ForwardB_EX
       );
input reset;
input [4:0] id_ex_rs_addr;
input [4:0] id_ex_rt_addr;
input ex_mem_RegWrite;
input [4:0] ex_mem_write_addr;
input mem_wb_RegWrite;
input [4:0] mem_wb_write_addr;
output reg [1:0] ForwardA_EX;
output reg [1:0] ForwardB_EX;

always @ (*)
  begin
    if (~reset)
      begin
        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == id_ex_rs_addr)
        )
          ForwardA_EX = 2'b10;
        else if (
          mem_wb_RegWrite
          && (mem_wb_write_addr != 0)
          && (mem_wb_write_addr == id_ex_rs_addr)
        )
          ForwardA_EX = 2'b01;
        else
          ForwardA_EX = 2'b00;

        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == id_ex_rt_addr)
        )
          ForwardB_EX = 2'b10;
        else if (
          mem_wb_RegWrite
          && (mem_wb_write_addr != 0)
          && (mem_wb_write_addr == id_ex_rt_addr)
        )
          ForwardB_EX = 2'b01;
        else
          ForwardB_EX = 2'b00;

      end
    else
      begin
        ForwardA_EX = 2'b00;
        ForwardB_EX = 2'b00;
      end
  end

endmodule
