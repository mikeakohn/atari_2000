
vsync  equ 0x00
vblank equ 0x01
wsync  equ 0x02
hblank equ 0x03

;;    d5,d4: missile size (0 to 3).
;; d2,d1,d0: player size  (0 to 2).
nusiz0 equ 0x04
nusiz1 equ 0x05

colup0 equ 0x06
colup1 equ 0x07
colupf equ 0x08
colubk equ 0x09

;; d0: reflect playfield.
;; d1: (nothing yet).
;; d2: playfield priority (sprites above playfield or under).
ctrlpf equ 0x0a

refp0  equ 0x0b
refp1  equ 0x0c

pf0    equ 0x0d
pf1    equ 0x0e
pf2    equ 0x0f

;; Missile 0.
m0_xl  equ 0x10
m0_xh  equ 0x11
m0_yl  equ 0x12
m0_yh  equ 0x13
m0_len equ 0x14

;; Missile 1.
m1_xl  equ 0x15
m1_xh  equ 0x16
m1_yl  equ 0x17
m1_yh  equ 0x18
m1_len equ 0x19

;; Ball size.
bl_siz equ 0x1a

;; Player 0/1 data graphics.
grp0   equ 0x1b
grp1   equ 0x1c

;; Sprite Enable bits:
;; 4:bl, 3:m1, 2:m0, 1:p1, 1:p0
sprite_en equ 0x25

;; Player 0.
p0_xl equ 0x26
p0_xh equ 0x27

;; Player 1.
p1_xl equ 0x28
p1_xh equ 0x29

;; Ball.
bl_xl  equ 0x2a
bl_xh  equ 0x2b
bl_yl  equ 0x2c
bl_yh  equ 0x2d
bl_len equ 0x2e

uart_status equ 0x40
uart_rx     equ 0x41
uart_tx     equ 0x42

;; Colors.
color_black  equ 0x00
color_red    equ 0x32
color_yellow equ 0x1e
color_blue   equ 0x86
color_green  equ 0xc8
color_orange equ 0xfc
color_purple equ 0x58

