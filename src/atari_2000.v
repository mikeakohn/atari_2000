// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

// This module is probably not needed, but it keep the top module named
// Atari 2000 and the wires shouldn't cost anything.

module atari_2000
(
  input raw_clk,
  output sd_card_di,
  input  sd_card_do,
  output sd_card_clk,
  output sd_card_cs,
  //output speaker_p,
  //output speaker_m,
  output [5:0] leds,
  input joystick_0,
  input joystick_1,
  input joystick_2,
  input joystick_3,
  input joystick_4,
  input  button_reset,
  input  button_halt,
  input  button_select,
  input  button_0,
  //output spi_cs_1,
  //output spi_clk_1,
  //output spi_mosi_1,
  //input  spi_miso_1,
  output uart_tx_0,
  input  uart_rx_0,
  output dvi_d0_p,
  output dvi_d0_n,
  output dvi_d1_p,
  output dvi_d1_n,
  output dvi_d2_p,
  output dvi_d2_n,
  output dvi_ck_p,
  output dvi_ck_n
);

micro86 micro86_0
(
  .raw_clk       (raw_clk),
  .sd_card_di    (sd_card_di),
  .sd_card_do    (sd_card_do),
  .sd_card_clk   (sd_card_clk),
  .sd_card_cs    (sd_card_cs),
  //.speaker_p     (speaker_p),
  //.speaker_m     (speaker_m),
  .leds          (leds),
  .joystick_0    (joystick_0),
  .joystick_1    (joystick_1),
  .joystick_2    (joystick_2),
  .joystick_3    (joystick_3),
  .joystick_4    (joystick_4),
  .button_reset  (button_reset),
  .button_halt   (button_halt),
  .button_select (button_select),
  .button_0      (button_0),
  //.spi_cs_1      (spi_cs_1),
  //.spi_clk_1     (spi_clk_1),
  //.spi_mosi_1    (spi_mosi_1),
  //.spi_miso_1    (spi_miso_1),
  .uart_tx_0     (uart_tx_0),
  .uart_rx_0     (uart_rx_0),
  .dvi_d0_p      (dvi_d0_p),
  .dvi_d0_n      (dvi_d0_n),
  .dvi_d1_p      (dvi_d1_p),
  .dvi_d1_n      (dvi_d1_n),
  .dvi_d2_p      (dvi_d2_p),
  .dvi_d2_n      (dvi_d2_n),
  .dvi_ck_p      (dvi_ck_p),
  .dvi_ck_n      (dvi_ck_n)
);

endmodule

