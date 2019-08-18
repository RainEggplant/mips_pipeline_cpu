module ForwardControl_ID(
         reset, if_id_rs_addr, if_id_rt_addr,
         ex_mem_RegWrite, ex_mem_write_addr,
         ForwardA_ID, ForwardB_ID
       );
input reset;
input [4:0] if_id_rs_addr;
input [4:0] if_id_rt_addr;
input ex_mem_RegWrite;
input [4:0] ex_mem_write_addr;
output reg ForwardA_ID;
output reg ForwardB_ID;

always @ (*)
  begin
    if (~reset)
      begin
        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == if_id_rs_addr)
        )
          ForwardA_ID = 1;
        else
          ForwardA_ID = 0;

        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == if_id_rt_addr)
        )
          ForwardB_ID = 1;
        else
          ForwardB_ID = 0;

      end
    else
      begin
        ForwardA_ID = 0;
        ForwardB_ID = 0;
      end
  end

endmodule
