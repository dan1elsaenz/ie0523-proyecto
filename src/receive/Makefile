# =============================================================================
#
# - File        : Makefile
# - Autor       : Brandon Jiménez Campos (C33972)
# - Curso       : Sistemas Digitales II, Universidad de Costa Rica
# - Fecha       : 05-12-2025
#
# - Descripción :
#   Con este archivo se realiza todos los comandos que se necesitan para
#	realizar el código. Logrando realizar la compilación y la simulación en
#   GTKWave, además el GTKWave trae una personalización para ahorrarse la
#   vista de ondas y además de colocarle color a las ondas.
#
# =============================================================================


# Parámetros de compilación y simulación
OUT        := a.out
VCD        := resultados.vcd
SRC        := testbench.v
TOP        := testbench
GTKW       := layout.gtkw

# Configuración del layout de GTKWave
define LAYOUT
[timestart] 0
[size] 1854 1001
[pos] 66 0
*-5.209673 118 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
[treeopen] testbench.
[sst_width] 278
[signals_width] 190
[sst_expanded] 1
[sst_vpaned_height] 264
@200
-INPUTS
@28
testbench.rx_clk
testbench.mr_main_reset
[color] 2
testbench.sudi[10:0]
[color] 7
testbench.sync_status
@200
-
-OUTPUTS
@28
[color] 5
testbench.rx_dv
[color] 3
testbench.rx_er
@22
[color] 1
testbench.rxd[7:0]
@200
-
-INFO
@23
testbench.rec.state[5:0]
@28
testbench.rec.rx_running_disparity
@22
testbench.rec.rx_code_group[9:0]
testbench.rec.decoded_octet[7:0]
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
