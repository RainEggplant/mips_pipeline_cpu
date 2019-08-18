module HazardUnit(
         if_id_PCSrc, if_id_Branch, if_id_Equal, if_id_rs_addr, if_id_rt_addr,
         id_ex_RegWrite, id_ex_MemRead, id_ex_write_addr,
         ex_mem_MemRead, ex_mem_write_addr, DataHazard, ControlHazard);
input [1:0] if_id_PCSrc;
input if_id_Branch;
input if_id_Equal;
input [4:0] if_id_rs_addr;
input [4:0] if_id_rt_addr;
input id_ex_RegWrite;
input id_ex_MemRead;
input [4:0] id_ex_write_addr;
input ex_mem_MemRead;
input [4:0] ex_mem_write_addr;
output DataHazard;
output ControlHazard;

wire prev = (if_id_rs_addr == id_ex_write_addr || if_id_rt_addr == id_ex_write_addr);
wire prev_2nd = (if_id_rs_addr == ex_mem_write_addr || if_id_rt_addr == ex_mem_write_addr);
wire lw = id_ex_MemRead && prev;
assign DataHazard =
       lw ||
       ((if_id_PCSrc == 2'b10 || if_id_Branch) && ((id_ex_RegWrite && prev) || (ex_mem_MemRead && prev_2nd)));
assign ControlHazard =
       (if_id_PCSrc == 2'b01) || // j, jal
       (~DataHazard && (if_id_PCSrc == 2'b10 || (if_id_Branch && if_id_Equal)));

endmodule
