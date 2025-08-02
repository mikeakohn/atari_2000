
PROGRAM=blink
SOURCE= \
  src/$(PROGRAM).v \
  ../src/encode_8b10b.v \
  ../src/hdmi.v

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

clean:
	@rm -f $(PROGRAM).bin $(PROGRAM).json $(PROGRAM).asc *.lst
	@rm -f blink.bin load_byte.bin store_byte.bin test_subroutine.bin
	@rm -f button.bin
	@echo "Clean!"

