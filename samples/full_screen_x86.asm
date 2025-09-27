%include "samples/registers.inc"

bits 32

sprite_pos_0   equ 0x8000
sprite_pos_1   equ 0x8004
sprite_dx_0    equ 0x8008
sprite_dx_1    equ 0x800c
sprite_width   equ 0x8010

;; This is the delay for when the change sizes of player_0 sprite.
sprite_counter equ 0x8014

sprite_x  equ 200
sprite_x0 equ 100
sprite_x1 equ 500

missile_0_x  equ 0x8020
missile_0_y  equ 0x8024
missile_0_dx equ 0x8028
missile_0_dy equ 0x802c

missile_1_x  equ 0x8030
missile_1_y  equ 0x8034
missile_1_dx equ 0x8038
missile_1_dy equ 0x803c

ball_x       equ 0x8040
ball_y       equ 0x8044
ball_dx      equ 0x8048
ball_dy      equ 0x804c

org 0x4000
start:
  ;;        pf0    pf1      pf2
  ;; pf = 100000 00000000 00000001

  mov [pf0], byte 0x04
  mov [pf1], byte 0x00
  mov [pf2], byte 0x80

  mov [colubk], byte color_blue

  ;; Setup player 0.
  mov [sprite_pos_0], dword sprite_x
  mov [sprite_pos_1], dword sprite_x
  mov [sprite_dx_0],  dword   1
  mov [sprite_dx_1],  dword  -1

  mov [sprite_width],   dword 0 
  mov [sprite_counter], dword 0 

  ;; Setup missile 0.
  mov [missile_0_x],  dword 30
  mov [missile_0_y],  dword 30
  mov [missile_0_dx], dword 1
  mov [missile_0_dy], dword 1

  ;; Setup missile 1.
  mov [missile_1_x],  dword 200
  mov [missile_1_y],  dword 200
  mov [missile_1_dx], dword -1
  mov [missile_1_dy], dword 1

  ;; Setup ball.
  mov [ball_x],  dword 300
  mov [ball_y],  dword 300
  mov [ball_dx], dword -1
  mov [ball_dy], dword -1

  mov ebx, 0

loop:
  ;; Playfield has priority over sprites, do not reflect.
  mov al, 0
  mov [ebx+ctrlpf], al

  ;; Move sprites.
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
  
  add [sprite_counter], byte 1
  mov al, [sprite_counter]
  cmp al, 60
  jnz sprite_counter_not_60
  mov [sprite_counter], byte 0
  mov al, [sprite_width]
  mov [ebx+nusiz0], al
  add al, 1
  cmp al, 3
  jnz sprite_size_okay
  mov al, 0
sprite_size_okay:
  mov [sprite_width], al
sprite_counter_not_60:

  mov al, [sprite_width]
  mov [ebx+nusiz0], al

  ;; Move missile 0.
  mov eax, [missile_0_x]
  add eax, [missile_0_dx]
  mov [missile_0_x], eax

  cmp eax, 20
  jnz missile_0_not_20
  mov [missile_0_dx], byte 1
missile_0_not_20:
  cmp eax, 350
  jnz missile_0_not_350
  mov [missile_0_dx], byte -1
missile_0_not_350:


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

  ;; Disable player_0.
  mov [ebx+sprite_en], byte 0

  mov eax, [sprite_pos_1]
  mov [ebx+p0_xl], ax;

  mov [ebx+grp0],   byte 0xff
  mov [ebx+colup0], byte 0x0e
  mov [ebx+nusiz0], byte 0x00
  mov [ebx+wsync], al

  mov ecx, 5
line_loop_4:
  mov [ebx+wsync], al
  sub ecx, 1
  jnz line_loop_4

wait_hblank_3:
  test [ebx+hblank], byte 1
  jz wait_hblank_3

  ;; Enable player_0.
  mov [ebx+sprite_en], byte 1
  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al
  mov [ebx+wsync], al

  ;; Disable player 0.
  mov [ebx+sprite_en], byte 0

wait_hblank_2:
  test [ebx+hblank], byte 1
  jz wait_hblank_2


  jmp loop

delay:
  mov ecx, 0x0002_0000
delay_loop:
  sub ecx, 1
  jnz delay_loop
  ret

