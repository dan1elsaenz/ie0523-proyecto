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
[pos] 3 8
*-6.000000 -1 85 195 325 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
[markername] AA
[markername] BB
[markername] CC
[markername] DD
[markername] EE
[markername] FF
[markername] GG
[markername] HH
[markername] II
[markername] JJ
[markername] KK
[markername] LL
[markername] MM
[markername] NN
[markername] OO
[markername] PP
[markername] QQ
[markername] RR
[markername] SS
[markername] TT
[markername] UU
[markername] VV
[markername] WW
[markername] XX
[markername] YY
[markername] ZZ
[sst_width] 40
[signals_width] 177
[sst_expanded] 0
[sst_vpaned_height] 241
@28
testbench.gtx_clk
[color] 1
testbench.mr_main_reset
@200
-
-GMII
@28
testbench.tx_en
@22
[color] 3
testbench.txd[7:0]
@200
-
-PMA
@22
[color] 2
testbench.tx_code_group[9:0]
@28
testbench.tx_wrapper.cg.pudr
@200
-
-TX_CG
@22
testbench.tx_wrapper.cg.estado[1:0]
testbench.tx_wrapper.cg.octet[7:0]
@28
testbench.tx_wrapper.cg.tx_disparity
testbench.tx_wrapper.cg.tx_is_k
testbench.tx_wrapper.cg.tx_oset_indicate
testbench.tx_wrapper.cg.tx_even
@200
-
-TX_OS
@22
testbench.tx_wrapper.os.estado[2:0]
@28
testbench.tx_wrapper.cg.tx_o_set[4:0]
@200
-
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
