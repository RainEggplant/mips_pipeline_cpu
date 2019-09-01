module ForwardControl(
         reset, rs_addr, rt_addr,
         id_ex_RegWrite, id_ex_write_addr,
         ex_mem_RegWrite, ex_mem_write_addr,
         mem_wb_RegWrite, mem_wb_write_addr,
         ForwardA_ID, ForwardB_ID, ForwardA_EX, ForwardB_EX
       );
input reset;
input [4:0] rs_addr;
input [4:0] rt_addr;
input id_ex_RegWrite;
input [4:0] id_ex_write_addr;
input ex_mem_RegWrite;
input [4:0] ex_mem_write_addr;
input mem_wb_RegWrite;
input [4:0] mem_wb_write_addr;
output reg [1:0] ForwardA_ID;
output reg ForwardB_ID;
output reg [1:0] ForwardA_EX;
output reg [1:0] ForwardB_EX;

always @ (*)
  begin
    if (~reset)
      begin
        // Forwarding for ID stage
        if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == rs_addr)
        )
          ForwardA_ID = 2'b10;
        else if (
          mem_wb_RegWrite
          && (mem_wb_write_addr != 0)
          && (mem_wb_write_addr == rs_addr)
        )
          ForwardA_ID = 2'b01;
        else
          ForwardA_ID = 2'b00;

        // There is no need to forward for rt from ex_mem during ID,
        // because that will be done in EX
        if (
          mem_wb_RegWrite
          && (mem_wb_write_addr != 0)
          && (mem_wb_write_addr == rt_addr)
        )
          ForwardB_ID = 1;
        else
          ForwardB_ID = 0;

        // Forwarding for EX stage
        if (
          id_ex_RegWrite
          && (id_ex_write_addr != 0)
          && (id_ex_write_addr == rs_addr)
        )
          ForwardA_EX = 2'b10;
        else if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == rs_addr)
        )
          ForwardA_EX = 2'b01;
        else
          ForwardA_EX = 2'b00;

        if (
          id_ex_RegWrite
          && (id_ex_write_addr != 0)
          && (id_ex_write_addr == rt_addr)
        )
          ForwardB_EX = 2'b10;
        else if (
          ex_mem_RegWrite
          && (ex_mem_write_addr != 0)
          && (ex_mem_write_addr == rt_addr)
        )
          ForwardB_EX = 2'b01;
        else
          ForwardB_EX = 2'b00;

      end
    else
      begin
        ForwardA_ID = 2'b00;
        ForwardB_ID = 0;
        ForwardA_EX = 2'b00;
        ForwardB_EX = 2'b00;
      end
  end

endmodule
