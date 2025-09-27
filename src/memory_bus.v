// Atari 2000 Console
//  Author: Michael Kohn
//   Email: mike@mikekohn.net
//     Web: https://www.mikekohn.net/
//   Board: Sipeed Tang Nano 20K
// License: MIT
//
// Copyright 2024-2025 by Michael Kohn

// The purpose of this module is to route reads and writes to the 4
// different memory banks. Originally the idea was to have ROM and RAM
// be SPI EEPROM (this may be changed in the future) so there would also
// need a "ready" signal that would pause the CPU until the data can be
// clocked in and out of of the SPI chips.

module memory_bus
(
  input [23:0] address,
  input  [7:0] data_in,
  output reg [7:0] data_out,
  input  bus_enable,
  input  write_enable,
  output bus_halt,
  input  clk,
  input  raw_clk,
  output [5:0] leds,
  output joystick_0,
  output joystick_1,
  output joystick_2,
  output joystick_3,
  output joystick_4,
  input  button_0,
  //output spi_cs_1,
  //output spi_clk_1,
  //output spi_mosi_1,
  //input  spi_miso_1,
  output uart_tx_0,
  input  uart_rx_0,
  output sd_card_di,
  input  sd_card_do,
  output sd_card_clk,
  output sd_card_cs,
  output dvi_d0_p,
  output dvi_d0_n,
  output dvi_d1_p,
  output dvi_d1_n,
  output dvi_d2_p,
  output dvi_d2_n,
  output dvi_ck_p,
  output dvi_ck_n,
  input  reset
);

wire [7:0] rom_data_out;
wire [7:0] ram_data_out;
wire [7:0] peripherals_data_out;
wire [7:0] sd_data_out;

wire [7:0] load_count;

//reg [7:0] ram_data_in;
//reg [7:0] peripherals_data_in;

wire [1:0] bank;
wire [7:0] upper_page;
assign bank = address[15:14];
assign upper_page = address[23:16];

wire ram_write_enable;
wire peripherals_write_enable;
//wire block_ram_write_enable;
wire flash_rom_enable;

assign peripherals_write_enable = (bank == 0 && upper_page == 0) && write_enable;
assign ram_write_enable         = (bank == 2 && upper_page == 0) && write_enable;
//assign block_ram_write_enable   = (bank == 3) && write_enable;

// FIXME: The RAM probably need an enable also.
wire peripherals_enable;
assign peripherals_enable = (bank == 0 && upper_page == 0) && bus_enable;

// FIXME: bus_enable really should be true here.
assign flash_rom_enable = (bank == 3 || upper_page != 0) && bus_enable;
//assign flash_rom_enable = (bank == 3 || upper_page != 0);

wire wait_video;
wire sd_busy;
assign bus_halt = (flash_rom_enable && sd_busy) || wait_video;

always @ * begin
  if (bank == 3 || upper_page != 0) begin
    data_out <= sd_data_out;
  end else if (bank == 0) begin
    data_out <= peripherals_data_out;
  end else if (bank == 1) begin
    data_out <= rom_data_out;
  end else if (bank == 2) begin
    data_out <= ram_data_out;
  end else begin
    data_out <= 0;
  end
end

ram ram_0(
  .address      (address[11:0]),
  .data_in      (data_in),
  .data_out     (ram_data_out),
  .write_enable (ram_write_enable),
  .clk          (raw_clk)
);

rom rom_0(
  .address  (address[11:0]),
  .data_out (rom_data_out),
  .clk      (raw_clk)
);

peripherals peripherals_0(
  .enable       (peripherals_enable),
  .address      (address[7:0]),
  .data_in      (data_in),
  .data_out     (peripherals_data_out),
  .write_enable (peripherals_write_enable),
  .clk          (clk),
  .raw_clk      (raw_clk),
  .leds         (leds),
  .joystick_0   (joystick_0),
  .joystick_1   (joystick_1),
  .joystick_2   (joystick_2),
  .joystick_3   (joystick_3),
  .joystick_4   (joystick_4),
  .button_0     (button_0),
  //.spi_cs_1     (spi_cs_1),
  //.spi_clk_1    (spi_clk_1),
  //.spi_mosi_1   (spi_mosi_1),
  //.spi_miso_1   (spi_miso_1),
  .uart_tx_0    (uart_tx_0),
  .uart_rx_0    (uart_rx_0),
  .load_count   (load_count),
  .dvi_d0_p     (dvi_d0_p),
  .dvi_d0_n     (dvi_d0_n),
  .dvi_d1_p     (dvi_d1_p),
  .dvi_d1_n     (dvi_d1_n),
  .dvi_d2_p     (dvi_d2_p),
  .dvi_d2_n     (dvi_d2_n),
  .dvi_ck_p     (dvi_ck_p),
  .dvi_ck_n     (dvi_ck_n),
  .wait_video   (wait_video),
  .reset        (reset)
);

sd_card_sdhc sd_card_0(
  .address     (address[23:0]),
  .data_out    (sd_data_out),
  .busy        (sd_busy),
  .spi_cs      (sd_card_cs),
  .spi_clk     (sd_card_clk),
  .spi_do      (sd_card_di),
  .spi_di      (sd_card_do),
  .load_count  (load_count),
  .enable      (flash_rom_enable),
  .clk         (raw_clk),
  .reset       (reset)
);

endmodule

