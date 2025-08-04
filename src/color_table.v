// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

// Converts Atari 2600 color to RGB color.

module color_table
(
  input  [6:0] color,
  output reg [7:0] red,
  output reg [7:0] green,
  output reg [7:0] blue
);

always @ * begin
  case (color)
    7'h00:
      begin
        red   <= 8'h00;
        green <= 8'h00;
        blue  <= 8'h00;
      end
    7'h01:
      begin
        red   <= 8'h40;
        green <= 8'h40;
        blue  <= 8'h40;
      end
    7'h02:
      begin
        red   <= 8'h6c;
        green <= 8'h6c;
        blue  <= 8'h6c;
      end
    7'h03:
      begin
        red   <= 8'h90;
        green <= 8'h90;
        blue  <= 8'h90;
      end
    7'h04:
      begin
        red   <= 8'hb0;
        green <= 8'hb0;
        blue  <= 8'hb0;
      end
    7'h05:
      begin
        red   <= 8'hc8;
        green <= 8'hc8;
        blue  <= 8'hc8;
      end
    7'h06:
      begin
        red   <= 8'hdc;
        green <= 8'hdc;
        blue  <= 8'hdc;
      end
    7'h07:
      begin
        red   <= 8'hec;
        green <= 8'hec;
        blue  <= 8'hec;
      end
    7'h08:
      begin
        red   <= 8'h44;
        green <= 8'h44;
        blue  <= 8'h00;
      end
    7'h09:
      begin
        red   <= 8'h64;
        green <= 8'h64;
        blue  <= 8'h10;
      end
    7'h0a:
      begin
        red   <= 8'h84;
        green <= 8'h84;
        blue  <= 8'h24;
      end
    7'h0b:
      begin
        red   <= 8'ha0;
        green <= 8'ha0;
        blue  <= 8'h34;
      end
    7'h0c:
      begin
        red   <= 8'hb8;
        green <= 8'hb8;
        blue  <= 8'h40;
      end
    7'h0d:
      begin
        red   <= 8'hd0;
        green <= 8'hd0;
        blue  <= 8'h50;
      end
    7'h0e:
      begin
        red   <= 8'he8;
        green <= 8'he8;
        blue  <= 8'h5c;
      end
    7'h0f:
      begin
        red   <= 8'hfc;
        green <= 8'hfc;
        blue  <= 8'h68;
      end
    7'h10:
      begin
        red   <= 8'h70;
        green <= 8'h28;
        blue  <= 8'h00;
      end
    7'h11:
      begin
        red   <= 8'h84;
        green <= 8'h44;
        blue  <= 8'h14;
      end
    7'h12:
      begin
        red   <= 8'h98;
        green <= 8'h5c;
        blue  <= 8'h28;
      end
    7'h13:
      begin
        red   <= 8'hac;
        green <= 8'h78;
        blue  <= 8'h3c;
      end
    7'h14:
      begin
        red   <= 8'hbc;
        green <= 8'h8c;
        blue  <= 8'h4c;
      end
    7'h15:
      begin
        red   <= 8'hcc;
        green <= 8'ha0;
        blue  <= 8'h5c;
      end
    7'h16:
      begin
        red   <= 8'hdc;
        green <= 8'hb4;
        blue  <= 8'h68;
      end
    7'h17:
      begin
        red   <= 8'hec;
        green <= 8'hc8;
        blue  <= 8'h78;
      end
    7'h18:
      begin
        red   <= 8'h84;
        green <= 8'h18;
        blue  <= 8'h00;
      end
    7'h19:
      begin
        red   <= 8'h98;
        green <= 8'h34;
        blue  <= 8'h18;
      end
    7'h1a:
      begin
        red   <= 8'hac;
        green <= 8'h50;
        blue  <= 8'h30;
      end
    7'h1b:
      begin
        red   <= 8'hc0;
        green <= 8'h68;
        blue  <= 8'h48;
      end
    7'h1c:
      begin
        red   <= 8'hd0;
        green <= 8'h80;
        blue  <= 8'h5c;
      end
    7'h1d:
      begin
        red   <= 8'he0;
        green <= 8'h94;
        blue  <= 8'h70;
      end
    7'h1e:
      begin
        red   <= 8'hec;
        green <= 8'ha8;
        blue  <= 8'h80;
      end
    7'h1f:
      begin
        red   <= 8'hfc;
        green <= 8'hbc;
        blue  <= 8'h94;
      end
    7'h20:
      begin
        red   <= 8'h88;
        green <= 8'h00;
        blue  <= 8'h00;
      end
    7'h21:
      begin
        red   <= 8'h9c;
        green <= 8'h20;
        blue  <= 8'h20;
      end
    7'h22:
      begin
        red   <= 8'hb0;
        green <= 8'h3c;
        blue  <= 8'h3c;
      end
    7'h23:
      begin
        red   <= 8'hc0;
        green <= 8'h58;
        blue  <= 8'h58;
      end
    7'h24:
      begin
        red   <= 8'hd0;
        green <= 8'h70;
        blue  <= 8'h70;
      end
    7'h25:
      begin
        red   <= 8'he0;
        green <= 8'h88;
        blue  <= 8'h88;
      end
    7'h26:
      begin
        red   <= 8'hec;
        green <= 8'ha0;
        blue  <= 8'ha0;
      end
    7'h27:
      begin
        red   <= 8'hfc;
        green <= 8'hb4;
        blue  <= 8'hb4;
      end
    7'h28:
      begin
        red   <= 8'h78;
        green <= 8'h00;
        blue  <= 8'h5c;
      end
    7'h29:
      begin
        red   <= 8'h8c;
        green <= 8'h20;
        blue  <= 8'h74;
      end
    7'h2a:
      begin
        red   <= 8'ha0;
        green <= 8'h3c;
        blue  <= 8'h88;
      end
    7'h2b:
      begin
        red   <= 8'hb0;
        green <= 8'h58;
        blue  <= 8'h9c;
      end
    7'h2c:
      begin
        red   <= 8'hc0;
        green <= 8'h70;
        blue  <= 8'hb0;
      end
    7'h2d:
      begin
        red   <= 8'hd0;
        green <= 8'h84;
        blue  <= 8'hc0;
      end
    7'h2e:
      begin
        red   <= 8'hdc;
        green <= 8'h9c;
        blue  <= 8'hd0;
      end
    7'h2f:
      begin
        red   <= 8'hec;
        green <= 8'hb0;
        blue  <= 8'he0;
      end
    7'h30:
      begin
        red   <= 8'h48;
        green <= 8'h00;
        blue  <= 8'h78;
      end
    7'h31:
      begin
        red   <= 8'h60;
        green <= 8'h20;
        blue  <= 8'h90;
      end
    7'h32:
      begin
        red   <= 8'h78;
        green <= 8'h3c;
        blue  <= 8'ha4;
      end
    7'h33:
      begin
        red   <= 8'h8c;
        green <= 8'h58;
        blue  <= 8'hb8;
      end
    7'h34:
      begin
        red   <= 8'ha0;
        green <= 8'h70;
        blue  <= 8'hcc;
      end
    7'h35:
      begin
        red   <= 8'hb4;
        green <= 8'h84;
        blue  <= 8'hdc;
      end
    7'h36:
      begin
        red   <= 8'hc4;
        green <= 8'h9c;
        blue  <= 8'hec;
      end
    7'h37:
      begin
        red   <= 8'hd4;
        green <= 8'hb0;
        blue  <= 8'hfc;
      end
    7'h38:
      begin
        red   <= 8'h14;
        green <= 8'h00;
        blue  <= 8'h84;
      end
    7'h39:
      begin
        red   <= 8'h30;
        green <= 8'h20;
        blue  <= 8'h98;
      end
    7'h3a:
      begin
        red   <= 8'h4c;
        green <= 8'h3c;
        blue  <= 8'hac;
      end
    7'h3b:
      begin
        red   <= 8'h68;
        green <= 8'h58;
        blue  <= 8'hc0;
      end
    7'h3c:
      begin
        red   <= 8'h7c;
        green <= 8'h70;
        blue  <= 8'hd0;
      end
    7'h3d:
      begin
        red   <= 8'h94;
        green <= 8'h88;
        blue  <= 8'he0;
      end
    7'h3e:
      begin
        red   <= 8'ha8;
        green <= 8'ha0;
        blue  <= 8'hec;
      end
    7'h3f:
      begin
        red   <= 8'hbc;
        green <= 8'hb4;
        blue  <= 8'hfc;
      end
    7'h40:
      begin
        red   <= 8'h00;
        green <= 8'h00;
        blue  <= 8'h88;
      end
    7'h41:
      begin
        red   <= 8'h1c;
        green <= 8'h20;
        blue  <= 8'h9c;
      end
    7'h42:
      begin
        red   <= 8'h38;
        green <= 8'h40;
        blue  <= 8'hb0;
      end
    7'h43:
      begin
        red   <= 8'h50;
        green <= 8'h5c;
        blue  <= 8'hc0;
      end
    7'h44:
      begin
        red   <= 8'h68;
        green <= 8'h74;
        blue  <= 8'hd0;
      end
    7'h45:
      begin
        red   <= 8'h7c;
        green <= 8'h8c;
        blue  <= 8'he0;
      end
    7'h46:
      begin
        red   <= 8'h90;
        green <= 8'ha4;
        blue  <= 8'hec;
      end
    7'h47:
      begin
        red   <= 8'ha4;
        green <= 8'hb8;
        blue  <= 8'hfc;
      end
    7'h48:
      begin
        red   <= 8'h00;
        green <= 8'h18;
        blue  <= 8'h7c;
      end
    7'h49:
      begin
        red   <= 8'h1c;
        green <= 8'h38;
        blue  <= 8'h90;
      end
    7'h4a:
      begin
        red   <= 8'h38;
        green <= 8'h54;
        blue  <= 8'ha8;
      end
    7'h4b:
      begin
        red   <= 8'h50;
        green <= 8'h70;
        blue  <= 8'hbc;
      end
    7'h4c:
      begin
        red   <= 8'h68;
        green <= 8'h88;
        blue  <= 8'hcc;
      end
    7'h4d:
      begin
        red   <= 8'h7c;
        green <= 8'h9c;
        blue  <= 8'hdc;
      end
    7'h4e:
      begin
        red   <= 8'h90;
        green <= 8'hb4;
        blue  <= 8'hec;
      end
    7'h4f:
      begin
        red   <= 8'ha4;
        green <= 8'hc8;
        blue  <= 8'hfc;
      end
    7'h50:
      begin
        red   <= 8'h00;
        green <= 8'h2c;
        blue  <= 8'h5c;
      end
    7'h51:
      begin
        red   <= 8'h1c;
        green <= 8'h4c;
        blue  <= 8'h78;
      end
    7'h52:
      begin
        red   <= 8'h38;
        green <= 8'h68;
        blue  <= 8'h90;
      end
    7'h53:
      begin
        red   <= 8'h50;
        green <= 8'h84;
        blue  <= 8'hac;
      end
    7'h54:
      begin
        red   <= 8'h68;
        green <= 8'h9c;
        blue  <= 8'hc0;
      end
    7'h55:
      begin
        red   <= 8'h7c;
        green <= 8'hb4;
        blue  <= 8'hd4;
      end
    7'h56:
      begin
        red   <= 8'h90;
        green <= 8'hcc;
        blue  <= 8'he8;
      end
    7'h57:
      begin
        red   <= 8'ha4;
        green <= 8'he0;
        blue  <= 8'hfc;
      end
    7'h58:
      begin
        red   <= 8'h00;
        green <= 8'h3c;
        blue  <= 8'h2c;
      end
    7'h59:
      begin
        red   <= 8'h1c;
        green <= 8'h5c;
        blue  <= 8'h48;
      end
    7'h5a:
      begin
        red   <= 8'h38;
        green <= 8'h7c;
        blue  <= 8'h64;
      end
    7'h5b:
      begin
        red   <= 8'h50;
        green <= 8'h9c;
        blue  <= 8'h80;
      end
    7'h5c:
      begin
        red   <= 8'h68;
        green <= 8'hb4;
        blue  <= 8'h94;
      end
    7'h5d:
      begin
        red   <= 8'h7c;
        green <= 8'hd0;
        blue  <= 8'hac;
      end
    7'h5e:
      begin
        red   <= 8'h90;
        green <= 8'he4;
        blue  <= 8'hc0;
      end
    7'h5f:
      begin
        red   <= 8'ha4;
        green <= 8'hfc;
        blue  <= 8'hd4;
      end
    7'h60:
      begin
        red   <= 8'h00;
        green <= 8'h3c;
        blue  <= 8'h00;
      end
    7'h61:
      begin
        red   <= 8'h20;
        green <= 8'h5c;
        blue  <= 8'h20;
      end
    7'h62:
      begin
        red   <= 8'h40;
        green <= 8'h7c;
        blue  <= 8'h40;
      end
    7'h63:
      begin
        red   <= 8'h5c;
        green <= 8'h9c;
        blue  <= 8'h5c;
      end
    7'h64:
      begin
        red   <= 8'h74;
        green <= 8'hb4;
        blue  <= 8'h74;
      end
    7'h65:
      begin
        red   <= 8'h8c;
        green <= 8'hd0;
        blue  <= 8'h8c;
      end
    7'h66:
      begin
        red   <= 8'ha4;
        green <= 8'he4;
        blue  <= 8'ha4;
      end
    7'h67:
      begin
        red   <= 8'hb8;
        green <= 8'hfc;
        blue  <= 8'hb8;
      end
    7'h68:
      begin
        red   <= 8'h14;
        green <= 8'h38;
        blue  <= 8'h00;
      end
    7'h69:
      begin
        red   <= 8'h34;
        green <= 8'h5c;
        blue  <= 8'h1c;
      end
    7'h6a:
      begin
        red   <= 8'h50;
        green <= 8'h7c;
        blue  <= 8'h38;
      end
    7'h6b:
      begin
        red   <= 8'h6c;
        green <= 8'h98;
        blue  <= 8'h50;
      end
    7'h6c:
      begin
        red   <= 8'h84;
        green <= 8'hb4;
        blue  <= 8'h68;
      end
    7'h6d:
      begin
        red   <= 8'h9c;
        green <= 8'hcc;
        blue  <= 8'h7c;
      end
    7'h6e:
      begin
        red   <= 8'hb4;
        green <= 8'he4;
        blue  <= 8'h90;
      end
    7'h6f:
      begin
        red   <= 8'hc8;
        green <= 8'hfc;
        blue  <= 8'ha4;
      end
    7'h70:
      begin
        red   <= 8'h2c;
        green <= 8'h30;
        blue  <= 8'h00;
      end
    7'h71:
      begin
        red   <= 8'h4c;
        green <= 8'h50;
        blue  <= 8'h1c;
      end
    7'h72:
      begin
        red   <= 8'h68;
        green <= 8'h70;
        blue  <= 8'h34;
      end
    7'h73:
      begin
        red   <= 8'h84;
        green <= 8'h8c;
        blue  <= 8'h4c;
      end
    7'h74:
      begin
        red   <= 8'h9c;
        green <= 8'ha8;
        blue  <= 8'h64;
      end
    7'h75:
      begin
        red   <= 8'hb4;
        green <= 8'hc0;
        blue  <= 8'h78;
      end
    7'h76:
      begin
        red   <= 8'hcc;
        green <= 8'hd4;
        blue  <= 8'h88;
      end
    7'h77:
      begin
        red   <= 8'he0;
        green <= 8'hec;
        blue  <= 8'h9c;
      end
    7'h78:
      begin
        red   <= 8'h44;
        green <= 8'h28;
        blue  <= 8'h00;
      end
    7'h79:
      begin
        red   <= 8'h64;
        green <= 8'h48;
        blue  <= 8'h18;
      end
    7'h7a:
      begin
        red   <= 8'h84;
        green <= 8'h68;
        blue  <= 8'h30;
      end
    7'h7b:
      begin
        red   <= 8'ha0;
        green <= 8'h84;
        blue  <= 8'h44;
      end
    7'h7c:
      begin
        red   <= 8'hb8;
        green <= 8'h9c;
        blue  <= 8'h58;
      end
    7'h7d:
      begin
        red   <= 8'hd0;
        green <= 8'hb4;
        blue  <= 8'h6c;
      end
    7'h7e:
      begin
        red   <= 8'he8;
        green <= 8'hcc;
        blue  <= 8'h7c;
      end
    7'h7f:
      begin
        red   <= 8'hfc;
        green <= 8'he0;
        blue  <= 8'h8c;
      end
  endcase
end

endmodule

