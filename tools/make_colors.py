#!/usr/bin/env python3

fp = open("../cloudtari/src/ColorTable.cxx", "r")

i = 0

for line in fp:
  if not line.startswith("  0x"): continue
  line = line.strip()
  tokens = line.split()
  index = tokens[1].strip()
  value = tokens[0].replace("0x", "").replace(",", "").strip()
  red   = value[0:2]
  green = value[2:4]
  blue  = value[4:6]

  print("    7'h%02x:" % (i))
  print("      begin")
  print("        red   <= 8'h" + red + ";")
  print("        green <= 8'h" + green + ";")
  print("        blue  <= 8'h" + blue + ";")
  print("      end")

  i += 1

fp.close()

