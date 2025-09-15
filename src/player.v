// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

module player
(
  output value,
  input [7:0] data,
  input [1:0] width,
  input strobe,
  input direction,
  input clk
);

reg [3:0] bit;
reg [2:0] sprite_clock;
reg active;

wire value = active == 0 ? 0 :
  (direction == 1 ? data[bit] : data[7 - bit]);

always @(posedge clk) begin
  if (strobe) begin
    bit <= 0;
    sprite_clock <= 0;
    active <= 1;
  end else if (active) begin
    sprite_clock = sprite_clock + 1;

    case (width)
      2'b00:   if (sprite_clock[0]   == 0) bit = bit + 1;
      2'b01:   if (sprite_clock[1:0] == 0) bit = bit + 1;
      default: if (sprite_clock[2:0] == 0) bit = bit + 1;
    endcase

    if (bit == 8) active <= 0;
  end
end

/*
always @(posedge sprite_clock[width]) begin
  if (active) begin
    //value <= direction == 1 ? data[bit] : data[7 - bit];

    bit <= bit + 1;
    //if (bit == 7) active <= 0;
  //end else begin
  //  value <= 0;
  end
end
*/

endmodule

