# Create firmware

FORTH = sf
#FORTH = gforth

VPATH = ../J1_WB/j1_forth

SRC = crossj1.fs \
      basewords.fs \
      nuc.fs \
      main.fs

.PHONY: sim syn

j1_keyboard.mif j1_keyboard.hex j1_keyboard.lst: $(SRC) *.fs
	$(FORTH) main.fs

sim: j1_keyboard.mif
	cp $^ ../sim

syn: j1_keyboard.mif
	cp $^ ../syn
