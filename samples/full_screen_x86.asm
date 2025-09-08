%include "samples/registers.inc"

bits 32

org 0x4000
start:
  ;;        pf0    pf1      pf2
  ;; pf = 100000 00000000 00000001

  mov [pf0], byte 0x04
  mov [pf1], byte 0x00
  mov [pf2], byte 0x80

  mov [colubk], byte color_blue

loop:
  mov [vsync], al

  ;;        pf0    pf1      pf2
  ;; pf = 111000 00000000 00000001
  mov [pf0], byte 0x1c
  mov [ctrlpf], byte 0

  mov [colupf], byte color_red

  mov ecx, 10
line_loop_0:
  mov [wsync], al
  sub ecx, 1
  jnz line_loop_0

  ;;        pf0    pf1      pf2
  ;; pf = 001000 00000000 00000001
  mov al, 0x10
  mov [pf0], al

  mov ecx, 120 - 2
line_loop_1:
  mov [wsync], al
  add al, 1
  mov [colupf], al
  sub ecx, 1
  jnz line_loop_1

  mov al, 1
  mov [ctrlpf], al

  mov ecx, 120 - 2
line_loop_2:
  mov [wsync], al
  add al, 1
  mov [colupf], al
  sub ecx, 1
  jnz line_loop_2

  ;;        pf0    pf1      pf2
  ;; pf = 000100 00000000 00000001
  mov [pf0], byte 0x20
  mov [colupf], byte color_green

  jmp loop

delay:
  mov ecx, 0x0002_0000
delay_loop:
  sub ecx, 1
  jnz delay_loop
  ret

