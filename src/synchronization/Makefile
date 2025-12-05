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
[pos] 3 5
*-5.827720 0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
[treeopen] testbench.
[sst_width] 278
[signals_width] 204
[sst_expanded] 1
[sst_vpaned_height] 238
@200
-GENERAL
@28
testbench.U0.clk
testbench.U0.mr_main_reset
@22
testbench.U0.state[9:0]
@200
-
-INPUT
@22
testbench.U0.pudi[9:0]
@28
testbench.U0.comma_pudi
testbench.U0.data_pudi
testbench.U0.pudi_invalid
testbench.U0.valid_pudi
@200
-
-OUTPUT
@28
testbench.U0.code_sync_status
@22
testbench.U0.sudi[10:0]
@29
testbench.U0.rx_even
@200
-
-CONTADORES
@28
testbench.U0.sync_cont[1:0]
testbench.U0.comma_cont[1:0]
testbench.U0.good_cg_cont[1:0]
testbench.U0.bad_cg_cont[2:0]
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
