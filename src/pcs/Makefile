# =============================================================================
#
# - File        : Makefile
# - Autor       : Daniel Alberto Sáenz Obando (C37099)
# - Curso       : Sistemas Digitales II, Universidad de Costa Rica
# - Fecha       : 05-12-2025
#
# - Descripción :
#   Este archivo automatiza los comandos de simulación implementado en Verilog.
#   Incluye reglas para compilar con IcarusVerilog, ejecutar la simulación y
#   generar el archivo de ondas VCD.
#   Además, crea de forma automática un archivo de configuración de GTKWave
#   para visualizar señales de la máquina de estados, entradas y salidas del
#   sistema.
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
[size] 1333 834
[pos] 720 2
*-6.000000 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
[treeopen] testbench.
[treeopen] testbench.pcs.
[treeopen] testbench.pcs.transmit.
[sst_width] 255
[signals_width] 177
[sst_expanded] 1
[sst_vpaned_height] 241
@28
testbench.clk
testbench.mr_main_reset
@200
-
-TRANSMIT
@22
testbench.pcs.transmit.cg.octet[7:0]
testbench.pcs.transmit.tx_code_group[9:0]
@28
testbench.pcs.transmit.tx_en
@22
testbench.pcs.txd[7:0]
@200
-
-RECEIVE
@22
testbench.pcs.receive.state[7:0]
testbench.pcs.receive.rx_code_group[9:0]
testbench.pcs.receive.rxd[7:0]
@28
testbench.pcs.receive.rx_dv
testbench.pcs.receive.rx_er
@200
-
-SYNC
@22
testbench.pcs.sync.state[6:0]
@28
testbench.pcs.sync.rx_even
testbench.pcs.receive.sync_status
testbench.pcs.sync.comma_PUDI
@22
testbench.pcs.sync.SUDI[10:0]
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
