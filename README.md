## IE-0523 Proyecto final

En este repositorio se encuentra el proyecto del curso de **IE0523: Sistemas Digitales II** del grupo 2, conformado por los estudiantes:

| Nombre                        | Carné  |
| ----------------------------- | :----: |
| Daniel Alberto Sáenz Obando   | C37099 |
| Brandon Daniel Jiménez Campos | C33972 |
| Rodrigo Evelio Sánchez Araya  | C37259 |

> Para acceder al informe realizado, ingrese a [este enlace](https://dan1elsaenz.github.io/ie0523-proyecto/reporte.pdf).

### Instrucciones de uso

> [!NOTE]
> Ejecute los comandos desde la raíz del repositorio.

Para la ejecución de la simulación para la PCS completa, utilice el comando:

```sh
make
```

Para la simulación de un submódulo específico, utilice:

```sh
make [transmit|sync|receive]
```

### Descripción

El proyecto consiste de la implementación de la capa PCS (_Physical Coding Sublayer_) para 1000BASE-X (Capa física para 1 Gb/s), desarrollado a partir de la cláusula 36 del estándar IEEE 802.3.
Específicamente, se implementaron las siguientes máquinas de estado:

- [`TRANSMIT`](docs/md/TRANSMIT.md)
- [`RECEIVE`](docs/md/RECEIVE.md)
- [`SYNCHRONIZATION`](docs/md/SYNCHRONIZATION.md)

Estos fueron conectados en una estructura _loopback_ para la realización de las pruebas conjuntas.

### Estructura del proyecto

La estructura de los archivos del proyecto se muestra a continuación:

```bash
.
├── docs/
├── LICENSE
├── README.md
├── Makefile                        # Makefile general
└── src
    ├── constants
    │   ├── code_group_constants.v  # Code-groups definidos
    │   └── tx_o_set_constants.v    # Definiciones de tx_o_set
    ├── pcs
    │   ├── Makefile                # Ejecutar pruebas del pcs
    │   ├── pcs.v                   # Wrapper para conexión loopback
    │   ├── testbench.v             # Banco de pruebas pcs
    │   └── tester.v                # Probador pcs
    ├── receive
    │   ├── decode.v                # Decodificador 10b/8b
    │   ├── Makefile                # Ejecutar pruebas receptor
    │   ├── receive.v               # FSM del receptor
    │   ├── testbench.v             # Banco de pruebas receptor
    │   └── tester.v                # Probador receptor
    ├── running_disparity
    │   └── running_disparity.v     # Cálculo del rd
    ├── synchronization
    │   ├── Makefile                # Ejecutar pruebas sync
    │   ├── pudi_checker.v          # Verificar existencia de pudi
    │   ├── synchronization.v       # FSM del sync
    │   ├── testbench.v             # Banco de pruebas sync
    │   └── tester.v                # Probador sync
    ├── template.v                  # Plantilla
    └── transmit
        ├── encode.v                # Codificar 8b/10b
        ├── Makefile                # Ejecutar pruebas transmit
        ├── testbench.v             # Banco de pruebas transmit
        ├── tester.v                # Probador transmit
        ├── transmit_code_group.v   # FSM de code_groups
        ├── transmit_ordered_set.v  # FSM de ordered_set
        └── transmit_wrapper.v      # Wrapper de transmit
```
