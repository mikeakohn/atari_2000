.65832

.include "registers.inc"

.org 0x4000
start:
  ; Set 65C816 mode.
  clc
  xce

  ; Set 65C832 mode.
  clc
  clv
  xce

  ; Set A to 8-bit.
  sep #0x20

  ; Set X/Y to 32 bit.
  rep #0x10

  ;;        pf0    pf1      pf2
  ;; pf = 110001 00000001 00000011

  ;lda.b #0x8c
  ;sta 0x0d
  ;lda.b #0x01
  ;sta 0x0e
  ;lda.b #0xc0
  ;sta 0x0f

  ;;        pf0    pf1      pf2
  ;; pf = 100000 00000000 00000001

  lda.b #0x04
  sta pf0
  lda.b #0x00
  sta pf1
  lda.b #0x80
  sta pf2

  lda.b #color_blue
  sta colubk

loop:
  sta vsync

  ;;        pf0    pf1      pf2
  ;; pf = 100000 00000000 00000001
  lda.b #0x04
  sta pf0

  lda.b #color_red
  sta colupf

  ;sta wsync
  ;sta wsync

  ;ldx.l #480 - 2
  ldx.l #240 - 2
ignore_lines_loop:
  sta wsync
  inc
  sta colupf
  dex
  bne ignore_lines_loop

  ;;        pf0    pf1      pf2
  ;; pf = 000100 00000000 00000001
  lda.b #0x20
  sta pf0

  lda.b #color_green
  sta colupf

  jmp loop

delay:
  ldx.l #0x0002_0000
delay_loop:
  dex
  bne delay_loop
  rts

