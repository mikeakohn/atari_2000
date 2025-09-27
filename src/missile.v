// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

module missile
(
  output value,
  input [1:0] width,
  input strobe,
  input clk
);

reg [3:0] sprite_clock;
reg active;

wire value = active == 0 ? 0 : 1;

always @(posedge clk) begin
  if (strobe) begin
    sprite_clock <= 0;
    active <= 1;
  end else if (active) begin
    sprite_clock = sprite_clock + 1;

    case (width)
      2'b00: if (sprite_clock[0]   == 0) active <= 0;
      2'b01: if (sprite_clock[1:0] == 0) active <= 0;
      2'b10: if (sprite_clock[2:0] == 0) active <= 0;
      2'b11: if (sprite_clock[3:0] == 0) active <= 0;
    endcase
  end
end

endmodule

