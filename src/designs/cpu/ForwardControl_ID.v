module ForwardControl_ID(
         reset, if_id_rs_addr,
         ex_mem_RegWrite, ex_mem_write_addr,
         mem_wb_RegWrite, mem_wb_write_addr,
         ForwardA_ID
       );
input reset;
input [4:0] if_id_rs_addr;
input ex_mem_RegWrite;
input [4:0] ex_mem_write_addr;
input mem_wb_RegWrite;
input [4:0] mem_wb_write_addr;
output reg [1:0] ForwardA_ID;

always @ (*)
  begin
    if (~reset)
      begin
        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == if_id_rs_addr)
        )
          ForwardA_ID = 2'b10;
        else if (
          mem_wb_RegWrite
          && (mem_wb_write_addr != 0)
          && (mem_wb_write_addr == if_id_rs_addr)
        )
          ForwardA_ID = 2'b01;
        else
          ForwardA_ID = 2'b00;
      end
    else
      begin
        ForwardA_ID = 2'b00;
      end
  end

endmodule
