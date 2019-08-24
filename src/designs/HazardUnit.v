module HazardUnit(
         ExceptionOrInterrupt, PCSrc, Branch, Equal,
         if_id_rs_addr, if_id_rt_addr,
         id_ex_RegWrite, id_ex_MemRead, id_ex_write_addr,
         ex_mem_MemRead, ex_mem_write_addr,
         DataHazard, ControlHazard
       );
input ExceptionOrInterrupt;
input [2:0] PCSrc;
input Branch;
input Equal;
input [4:0] if_id_rs_addr;
input [4:0] if_id_rt_addr;
input id_ex_RegWrite;
input id_ex_MemRead;
input [4:0] id_ex_write_addr;
input ex_mem_MemRead;
input [4:0] ex_mem_write_addr;
output DataHazard;
output ControlHazard;

wire prev =
     id_ex_write_addr != 0 &&
     (if_id_rs_addr == id_ex_write_addr || if_id_rt_addr == id_ex_write_addr);
wire prev_2nd =
     ex_mem_write_addr != 0 &&
     (if_id_rs_addr == ex_mem_write_addr || if_id_rt_addr == ex_mem_write_addr);
wire lw = id_ex_MemRead && prev;
assign DataHazard =
       lw ||
       ((PCSrc == 3'b010 || Branch) && ((id_ex_RegWrite && prev) || (ex_mem_MemRead && prev_2nd)));
assign ControlHazard =
       ExceptionOrInterrupt ||
       PCSrc == 3'b001 || // j, jal
       (~DataHazard && (PCSrc == 3'b010 || (Branch && Equal)));

endmodule
