all:
	iverilog -g2005-sv testbench_receive.v
	vvp a.out
	gtkwave resultados.vcd plantilla.gtkw
clear:
	rm *.vcd
	rm a.out