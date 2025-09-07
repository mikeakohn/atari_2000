// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

module hdmi
(
  input clk,
  output dvi_d0_p,
  output dvi_d0_n,
  output dvi_d1_p,
  output dvi_d1_n,
  output dvi_d2_p,
  output dvi_d2_n,
  output dvi_ck_p,
  output dvi_ck_n,
  output in_hblank,
  output in_vblank,
  output reg [9:0] hpos,
  output reg [9:0] vpos,
  output [9:0] hpos_start,
  output [9:0] vpos_start,
  output in_image,
  output clk_pixel,
  input [6:0] color
  //input [7:0] red,
  //input [7:0] green,
  //input [7:0] blue
);

//reg [9:0] hpos = 0;
//reg [9:0] vpos = 0;

wire clk_dvi;
wire clk_lock;

`include "mode_720x480_hdmi.vinc"
//`include "mode_720x480_dvi.vinc"
//`include "mode_640x480_dvi.vinc"

// h_sync, h_back_porch, h_image, h_front_porch
// v_sync, v_back_porch, v_image, v_front_porch
//`include "line_sbif.vinc"

// h_back_porch, h_image, h_front_porch, h_sync
// v_back_porch, v_image, v_front_porch, v_sync
//`include "line_bifs.vinc"

// h_front_porch, h_sync, h_back_porch, h_image
// v_front_porch, v_sync, v_back_porch, v_image
//`include "line_fsbi.vinc"

// h_image, h_front_porch, h_sync, h_back_porch
// v_image, v_front_porch, v_sync, v_back_porch
`include "line_ifsb.vinc"

assign in_image    = ~(in_hblank || in_vblank);

//wire in_guard    = !in_vblank && guard_pixel;
//wire in_preamble = !in_vblank && preamble_pixel;
//wire in_guard    = guard_pixel;
//wire in_preamble = preamble_pixel;
wire in_guard    = 1'b0;
wire in_preamble = 1'b0;

wire [5:0] control =
  { 1'b0, 1'b0, 1'b0, in_preamble, vsync ^ V_INVERT, hsync ^ H_INVERT };

wire reset = 0;

CLKDIV #(
  .DIV_MODE ("5"),
  .GSREN    ("false")
) clk_div (
  .CLKOUT (clk_pixel),
  .HCLKIN (clk_dvi),
  .RESETN (clk_lock),
  //.RESETN (1'b1),
  .CALIB  (1'b1)
);

always @(posedge clk_pixel) begin
  // Horizontal beam is 858 pixels.
  // Vertical   beam is 525 pixels
  if (hpos == WIDTH - 1) begin
    hpos <= 0;
    //vpos <= (vpos == HEIGHT - 1) ? 0 : vpos + 1;

    if (vpos == HEIGHT - 1)
      vpos <= 0;
    else
      vpos <= vpos + 1;

  end else begin
    hpos <= hpos + 1;
  end
end

wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;

color_table color_table_0(
  .color (color),
  .red   (red),
  .green (green),
  .blue  (blue)
);

wire [9:0] tmds_0;
wire [9:0] tmds_1;
wire [9:0] tmds_2;

wire tmds_bit_0;
wire tmds_bit_1;
wire tmds_bit_2;

encode_8b10b tmds_encode_0(
  .channel     (2'd0),
  .clk         (clk_pixel),
  .data        (blue),
  .in_image    (in_image),
  .in_guard    (in_guard),
  .control     (control[1:0]),
  .tmds        (tmds_0)
);

encode_8b10b tmds_encode_1(
  .channel     (2'd1),
  .clk         (clk_pixel),
  .data        (green),
  .in_image    (in_image),
  .in_guard    (in_guard),
  .control     (control[3:2]),
  .tmds        (tmds_1)
);

encode_8b10b tmds_encode_2(
  .channel     (2'd2),
  .clk         (clk_pixel),
  .data        (red),
  .in_image    (in_image),
  .in_guard    (in_guard),
  .control     (control[5:4]),
  .tmds        (tmds_2)
);

OSER10 ser10_tmds_0(
  .Q     (tmds_bit_0),
  .D0    (tmds_0[0]),
  .D1    (tmds_0[1]),
  .D2    (tmds_0[2]),
  .D3    (tmds_0[3]),
  .D4    (tmds_0[4]),
  .D5    (tmds_0[5]),
  .D6    (tmds_0[6]),
  .D7    (tmds_0[7]),
  .D8    (tmds_0[8]),
  .D9    (tmds_0[9]),
  .PCLK  (clk_pixel),
  .FCLK  (clk_dvi),
  .RESET (reset)
);

OSER10 ser10_tmds_1(
  .Q     (tmds_bit_1),
  .D0    (tmds_1[0]),
  .D1    (tmds_1[1]),
  .D2    (tmds_1[2]),
  .D3    (tmds_1[3]),
  .D4    (tmds_1[4]),
  .D5    (tmds_1[5]),
  .D6    (tmds_1[6]),
  .D7    (tmds_1[7]),
  .D8    (tmds_1[8]),
  .D9    (tmds_1[9]),
  .PCLK  (clk_pixel),
  .FCLK  (clk_dvi),
  .RESET (reset)
);

OSER10 ser10_tmds_2(
  .Q     (tmds_bit_2),
  .D0    (tmds_2[0]),
  .D1    (tmds_2[1]),
  .D2    (tmds_2[2]),
  .D3    (tmds_2[3]),
  .D4    (tmds_2[4]),
  .D5    (tmds_2[5]),
  .D6    (tmds_2[6]),
  .D7    (tmds_2[7]),
  .D8    (tmds_2[8]),
  .D9    (tmds_2[9]),
  .PCLK  (clk_pixel),
  .FCLK  (clk_dvi),
  .RESET (reset)
);

TLVDS_OBUF tmds_bufds [3:0](
  .I  ( { clk_pixel, tmds_bit_0, tmds_bit_1, tmds_bit_2 } ),
  .O  ( { dvi_ck_p,  dvi_d0_p,   dvi_d1_p,   dvi_d2_p   } ),
  .OB ( { dvi_ck_n,  dvi_d0_n,   dvi_d1_n,   dvi_d2_n   } )
);

/*
ELVDS_OBUF tmds_bufds [3:0](
  .I  ( { clk,      tmds_bit_0, tmds_bit_1, tmds_bit_2 } ),
  .O  ( { dvi_ck_p, dvi_d0_p,   dvi_d1_p,   dvi_d2_p   } ),
  .OB ( { dvi_ck_n, dvi_d0_n,   dvi_d1_n,   dvi_d2_n   } )
);
*/

endmodule

