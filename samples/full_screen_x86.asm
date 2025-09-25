%include "samples/registers.inc"

bits 32

sprite_pos_0   equ 0x8000
sprite_pos_1   equ 0x8004
sprite_dx_0    equ 0x8008
sprite_dx_1    equ 0x800c
sprite_width   equ 0x8010
sprite_counter equ 0x8014

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

  mov [sprite_width],   dword 0 
  mov [sprite_counter], dword 0 

  mov ebx, 0

loop:
  ;; Playfield has priority over sprites, do not reflect.
  mov al, 0
  mov [ebx+ctrlpf], al

  mov eax, [sprite_pos_0]
  add eax, [sprite_dx_0]
  mov [sprite_pos_0], eax

  cmp eax, sprite_x0
  jnz sprite_0_not_left
  mov [sprite_dx_0], dword 1
sprite_0_not_left:
  cmp eax, sprite_x1
  jnz sprite_0_not_right
  mov [sprite_dx_0], dword -1
sprite_0_not_right:

  mov eax, [sprite_pos_1]
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

  ;mov al, [sprite_counter]
  
  add [sprite_counter], byte 1
  mov al, [sprite_counter]
  cmp al, 60
  jnz sprite_counter_not_60
  mov [sprite_counter], byte 0
  mov al, [sprite_width]
  mov [nusiz0], al
  add al, 1
  cmp al, 3
  jnz sprite_size_okay
  mov al, 0
sprite_size_okay:
  mov [sprite_width], al
sprite_counter_not_60:

  mov [vsync], al

  ;;        pf0    pf1      pf2
  ;; pf = 111000 00000000 00000001
  mov [pf0], byte 0x1c
  ;mov [ebx+ctrlpf], byte 0

  mov [colupf], byte color_red

  mov ecx, 10
line_loop_0:
  mov [ebx+wsync], al
  sub ecx, 1
  jnz line_loop_0

  ;;        pf0    pf1      pf2
  ;; pf = 001000 00000000 00000001
  mov al, 0x10
  mov [pf0], al

  mov ecx, 120 - 2
line_loop_1:
  mov [ebx+wsync], al
  add al, 1
  mov [ebx+colupf], al
  sub ecx, 1
  jnz line_loop_1

  mov al, 1
  mov [ebx+ctrlpf], al

  mov ecx, 120 - 2
line_loop_2:
  mov [ebx+wsync], al
  add al, 1
  mov [ebx+colupf], al
  sub ecx, 1
  jnz line_loop_2

  ;;        pf0    pf1      pf2
  ;; pf = 000100 00000000 00000001
  mov [ebx+pf0], byte 0x20
  mov [ebx+colupf], byte color_green
  mov [ebx+wsync], al

  ;; Display a sprite.
  mov [ebx+grp0],   byte 0xf0
  mov [ebx+colup0], byte 0xce

  mov eax, [sprite_pos_0]
  mov [ebx+p0_xl], ax

wait_hblank_0:
  test [ebx+hblank], byte 1
  jz wait_hblank_0

  ;; Enable player_0.
  mov [ebx+sprite_en], byte 1

  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al

wait_hblank_1:
  test [ebx+hblank], byte 1
  jz wait_hblank_1

  ;; Disable player_0.
  mov [ebx+sprite_en], byte 0

  ;; Playfield has priority over sprites, do not reflect.
  mov al, 4
  mov [ebx+ctrlpf], al

  ;; Display a second sprite.
  mov eax, [sprite_pos_1]
  mov [ebx+p0_xl], ax;

  mov [ebx+grp0],   byte 0xaa
  mov [ebx+colup0], byte 0x4a
  mov [ebx+wsync], al

  ;; Enable player_0.
  mov [ebx+sprite_en], byte 1

  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al

  mov ecx, 5
line_loop_4:
  mov [ebx+wsync], al
  sub ecx, 1
  jnz line_loop_4

  ;; Disable player_0.
  mov [ebx+sprite_en], byte 0

  jmp loop

delay:
  mov ecx, 0x0002_0000
delay_loop:
  sub ecx, 1
  jnz delay_loop
  ret

