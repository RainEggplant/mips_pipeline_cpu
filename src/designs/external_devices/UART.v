module UART(
         clk, en, mode, ram_id, Rx_Serial, data_to_send,
         addr, on_received, recv_data, Tx_Serial,
         IM_Done, DM_Done
       );
parameter CLKS_PER_BIT = 16'd10417;  // 100M/9600
parameter IM_SIZE = 256;
parameter IM_SIZE_BIT = 8;
parameter DM_SIZE = 256;
parameter DM_SIZE_BIT = 8;
parameter MAX_SIZE_BIT = 8;

input clk;
input en;
input mode;
input ram_id;
input Rx_Serial;
input [31:0] data_to_send;
output reg [MAX_SIZE_BIT - 1 : 0] addr;
output reg on_received;
output reg [31:0] recv_data;
output Tx_Serial;
output reg IM_Done;
output reg DM_Done;

/*--------------------------------UART Rx-------------------------*/
wire Rx_DV;
wire [7:0] Rx_Byte;

UART_Rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_rx_inst
        (.i_Clock(clk),
         .i_Rx_Serial(Rx_Serial),
         .o_Rx_DV(Rx_DV),
         .o_Rx_Byte(Rx_Byte)
        );

/*--------------------------------UART Tx-------------------------*/
reg Tx_DV;
reg [7:0] Tx_Byte;
wire Tx_Active;
wire Tx_Done;

UART_Tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_tx_inst
        (.i_Clock(clk),
         .i_Tx_DV(Tx_DV),
         .i_Tx_Byte(Tx_Byte),
         .o_Tx_Active(Tx_Active),
         .o_Tx_Serial(Tx_Serial),
         .o_Tx_Done(Tx_Done)
        );

/*----------------------------------UART Control----------------------------*/
wire im_receiving = ram_id == 0 && ~IM_Done;
wire dm_receiving = ram_id == 1 && ~DM_Done;
reg [IM_SIZE_BIT - 1: 0] im_addr;
reg [DM_SIZE_BIT - 1: 0] dm_addr;
reg [1:0] byte_cnt;
reg [23:0] word_buf;
reg [31:0] cntByteTime;
reg ready;

always @ (posedge clk)
  begin
    if (~en)
      begin
        im_addr <= 0;
        dm_addr <= 0;
        IM_Done <= 0;
        DM_Done <= 0;
        on_received <= 0;
        recv_data <= 32'd0;
        byte_cnt <= 2'd0;
        word_buf <= 24'd0;
        cntByteTime <= 32'd0;
        ready <= 0;
        Tx_DV <= 0;
        Tx_Byte <= 8'd0;
      end
    else
      begin
        if (mode == 0)
          begin
            // receiving
            if (Rx_DV && (im_receiving || dm_receiving))
              begin
                // receive 1 word_buf = 4 byte
                if (byte_cnt == 2'd3)
                  begin
                    byte_cnt <= 2'd0;
                    on_received <= 1;
                    recv_data <= {Rx_Byte, word_buf[23:0]};
                    // one-clock delay, exactly what we want
                    addr <= ram_id == 0 ? im_addr : dm_addr;

                    // receive instruction
                    if (im_addr == IM_SIZE - 1)
                      IM_Done <= 1;
                    else if (im_receiving)
                      im_addr <= im_addr + 1;

                    // receive data

                    if (dm_addr == DM_SIZE - 1)
                      DM_Done <= 1;
                    else if (dm_receiving)
                      dm_addr <= dm_addr + 1;
                  end
                else
                  begin
                    byte_cnt <= byte_cnt + 1;
                    if (byte_cnt == 2'd0)
                      word_buf[7:0] <= Rx_Byte;
                    else if (byte_cnt == 2'd1)
                      word_buf[15:8] <= Rx_Byte;
                    else if (byte_cnt == 2'd2)
                      word_buf[23:16] <= Rx_Byte;
                    else
                      ;
                    on_received <= 0;
                  end
              end
            else
              on_received <= 0;
          end
        else
          begin
            // sending
            if (~ready)
              begin
                addr <= 0;
                dm_addr <= 0;
                DM_Done <= 0;
                byte_cnt <= 2'd0;
                ready <= 1;
              end
            else
              begin
                if (cntByteTime == CLKS_PER_BIT * 20 && ~DM_Done)
                  begin  // 1 byte time
                    cntByteTime <= 32'd0;
                    Tx_DV <= 1'b1;
                    Tx_Byte <=
                            byte_cnt == 2'd0 ? data_to_send[7:0] :
                            byte_cnt == 2'd1 ? data_to_send[15:8] :
                            byte_cnt == 2'd2 ? data_to_send[23:16] :
                            data_to_send[31:24];

                    if (byte_cnt == 2'd3)
                      begin
                        byte_cnt <= 2'd0;
                        if (dm_addr < DM_SIZE - 1)
                          begin
                            addr <= dm_addr + 1;
                            dm_addr <= dm_addr + 1;
                          end

                        DM_Done <= dm_addr == DM_SIZE - 1;
                      end
                    else
                      byte_cnt <= byte_cnt + 1;
                  end
                else
                  begin
                    cntByteTime <= cntByteTime + 1;
                    Tx_DV <= 0;
                  end
              end
          end
      end
  end
endmodule
