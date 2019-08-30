module HazardUnit(
         PCSrc, if_id_rs_addr, if_id_rt_addr,
         id_ex_RegWrite, id_ex_MemRead, id_ex_write_addr,
         ex_mem_MemRead, ex_mem_write_addr,
         DataHazard
       );
input [2:0] PCSrc;
input [4:0] if_id_rs_addr;
input [4:0] if_id_rt_addr;
input id_ex_RegWrite;
input id_ex_MemRead;
input [4:0] id_ex_write_addr;
input ex_mem_MemRead;
input [4:0] ex_mem_write_addr;
output DataHazard;

wire last =
     id_ex_write_addr != 0 &&
     (if_id_rs_addr == id_ex_write_addr || if_id_rt_addr == id_ex_write_addr);
wire second_last =
     ex_mem_write_addr != 0 &&
     (if_id_rs_addr == ex_mem_write_addr || if_id_rt_addr == ex_mem_write_addr);
wire lw = id_ex_MemRead && last;
wire jr =
     PCSrc == 3'b010 && // Jump Register instr
     // the last instr will write to source reg (stall 1 & forward from EX needed)
     ((id_ex_RegWrite && last) ||
      // the second last instr will load data to source reg (stall 1 & forward from MEM needed)
      (ex_mem_MemRead && second_last)
      // it's safe when the second last instr will write to source reg as the CPU writes to reg before it reads
      // and if the last instr will load data to source reg, the variable `lw` will handle it
     );

assign DataHazard = lw || jr;

endmodule
