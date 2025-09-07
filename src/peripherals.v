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
  output [5:0] leds,
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
  output wait_video,
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
reg [6:0] color = 0;
wire in_hblank;
wire in_vblank;
wire [9:0] hpos;
wire [9:0] vpos;
wire in_image;
wire clk_pixel;
//reg wait_image_h = 0;
//reg wait_image_v = 0;
reg wait_hblank = 0;
reg wait_vblank = 0;
wire [9:0] hpos_start;
wire [9:0] vpos_start;

//assign leds[5:0] = ~vpos[5:0];
//assign leds[5:0] = ~vpos[9:4];
reg [5:0] led_value;
assign leds[5:0] = ~led_value;

always @(posedge vpos[8]) begin
  led_value <= led_value + 1;
end

assign wait_video = wait_hblank || wait_vblank;
//assign wait_video = wait_hblank;

//wire [9:0] img_x = hpos > 88 + 8 ? hpos - 88 + 8 : 0;

// Original Atari 2600 is 20 * 2 bit playfield.
// This comes to 640 / 40 = 16 pixels per playfield bit.
// 720 - 640 = 80 extra pixels (40 on each side).
// 40 / 16 = 2.5... so just adding 2 extra bits + a border color.
// Border is 8 pixels.
reg [21:0] playfield    = 0;
reg [4:0] playfield_bit = 21;
reg [4:0] playfield_dir = -1;

reg [6:0] color_p0;
reg [6:0] color_p1;
reg [6:0] color_fg;
reg [6:0] color_bg;
reg [2:0] ctrlpf = 0;

wire is_fg = playfield[playfield_bit];
wire [9:0] pos_x = hpos - hpos_start;

always @(posedge clk_pixel) begin
  if (in_image) begin
    if (pos_x[3:0] == 0) begin
      if (is_fg) begin
        color <= color_fg;
      end else begin
        color <= color_bg;
      end

      if (pos_x[9:4] == 22) begin
        if (ctrlpf[0] == 0) begin
          playfield_bit <= 21;
          playfield_dir <= -1;
        end else begin
          playfield_bit <= 0;
          playfield_dir <= 1;
        end
      end else begin
        playfield_bit <= playfield_bit + playfield_dir;
      end
    end
  end else begin
    playfield_bit <= 21;
    playfield_dir <= -1;
    color <= 0;
  end
end

always @(posedge raw_clk) begin
  //if (reset) speaker_value_high <= 0;

  if (write_enable) begin
    case (address[5:0])
      5'h00:
        begin
          wait_vblank <= 1;
          //if (!in_vblank) wait_image_v <= 1;
        end
      5'h02:
        begin
          wait_hblank <= 1;
          //if (in_hblank) wait_image_h <= 1;
        end
      5'h03: spi_tx_buffer_1[7:0] <= data_in;
      5'h04: begin tx_data <= data_in; tx_strobe <= 1; end
      5'h06: color_p0 <= data_in[7:1];
      5'h07: color_p1 <= data_in[7:1];
      5'h08: color_fg <= data_in[7:1];
      5'h09: color_bg <= data_in[7:1];
      5'h0a: ctrlpf[2:0] <= data_in[2:0];
      5'h0d:
        playfield[21:16] <=
        {
                                  data_in[2], data_in[3],
          data_in[4], data_in[5], data_in[6], data_in[7]
        };
      5'h0e: playfield[15:8] <= data_in[7:0];
      5'h0f:
        playfield[7:0] <=
        {
          data_in[0], data_in[1], data_in[2], data_in[3],
          data_in[4], data_in[5], data_in[6], data_in[7]
        };
      5'h10: if (data_in[1] == 1) spi_start_1 <= 1;
      5'h11: spi_cs_1 <= data_in;
      5'h12: spi_divisor_1 <= data_in;
    endcase
  end else begin
    if (spi_start_1 && spi_busy_1) spi_start_1 <= 0;
    if (tx_strobe && tx_busy) tx_strobe <= 0;

    if (rx_ready_clear == 1) rx_ready_clear <= 0;

/*
    if (in_hblank) begin
      if (wait_image_h == 0) wait_hblank <= 0;
    end
*/

/*
    if (!in_vblank) begin
      if (wait_image_v == 0) wait_vblank <= 0;
      if (wait_image_v == 0) wait_vblank <= 0;
    end
*/

    if (hpos == hpos_start) wait_hblank <= 0;
    if (vpos == vpos_start) wait_vblank <= 0;
    //if (vpos == 10) wait_vblank <= 0;

    //if (!in_hblank) wait_image_h <= 0;
    //if (in_vblank)  wait_image_v <= 0;

    if (enable) begin
      case (address[5:0])
        //5'h0: data_out <= buttons;
        5'hc: begin data_out <= rx_data; rx_ready_clear <= 1; end
        5'hd: data_out <= { rx_ready, tx_busy };
        5'he: data_out <= spi_tx_buffer_1[7:0];
        5'hf: data_out <= spi_rx_buffer_1[7:0];
        5'h10: data_out <= { 1'b0, spi_busy_1 || spi_start_1 };
        5'h11: data_out <= spi_cs_1;
        5'h12: data_out <= spi_divisor_1;
        5'h13: data_out <= load_count;
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
  .clk        (raw_clk),
  .dvi_d0_p   (dvi_d0_p),
  .dvi_d0_n   (dvi_d0_n),
  .dvi_d1_p   (dvi_d1_p),
  .dvi_d1_n   (dvi_d1_n),
  .dvi_d2_p   (dvi_d2_p),
  .dvi_d2_n   (dvi_d2_n),
  .dvi_ck_p   (dvi_ck_p),
  .dvi_ck_n   (dvi_ck_n),
  .in_hblank  (in_hblank),
  .in_vblank  (in_vblank),
  .hpos       (hpos),
  .vpos       (vpos),
  .hpos_start (hpos_start),
  .vpos_start (vpos_start),
  .in_image   (in_image),
  .clk_pixel  (clk_pixel),
  .color      (color)
  //.red        (red),
  //.green      (green),
  //.blue       (blue)
);

endmodule

