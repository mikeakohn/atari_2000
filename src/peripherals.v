// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

module peripherals
(
  input enable,
  input  [5:0] address,
  input  [7:0] data_in,
  output reg [7:0] data_out,
  input write_enable,
  input clk,
  input raw_clk,
  output joystick_0,
  output joystick_1,
  output joystick_2,
  output joystick_3,
  output joystick_4,
  input button_0,
  output reg spi_cs_1,
  output spi_clk_1,
  output spi_mosi_1,
  input  spi_miso_1,
  output uart_tx_0,
  input  uart_rx_0,
  input [7:0] load_count,
  output dvi_d0_p,
  output dvi_d0_n,
  output dvi_d1_p,
  output dvi_d1_n,
  output dvi_d2_p,
  output dvi_d2_n,
  output dvi_ck_p,
  output dvi_ck_n,
  input reset
);

reg [7:0] storage [3:0];

//reg [15:0] speaker_value_high;
//reg [15:0] speaker_value_curr;
//reg [7:0]  buttons;

/*
reg speaker_toggle;
reg speaker_value_p;
reg speaker_value_m;
assign speaker_p = speaker_value_p;
assign speaker_m = speaker_value_m;
*/

/*
reg [7:0] ioport_a = 0;
assign ioport_0 = ioport_a[0];
reg [7:0] ioport_b = 0;
assign ioport_1 = ioport_b[0];
assign ioport_2 = ioport_b[1];
assign ioport_3 = ioport_b[2];
assign ioport_4 = ioport_b[3];
*/

// SPI 1.
wire [7:0] spi_rx_buffer_1;
reg  [7:0] spi_tx_buffer_1;
wire spi_busy_1;
reg spi_start_1 = 0;
reg [2:0] spi_divisor_1 = 0;

// UART 0.
wire tx_busy;
reg  tx_strobe = 0;
reg  [7:0] tx_data;
wire [7:0] rx_data;
wire rx_ready;
reg  rx_ready_clear = 0;

// Video.
reg [7:0] red   = 0;
reg [7:0] green = 0;
reg [7:0] blue  = 0;
wire debug;
wire in_hblank;
wire in_vblank;
wire [9:0] hpos;
wire [9:0] vpos;

wire [9:0] img_x = hpos > 88 + 8 ? hpos - 88 + 8 : 0;

// Original Atari 2600 is 20 * 2 bit playfield.
// This comes to 640 / 40 = 16 pixels per playfield bit.
// 720 - 640 = 80 extra pixels (40 on each side).
// 40 / 16 = 2.5... so just adding 2 extra bits + a border color.
// Border is 8 pixels.
reg [21:0] playfield    = 12;
reg [4:0] playfield_bit = 21;
reg [4:0] playfield_dir = -1;

always @(posedge raw_clk) begin
  if (hpos >= 88 + 8) begin
    if (hpos[3:0] == 0) begin
      if (playfield[playfield_bit]) begin
        red   <= 8'hff;
        green <= 8'h00;
        blue  <= 8'h00;
      end else begin
        red   <= 8'h00;
        green <= 8'h00;
        blue  <= 8'hff;
      end

      playfield_bit <= playfield_bit + playfield_dir;

      if (playfield_bit == 0) begin
        playfield_dir <= 1;
      end
    end
  end else begin
    playfield_dir <= -1;
    playfield_bit <= 21;

/*
    //if (hpos < 88 + 360) begin
    if (playfield[img_x[9:4]]) begin
      if (playfield[playfield_bit]) begin
        red   <= 8'hff;
        green <= 8'h00;
        blue  <= 8'h00;
      end else begin
        red   <= 8'h00;
        green <= 8'h00;
        blue  <= 8'hff;
      end
    end else if (img_x < 720) begin
      if (playfield[playfield_bit]) begin
        red   <= 8'hff;
        green <= 8'h00;
        blue  <= 8'h00;
      end else begin
        red   <= 8'h00;
        green <= 8'hff;
        blue  <= 8'h00;
      end
    end
  end else begin
    // FIXME: Remove this later.
    red   <= 8'h00;
    green <= 8'h55;
    blue  <= 8'h00;
*/
  end
end

always @(posedge raw_clk) begin
  //if (reset) speaker_value_high <= 0;

  if (write_enable) begin
    case (address[5:0])
      //5'h00: red   <= data_in;
      //5'h01: blue  <= data_in;
      //5'h02: green <= data_in;
      5'h03: spi_tx_buffer_1[7:0] <= data_in;
      5'h04: begin tx_data <= data_in; tx_strobe <= 1; end
      5'h0d: playfield[21:16] <= data_in[2:7];
      5'h0e: playfield[15:8]  <= data_in[7:0];
      5'h0f: playfield[7:0]   <= data_in[0:7];
      5'h10: if (data_in[1] == 1) spi_start_1 <= 1;
      5'h11: spi_cs_1 <= data_in;
      5'h12: spi_divisor_1 <= data_in;
    endcase
  end else begin
    if (spi_start_1 && spi_busy_1) spi_start_1 <= 0;
    if (tx_strobe && tx_busy) tx_strobe <= 0;

    if (rx_ready_clear == 1) rx_ready_clear <= 0;

    if (enable) begin
      case (address[5:0])
        //6'h0: data_out <= buttons;
        6'hc: begin data_out <= rx_data; rx_ready_clear <= 1; end
        6'hd: data_out <= { rx_ready, tx_busy };
        6'he: data_out <= spi_tx_buffer_1[7:0];
        6'hf: data_out <= spi_rx_buffer_1[7:0];
        6'h10: data_out <= { 1'b0, spi_busy_1 || spi_start_1 };
        6'h11: data_out <= spi_cs_1;
        6'h12: data_out <= spi_divisor_1;
        6'h13: data_out <= load_count;
      endcase
    end
  end
end

spi spi_1
(
  .raw_clk  (raw_clk),
  .divisor  (spi_divisor_1),
  .start    (spi_start_1),
  .data_tx  (spi_tx_buffer_1),
  .data_rx  (spi_rx_buffer_1),
  .busy     (spi_busy_1),
  .sclk     (spi_clk_1),
  .mosi     (spi_mosi_1),
  .miso     (spi_miso_1)
);

uart uart_0
(
  .raw_clk        (raw_clk),
  .tx_data        (tx_data),
  .tx_strobe      (tx_strobe),
  .tx_busy        (tx_busy),
  .tx_pin         (uart_tx_0),
  .rx_data        (rx_data),
  .rx_ready       (rx_ready),
  .rx_ready_clear (rx_ready_clear),
  .rx_pin         (uart_rx_0)
);

hdmi hdmi_0(
  .clk       (raw_clk),
  .dvi_d0_p  (dvi_d0_p),
  .dvi_d0_n  (dvi_d0_n),
  .dvi_d1_p  (dvi_d1_p),
  .dvi_d1_n  (dvi_d1_n),
  .dvi_d2_p  (dvi_d2_p),
  .dvi_d2_n  (dvi_d2_n),
  .dvi_ck_p  (dvi_ck_p),
  .dvi_ck_n  (dvi_ck_n),
  .in_hblank (in_hblank),
  .in_vblank (in_vblank),
  .hpos      (hpos),
  .vpos      (vpos),
  .red       (red),
  .green     (green),
  .blue      (blue)
);

endmodule

