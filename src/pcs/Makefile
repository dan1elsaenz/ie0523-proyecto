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
[size] 1434 835
[pos] 3 11
*-6.000000 -1 95 225 345 485 735 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
[markername] AA
[markername] BB
[markername] CC
[markername] DD
[markername] EE
[treeopen] testbench.
[sst_width] 40
[signals_width] 193
[sst_expanded] 0
[sst_vpaned_height] 241
@28
testbench.clk
[color] 1
testbench.mr_main_reset
@200
-
-TRANSMIT
@22
[color] 3
testbench.pcs.transmit.cg.octet[7:0]
testbench.pcs.transmit.tx_code_group[9:0]
@28
testbench.pcs.transmit.cg.tx_disparity
testbench.pcs.transmit.cg.tx_even
testbench.pcs.transmit.tx_en
@22
[color] 2
testbench.pcs.txd[7:0]
@200
-
-SYNC
@22
testbench.pcs.sync.state[9:0]
@28
testbench.pcs.receive.sync_status
testbench.pcs.sync.rx_even
@22
testbench.pcs.sync.sudi[10:0]
@200
-
-RECEIVE
@22
testbench.pcs.receive.state[5:0]
testbench.pcs.receive.rx_code_group[9:0]
@28
testbench.pcs.receive.rx_running_disparity
@22
[color] 3
testbench.pcs.receive.rxd[7:0]
@28
[color] 5
testbench.pcs.receive.rx_dv
[color] 5
testbench.pcs.receive.rx_er
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
