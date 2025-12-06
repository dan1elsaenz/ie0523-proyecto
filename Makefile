# =============================================================================
#
# - File        : Makefile
# - Autor       : Daniel Alberto Sáenz Obando (C37099)
# - Curso       : Sistemas Digitales II, Universidad de Costa Rica
# - Fecha       : 05-12-2025
#
# - Descripción :
#   Archivo para la compilación y simulación de los diferentes submódulos
#   implementados en el proyecto. Contiene reglas para:
#   - pcs (sistema completo)
#   - transmit
#   - synchronization
#   - receive
#
#   Cada uno se ejecuta con su plan de pruebas específico.
#
# =============================================================================


PCS     := src/pcs
TX      := src/transmit
RX      := src/receive
SYNC    := src/synchronization
SUBDIRS := $(PCS) $(TX) $(RX) $(SYNC)

.PHONY: all clean

all: pcs

pcs:
	$(MAKE) -C $(PCS)

transmit:
	$(MAKE) -C $(TX)

receive:
	$(MAKE) -C $(RX)

sync:
	$(MAKE) -C $(SYNC)

clean:
	for d in $(SUBDIRS); do \
		$(MAKE) -C $$d clean; \
	done
