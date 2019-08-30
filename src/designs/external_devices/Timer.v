module Timer(
         clk, reset, MemRead, MemWrite, address, write_data, read_data, IRQ
       );
input clk;
input reset;
input MemRead;
input MemWrite;
input [1:0] address;
input [31:0] write_data;
output [31:0] read_data;
output IRQ;

wire [31:0] read_data;
wire IRQ;
reg [31:0] TH;
reg [31:0] TL;
reg [2:0] TCON;


assign read_data =
       MemRead ?
       ((address == 2'd0) ? TH :
        (address == 2'd1) ? TL :
        (address == 2'd2) ? {29'b0, TCON} :
        32'h00000000) :
       32'h00000000;

assign IRQ = TCON[2];

always @ (posedge clk)
  begin
    if (reset)
      begin
        TH <= 32'h00000000;
        TL <= 32'h00000000;
        TCON <= 3'b000;
      end
    else
      if (MemWrite)
        begin
          case (address)
            2'd0:
              TH <= write_data;
            2'd1:
              TL <= write_data;
            2'd2:
              TCON <= write_data[2:0];
          endcase
        end
      else
        if (TCON[0])
          begin // timer is enabled
            if (TL == 32'hffffffff)
              begin
                TL <= TH;
                if (TCON[1])
                  TCON[2] <= 1'b1; // IRQ is enabled
              end
            else
              TL <= TL + 1;
          end
  end

endmodule
