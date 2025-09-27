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
  input  [7:0] address,
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

reg [7:0] storage [255:0];

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

// UART 0.
wire tx_busy;
reg  tx_strobe = 0;
reg  [7:0] tx_data;
wire [7:0] rx_data;
wire rx_ready;
reg  rx_ready_clear = 0;

// Video.
reg [6:0] color;
wire in_hblank;
wire in_vblank;
wire [9:0] hpos;
wire [9:0] vpos;
wire in_image;
wire clk_pixel;
reg wait_hblank = 0;
reg wait_vblank = 0;
reg wait_hblank_clear = 0;
reg wait_vblank_clear = 0;
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
reg playfield_value;

reg [6:0] color_p0;
reg [6:0] color_p1;
reg [6:0] color_fg;
reg [6:0] color_bg;
reg [3:0] ctrlpf = 0;

//wire is_fg = playfield[playfield_bit];
wire [9:0] pos_x = hpos - hpos_start;

wire player_0_value;
reg [9:0] player_0_posx;
reg [7:0] player_0_data;
reg [3:0] player_0_h_delay;
reg [1:0] player_0_width;
reg player_0_v_delay_flag;
wire player_0_strobe;
reg player_0_reflection;
reg player_0_enable;

wire player_1_value;
reg [9:0] player_1_posx;
reg [7:0] player_1_data;
reg [3:0] player_1_h_delay;
reg [1:0] player_1_width;
reg player_1_v_delay_flag;
wire player_1_strobe;
reg player_1_reflection;
reg player_1_enable;

wire missile_0_value;
reg [9:0] missile_0_posx;
reg [9:0] missile_0_posy;
reg [7:0] missile_0_len;
reg [1:0] missile_0_width;
reg missile_0_v_delay_flag;
wire missile_0_strobe;
reg missile_0_enable;

wire missile_1_value;
reg [9:0] missile_1_posx;
reg [9:0] missile_1_posy;
reg [7:0] missile_1_len;
reg [1:0] missile_1_width;
reg missile_1_v_delay_flag;
wire missile_1_strobe;
reg missile_1_enable;

wire ball_value;
reg [9:0] ball_posx;
reg [9:0] ball_posy;
reg [7:0] ball_len;
reg [1:0] ball_width;
wire ball_strobe;
reg ball_enable;

assign player_0_strobe  = player_0_posx  == hpos && player_0_enable;
assign player_1_strobe  = player_1_posx  == hpos && player_1_enable;
assign missile_0_strobe =
  missile_0_posx == hpos &&
  missile_0_posy >= vpos && missile_0_posy < vpos + missile_0_len &&
  missile_0_enable;
assign missile_1_strobe =
   missile_1_posx == hpos &&
   missile_1_posy >= vpos && missile_1_posy < vpos + missile_1_len &&
   missile_1_enable;
assign ball_strobe =
   ball_posx == hpos &&
   ball_posy >= vpos && ball_posy < vpos + ball_len &&
   ball_enable;

always @(posedge clk_pixel) begin
  if (in_image) begin
    if (pos_x[3:0] == 0) begin
      playfield_value <= playfield[playfield_bit];

      // 720 / 2 = 360. 360 / 16 = 22.5.
      if (pos_x[9:4] == 21) begin
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
  end
end

always @ * begin
  if (ctrlpf[2] == 0) begin
    if (player_0_value || missile_0_value)
      color = color_p0;
    else if (player_1_value || missile_1_value)
      color = color_p1;
    else if (playfield_value || ball_value)
      color = color_fg;
    else
      color = color_bg;
  end else begin
    if (playfield_value || ball_value)
      color = color_fg;
    else if (player_0_value || missile_0_value)
      color = color_p0;
    else if (player_1_value || missile_1_value)
      color = color_p1;
    else
      color = color_bg;
  end
end

