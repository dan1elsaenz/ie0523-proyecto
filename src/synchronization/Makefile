SRC     = testbench.v
OUT     = a.out
VCD     = resultados.vcd

all: run wave

compile:
	iverilog -o $(OUT) $(SRC)

run: compile
	vvp $(OUT)

wave: $(VCD)
	gtkwave $(VCD)

clean:
	rm -f $(OUT) $(VCD)