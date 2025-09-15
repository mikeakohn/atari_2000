%include "samples/registers.inc"

bits 32

sprite_pos_0 equ 0x8000
sprite_pos_1 equ 0x8004
sprite_dx_0  equ 0x8008
sprite_dx_1  equ 0x800c

sprite_x  equ 7
sprite_x0 equ 5
sprite_x1 equ 12

org 0x4000
start:
  ;;        pf0    pf1      pf2
  ;; pf = 100000 00000000 00000001

  mov [pf0], byte 0x04
  mov [pf1], byte 0x00
  mov [pf2], byte 0x80

  mov [colubk], byte color_blue

  mov [sprite_pos_0], dword sprite_x << 4
  mov [sprite_pos_1], dword sprite_x << 4
  mov [sprite_dx_0],  dword   1
  mov [sprite_dx_1],  dword  -1

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
  mov [wsync], al

  ;; Display a sprite.
  mov [grp0],   byte 0xf0
  mov [colup0], byte 0xce

  mov ecx, [sprite_pos_0]
  add ecx, [sprite_dx_0]
  mov [sprite_pos_0], ecx
  shr ecx, 4
  cmp ecx, sprite_x0
  jnz sprite_0_not_left
  mov [sprite_dx_0], dword 1
sprite_0_not_left:
  cmp ecx, sprite_x1
  jnz sprite_0_not_right
  mov [sprite_dx_0], dword -1
sprite_0_not_right:
sprite_delay_0:
  dec ecx
  jnz sprite_delay_0

  mov [resp0], al
  mov [wsync], al

  ;; Display a second sprite.
  mov [grp0],   byte 0xaa
  mov [colup0], byte 0x4a

  mov ecx, [sprite_pos_1]
  add ecx, [sprite_dx_1]
  mov [sprite_pos_1], ecx
  shr ecx, 4
  cmp ecx, sprite_x0
  jnz sprite_1_not_left
  mov [sprite_dx_1], dword 1
sprite_1_not_left:
  cmp ecx, sprite_x1
  jnz sprite_1_not_right
  mov [sprite_dx_1], dword -1
sprite_1_not_right:
sprite_delay_1:
  dec ecx
  jnz sprite_delay_1

  mov [resp0], al
  mov [wsync], al

  jmp loop

delay:
  mov ecx, 0x0002_0000
delay_loop:
  sub ecx, 1
  jnz delay_loop
  ret

