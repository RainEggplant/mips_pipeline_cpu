module Timer(
         clk, reset, MemWrite, address, write_data, read_data, IRQ
       );
input clk;
input reset;
input MemWrite;
input [1:0] address;
input [31:0] write_data;
output [31:0] read_data;
output IRQ;

wire [31:0] read_data;
wire IRQ;
// mem[0]: TH, mem[1]: TL, mem[2]: TCON
reg [31:0] mem[2:0];

assign read_data = mem[address];
assign IRQ = mem[2][2];

always @ (posedge clk)
  begin
    if (reset)
      begin
        mem[0] <= 32'h00000000;
        mem[1] <= 32'h00000000;
        mem[2] <= 32'h00000000;
      end
    else
      if (MemWrite)
        mem[address] <= write_data;
      else
        if (mem[2][0]) // timer is enabled
          begin
            if (&mem[1])
              begin
                mem[1] <= mem[0];
                if (mem[2][1])
                  mem[2][2] <= 1'b1; // IRQ is enabled
              end
            else
              mem[1] <= mem[1] + 1;
          end
  end

endmodule
