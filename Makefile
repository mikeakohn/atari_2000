
PROGRAM=atari_2000
SOURCE= \
  src/$(PROGRAM).v \
  src/addressing_mode.v \
  src/color_table.v \
  src/encode_8b10b.v \
  src/hdmi.v \
  src/memory_bus.v \
  src/peripherals.v \
  src/player.v \
  src/ram.v \
  src/reg_mode.v \
  src/rom.v \
  src/sd_card_sdhc.v \
  src/spi.v \
  src/uart.v \
  src/micro86.v

default:
	yosys -q \
	  -p "synth_gowin -top $(PROGRAM) -json $(PROGRAM).json -family gw2a" \
	  $(SOURCE)
	nextpnr-himbaechel -r \
	  --json $(PROGRAM).json \
	  --write $(PROGRAM)_pnr.json \
	  --freq 27 \
	  --vopt family=GW2A-18C \
	  --vopt cst=tangnano20k.cst \
	  --device GW2AR-LV18QN88C8/I7
	gowin_pack -d GW2A-18 -o $(PROGRAM).fs $(PROGRAM)_pnr.json

program:
	iceFUNprog $(PROGRAM).bin

blink:
	naken_asm -l -type bin -o rom.bin -Isamples samples/blink.asm
	python3 tools/bin2txt.py rom.bin > rom.txt

full_screen:
	naken_asm -l -type bin -o rom.bin -Isamples samples/full_screen.asm
	python3 tools/bin2txt.py rom.bin > rom.txt

full_screen_x86:
	nasm -o rom.bin samples/full_screen_x86.asm
	python3 tools/bin2txt.py rom.bin > rom.txt

clean:
	@rm -f $(PROGRAM).bin $(PROGRAM).json $(PROGRAM).asc *.lst
	@rm -f $(PROGRAM)_pnr.json
	@echo "Clean!"

