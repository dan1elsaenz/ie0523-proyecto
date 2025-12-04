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
[pos] 2 2
*-5.827720 50 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
[treeopen] Controlador_tb.
[sst_width] 278
[signals_width] 250
[sst_expanded] 1
[sst_vpaned_height] 238
@28
Controlador_tb.U0.clk
[color] 1
Controlador_tb.U0.mr_main_reset
@22
[color] 2
Controlador_tb.U0.state[6:0]
@200
-
@28
Controlador_tb.U0.code_sync_status
@22
[color] 2
Controlador_tb.U0.PUDI[9:0]
[color] 2
Controlador_tb.U0.SUDI[10:0]
@28
[color] 5
Controlador_tb.U0.comma_PUDI
[color] 5
Controlador_tb.U0.PUDI_INVALID
[color] 5
Controlador_tb.U0.cg
@200
-
@28
[color] 3
Controlador_tb.U0.comma_cont[1:0]
[color] 3
Controlador_tb.U0.bad_cg_cont[2:0]
[color] 3
Controlador_tb.U0.good_cg_cont[1:0]
[color] 3
Controlador_tb.U0.sync_cont[1:0]
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