always @(posedge raw_clk) begin
  //if (reset) speaker_value_high <= 0;

  if (write_enable) begin
    case (address[6:0])
      7'h00: wait_vblank <= 1;
      7'h02: wait_hblank <= 1;
      7'h04:
        begin
          player_0_width <= data_in[1:0];
          missile_0_width <= data_in[5:4];
        end
      7'h05:
        begin
          player_1_width <= data_in[1:0];
          missile_1_width <= data_in[5:4];
        end
      7'h06: color_p0 <= data_in[7:1];
      7'h07: color_p1 <= data_in[7:1];
      7'h08: color_fg <= data_in[7:1];
      7'h09: color_bg <= data_in[7:1];
      7'h0a: ctrlpf[3:0] <= data_in[5:0];
      7'h0b: player_0_reflection <= data_in[3];
      7'h0c: player_1_reflection <= data_in[3];
      7'h0d:
        playfield[21:16] <=
        {
                                  data_in[2], data_in[3],
          data_in[4], data_in[5], data_in[6], data_in[7]
        };
      7'h0e: playfield[15:8] <= data_in[7:0];
      7'h0f:
        playfield[7:0] <=
        {
          data_in[0], data_in[1], data_in[2], data_in[3],
          data_in[4], data_in[5], data_in[6], data_in[7]
        };
      7'h10: missile_0_posx[7:0] <= data_in[7:0];
      7'h11: missile_0_posx[9:8] <= data_in[1:0];
      7'h12: missile_0_posy[7:0] <= data_in[7:0];
      7'h13: missile_0_posy[9:8] <= data_in[1:0];
      7'h14: missile_0_len       <= data_in;
      7'h15: missile_1_posx[7:0] <= data_in[7:0];
      7'h16: missile_1_posx[9:8] <= data_in[1:0];
      7'h17: missile_1_posy[7:0] <= data_in[7:0];
      7'h18: missile_1_posy[9:8] <= data_in[1:0];
      7'h19: missile_1_len       <= data_in;
      7'h1a: ball_width <= data_in[1:0];
      7'h1b: player_0_data <= data_in;
      7'h1c: player_1_data <= data_in;
      7'h25:
        {
          ball_enable,
          missile_1_enable,
          missile_0_enable,
          player_1_enable,
          player_0_enable
        } <= data_in[4:0];
      7'h26: player_0_posx[7:0] <= data_in[7:0];
      7'h27: player_0_posx[9:8] <= data_in[1:0];
      7'h28: player_1_posx[7:0] <= data_in[7:0];
      7'h29: player_1_posx[9:8] <= data_in[1:0];
      7'h2a: ball_posx[7:0] <= data_in[7:0];
      7'h2b: ball_posx[9:8] <= data_in[1:0];
      7'h2c: ball_posy[7:0] <= data_in[7:0];
      7'h2d: ball_posy[9:8] <= data_in[1:0];
      7'h2e: ball_len       <= data_in;
      7'h42: begin tx_data <= data_in; tx_strobe <= 1; end
      default: storage[address] <= data_in;
    endcase
  end else begin
    if (tx_strobe && tx_busy) tx_strobe <= 0;

    if (rx_ready_clear == 1) rx_ready_clear <= 0;

    if (hpos == hpos_start) wait_hblank_clear <= 1;
    if (vpos == vpos_start) wait_vblank_clear <= 1;
    //if (vpos == 10) wait_vblank <= 0;

    //if (!in_hblank) wait_image_h <= 0;
    //if (in_vblank)  wait_image_v <= 0;

    if (enable) begin
      case (address[7:0])
        7'h01: data_out <= in_vblank;
        7'h03: data_out <= in_hblank;
        7'h0a: data_out <= ctrlpf[3:0];
        7'h10: data_out <= missile_0_posx[7:0];
        7'h11: data_out <= missile_0_posx[9:8];
        7'h12: data_out <= missile_0_posy[7:0];
        7'h13: data_out <= missile_0_posy[9:8];
        7'h14: data_out <= missile_0_len;
        7'h15: data_out <= missile_1_posx[7:0];
        7'h16: data_out <= missile_1_posx[9:8];
        7'h17: data_out <= missile_1_posy[7:0];
        7'h18: data_out <= missile_1_posy[9:8];
        7'h19: data_out <= missile_1_len;
        7'h25:
          data_out <=
          {
            ball_enable,
            missile_1_enable,
            missile_0_enable,
            player_1_enable,
            player_0_enable
          };
        7'h26: data_out <= player_0_posx[7:0];
        7'h27: data_out <= player_0_posx[9:8];
        7'h28: data_out <= player_1_posx[7:0];
        7'h29: data_out <= player_1_posx[9:8];
        7'h2a: data_out <= ball_posx[7:0];
        7'h2b: data_out <= ball_posx[9:8];
        7'h2c: data_out <= ball_posy[7:0];
        7'h2d: data_out <= ball_posy[9:8];
        7'h40: data_out <= { rx_ready, tx_busy };
        7'h41: begin data_out <= rx_data; rx_ready_clear <= 1; end
        7'h43: data_out <= load_count;
        default: data_out <= storage[address];
      endcase
    end
  end

  if (wait_hblank_clear) begin
    wait_hblank <= 0;
    wait_hblank_clear <= 0;
  end

  if (wait_vblank_clear) begin
    wait_vblank <= 0;
    wait_vblank_clear <= 0;
  end
end

player player_0
(
  .value      (player_0_value),
  .data       (player_0_data),
  .width      (player_0_width),
  .strobe     (player_0_strobe),
  .reflection (player_0_reflection),
  .clk        (raw_clk)
);

player player_1
(
  .value      (player_1_value),
  .data       (player_1_data),
  .width      (player_1_width),
  .strobe     (player_1_strobe),
  .reflection (player_1_reflection),
  .clk        (raw_clk)
);

missile missile_0
(
  .value      (missile_0_value),
  .width      (missile_0_width),
  .strobe     (missile_0_strobe),
  .clk        (raw_clk)
);

missile missile_1
(
  .value      (missile_1_value),
  .width      (missile_1_width),
  .strobe     (missile_1_strobe),
  .clk        (raw_clk)
);

missile ball_0
(
  .value      (ball_value),
  .width      (ball_width),
  .strobe     (ball_strobe),
  .clk        (raw_clk)
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

