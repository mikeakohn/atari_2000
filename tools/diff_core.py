#!/usr/bin/env python3

core = "micro86"

def skip_start(fp):
  count = 0

  while True:
    line = fp.readline()

    count += 1

    if not line: return count
    if line.startswith("always @(posedge clk) begin"): return count

def has_word(fp_1, fp_2, text):
  if text in line_1 and text in line_2: return True
  return False

def skip_until(fp, count, text):
  while True:
    line = fp.readline()
    count += 1
    if text in line: break

  return count

# ------------------------ fold here ------------------------

filename_orig = "../" + core + "/src/" + core + ".v"
filename_new  = "src/" + core + ".v"

fp_1 = open(filename_orig, "r")
fp_2 = open(filename_new,  "r")

count_1 = skip_start(fp_1)
count_2 = skip_start(fp_2)

#print(count_1)
#print(count_2)

while (True):
  line_1 = fp_1.readline()
  line_2 = fp_2.readline()

  count_1 += 1
  count_2 += 1

  if not line_1: break
  if not line_2: break

  if has_word(line_1, line_2, "button_reset"): continue
  if has_word(line_1, line_2, "button_halt"): continue

  if "mem_bus_halted" in line_1 or "mem_bus_halted" in line_2: continue

  if "STATE_RESET" in line_1 and "STATE_RESET" in line_2:
    count_1 = skip_until(fp_1, count_1, "STATE_FETCH_OP_0:")
    count_2 = skip_until(fp_2, count_2, "STATE_FETCH_OP_0:")
    continue

  if line_1 != line_2:
    print(str(count_1) + ": " + line_1.strip())
    print(str(count_2) + ": " + line_2.strip())
    break

  if line_1.startswith("end"): break
  if line_2.startswith("end"): break

