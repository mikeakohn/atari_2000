.65832

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

  lda.b #0x04
  sta 0x0d
  lda.b #0x00
  sta 0x0e
  lda.b #0x80
  sta 0x0f

loop:
  jmp loop

delay:
  ldx.l #0x0002_0000
delay_loop:
  dex
  bne delay_loop
  rts

