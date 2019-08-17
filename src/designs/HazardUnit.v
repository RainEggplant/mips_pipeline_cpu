module HazardUnit(if_id_rs_addr, if_id_rt_addr, id_ex_MemRead, id_ex_rt_addr, Hazard);
input [4:0] if_id_rs_addr;
input [4:0] if_id_rt_addr;
input id_ex_MemRead;
input [4:0] id_ex_rt_addr;
output Hazard;

assign Hazard = id_ex_MemRead && (id_ex_rt_addr == if_id_rs_addr || id_ex_rt_addr == if_id_rt_addr);

endmodule
