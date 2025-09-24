%include "samples/registers.inc"

bits 32

sprite_pos_0 equ 0x8000
sprite_pos_1 equ 0x8004
sprite_dx_0  equ 0x8008
sprite_dx_1  equ 0x800c

sprite_x  equ 200
sprite_x0 equ 100
sprite_x1 equ 500

org 0x4000
start:
  ;;        pf0    pf1      pf2
  ;; pf = 100000 00000000 00000001

  mov [pf0], byte 0x04
  mov [pf1], byte 0x00
  mov [pf2], byte 0x80

  mov [colubk], byte color_blue

  mov [sprite_pos_0], dword sprite_x
  mov [sprite_pos_1], dword sprite_x
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

  mov eax, [sprite_pos_0]
  mov [p0_xl], ax

  add eax, [sprite_dx_0]
  mov [sprite_pos_0], eax

  ;; Enable player_0.
  mov [sprite_en], byte 1

  cmp eax, sprite_x0
  jnz sprite_0_not_left
  mov [sprite_dx_0], dword 1
sprite_0_not_left:
  cmp eax, sprite_x1
  jnz sprite_0_not_right
  mov [sprite_dx_0], dword -1
sprite_0_not_right:

  mov [wsync], al
  mov [wsync], al
  mov [wsync], al
  mov [wsync], al
  mov [wsync], al

wait_hblank:
  test [hblank], byte 1
  jz wait_hblank

;  mov ecx, 5
;line_loop_3:
;  mov [wsync], al
;  sub ecx, 1
;  jnz line_loop_3

  ;; Display a second sprite.
  mov eax, [sprite_pos_1]
  mov [p0_xl], ax;

  mov [grp0],   byte 0xaa
  mov [colup0], byte 0x4a

  add eax, [sprite_dx_1]
  mov [sprite_pos_1], eax

  cmp eax, sprite_x0
  jnz sprite_1_not_left
  mov [sprite_dx_1], dword 1
sprite_1_not_left:
  cmp eax, sprite_x1
  jnz sprite_1_not_right
  mov [sprite_dx_1], dword -1
sprite_1_not_right:

  mov [wsync], al
  mov [wsync], al
  mov [wsync], al
  mov [wsync], al
  mov [wsync], al

  mov ecx, 5
line_loop_4:
  mov [wsync], al
  sub ecx, 1
  jnz line_loop_4

  ;; Disable player_0.
  mov [sprite_en], byte 0

  jmp loop

delay:
  mov ecx, 0x0002_0000
delay_loop:
  sub ecx, 1
  jnz delay_loop
  ret

