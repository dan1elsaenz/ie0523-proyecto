# =============================================================================
#
# - File        : Makefile
# - Autor       : Rodrigo Sánches Araya
# - Curso       : Sistemas Digitales II, Universidad de Costa Rica
# - Fecha       : 05-12-2025
#
# - Descripción :
#   Este archivo automatiza los comandos de simulación implementado en Verilog.
#
# =============================================================================


# Parámetros de compilación y simulación
OUT        := sim.out
VCD        := resultados.vcd
SRC        := testbench.v
TOP        := testbench
GTKW       := layout.gtkw

# Configuración del layout de GTKWave
define LAYOUT
[timestart] 0
[size] 1434 835
[pos] 3 11
*-5.827720 -1 95 165 285 455 605 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
[markername] AA
[markername] BB
[markername] CC
[markername] DD
[markername] EE
[treeopen] testbench.
[sst_width] 40
[signals_width] 169
[sst_expanded] 0
[sst_vpaned_height] 238
@200
-GENERAL
@28
testbench.U0.clk
testbench.U0.mr_main_reset
@22
+{testbench.U0.state[9:0]} testbench.U0.state[9:0]
@200
-
-INPUT
@22
[color] 3
testbench.U0.pudi[9:0]
@28
testbench.U0.comma_pudi
testbench.U0.data_pudi
testbench.U0.pudi_invalid
testbench.U0.indicate
@200
-
-OUTPUT
@28
[color] 7
testbench.U0.code_sync_status
@22
[color] 2
testbench.U0.sudi[10:0]
@28
testbench.U0.rx_even
@200
-
-CONTADORES
@28
testbench.U0.sync_cont[1:0]
testbench.U0.comma_cont[1:0]
testbench.U0.good_cg_cont[1:0]
[pattern_trace] 1
[pattern_trace] 0
endef
export LAYOUT := $(LAYOUT)

.PHONY: run clean

# Ejecutar todo
all: run

# Regla para compilar y abrir GTKWave
run: layout
	iverilog -g2005-sv -o $(OUT) $(SRC)
	vvp $(OUT)
	@gtkwave "$(VCD)" "$(GTKW)" &

# Regla para crear el archivo de layout
layout: $(GTKW)

# Regla para generar el archivo .gtkw
$(GTKW):
	@printf "%s\n" "$$LAYOUT" > "$(GTKW)"

# Limpiar archivos de salida
clean:
	@rm -f "$(OUT)" "$(VCD)" "$(GTKW)"
