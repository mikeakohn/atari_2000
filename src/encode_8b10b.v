// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

module encode_8b10b
(
  input [1:0] channel,
  input clk,
  input [7:0] data,
  input in_image,
  input in_guard,
  input [1:0] control,
  output [9:0] tmds
);

wire [3:0] ones =
  data[7] +
  data[6] +
  data[5] +
  data[4] +
  data[3] +
  data[2] +
  data[1] +
  data[0];

wire use_xnor = (ones > 4) || (ones == 4 && data[0] == 0);
wire use_xor = ~use_xnor;

wire [8:0] q_m;

assign q_m[0] = data[0];
assign q_m[1] = data[1] ^ q_m[0] ^ use_xnor;
assign q_m[2] = data[2] ^ q_m[1] ^ use_xnor;
assign q_m[3] = data[3] ^ q_m[2] ^ use_xnor;
assign q_m[4] = data[4] ^ q_m[3] ^ use_xnor;
assign q_m[5] = data[5] ^ q_m[4] ^ use_xnor;
assign q_m[6] = data[6] ^ q_m[5] ^ use_xnor;
assign q_m[7] = data[7] ^ q_m[6] ^ use_xnor;
assign q_m[8] = use_xor;

wire [3:0] q_m_ones =
  q_m[7] +
  q_m[6] +
  q_m[5] +
  q_m[4] +
  q_m[3] +
  q_m[2] +
  q_m[1] +
  q_m[0];

wire [3:0] q_m_zeros = 4'd8 - q_m_ones;

wire signed [3:0] q_m_diff =
  q_m_ones > q_m_zeros ? q_m_ones - q_m_zeros : q_m_zeros - q_m_ones;

reg signed [4:0] disparity = 0;
reg [9:0] code = 0;

always @(posedge clk) begin
  if (in_image) begin
    //code <= { 1, 0,  0, 0, 0, 0,  0, 0, 0, 0 };

    code[8] <= q_m[8];

    if (disparity == 0 || ones == 4) begin
      code[9] <= ~q_m[8];

      if (q_m[8] == 0) begin
        code[7:0] <= ~q_m[7:0];
        disparity <= disparity - q_m_diff;
      end else begin
        code[7:0] <=  q_m[7:0];
        disparity <= disparity + q_m_diff;
      end
    end else begin
      if ((disparity > 0 && ones > 4) || (disparity < 0 && ones < 4)) begin
        code[9]   <= 1;
        code[7:0] <= ~q_m[7:0];

        if (q_m[8] == 0) begin
          disparity <= disparity - q_m_diff;
        end else begin
          disparity <= disparity - q_m_diff + 2;
        end
      end else begin
        code[9]   <= 0;
        code[7:0] <= q_m[7:0];

        if (q_m[8] == 0) begin
          disparity <= disparity - q_m_diff - 2;
        end else begin
          disparity <= disparity + q_m_diff;
        end
      end
    end
  end else begin
    if (in_guard) begin
      case (channel)
        2'b00: code <= 10'b1011001100;
        2'b01: code <= 10'b0100110011;
        2'b10: code <= 10'b1011001100;
      endcase
/*
    end else if (in_island) begin
      case (control)
        4'b0000: code[9:0] = 10'b1010011100;
        4'b0001: code[9:0] = 10'b1001100011;
        4'b0010: code[9:0] = 10'b1011100100;
        4'b0011: code[9:0] = 10'b1011100010;
        4'b0100: code[9:0] = 10'b0101110001;
        4'b0101: code[9:0] = 10'b0100011110;
        4'b0110: code[9:0] = 10'b0110001110;
        4'b0111: code[9:0] = 10'b0100111100;
        4'b1000: code[9:0] = 10'b1011001100;
        4'b1001: code[9:0] = 10'b0100111001;
        4'b1010: code[9:0] = 10'b0110011100;
        4'b1011: code[9:0] = 10'b1011000110;
        4'b1100: code[9:0] = 10'b1010001110;
        4'b1101: code[9:0] = 10'b1001110001;
        4'b1110: code[9:0] = 10'b0101100011;
        4'b1111: code[9:0] = 10'b1011000011;
      endcase
*/
    end else begin
      // Control Data Encoding (Digikey):
      // c1 c0   code
      //  0  0   1101010100
      //  0  1   0010101011
      //  1  0   0101010100
      //  1  1   1010101011

/*
      code <= c1 == 0 ?
        (c0 == 0 ? 10'b1101010100 : 10'b0010101011) :
        (c0 == 0 ? 10'b0101010100 : 10'b1010101011);
*/

        case (control)
          2'b00: code <= 10'b1101010100;
          2'b01: code <= 10'b0010101011;
          2'b10: code <= 10'b0101010100;
          2'b11: code <= 10'b1010101011;
          //2'b00: code <= 10'b0010101011;
          //2'b01: code <= 10'b1101010100;
          //2'b10: code <= 10'b0010101010;
          //2'b11: code <= 10'b1101010101;
        endcase
    end

    disparity <= 0;
  end
end

assign tmds = code;

endmodule

