
module blink
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
  output [5:0] leds
);

localparam WAIT_TIME = 13500000;
reg [2:0] leds_value = 0;
reg [23:0] count = 0;

reg [7:0] red;
reg [7:0] green;
reg [7:0] blue;

wire [9:0] hpos;
wire [9:0] vpos;

wire in_image;
wire clk_pixel;
reg [7:0] color;

always @(posedge clk_pixel) begin
  if (count == WAIT_TIME) begin
    count <= 0;
    leds_value <= leds_value + 1;
  end else begin
    count <= count + 1;
  end

  if (vpos < 250) begin
    color <= 8'h2e;
    //red   <= 255;
    //green <= 0;
    //blue  <= 0;
  end else begin
    color <= 8'h6a;
    //red   <= 0;
    //green <= 0;
    //blue  <= 255;
  end
end

assign leds[2:0] = ~leds_value;

//wire debug;
wire in_hblank;
wire in_vblank;

assign leds[3] = ~in_image;
assign leds[4] = ~in_hblank;
assign leds[5] = ~in_vblank;

hdmi hdmi_0(
  .clk       (clk),
  .dvi_d0_p  (dvi_d0_p),
  .dvi_d0_n  (dvi_d0_n),
  .dvi_d1_p  (dvi_d1_p),
  .dvi_d1_n  (dvi_d1_n),
  .dvi_d2_p  (dvi_d2_p),
  .dvi_d2_n  (dvi_d2_n),
  .dvi_ck_p  (dvi_ck_p),
  .dvi_ck_n  (dvi_ck_n),
  //.debug     (debug),
  .in_hblank (in_hblank),
  .in_vblank (in_vblank),
  .hpos      (hpos),
  .vpos      (vpos),
  .in_image  (in_image),
  .clk_pixel (clk_pixel),
  .color     (color[7:1]),
  //.red       (red),
  //.green     (green),
  //.blue      (blue)
);

endmodule

