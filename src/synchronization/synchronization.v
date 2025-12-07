/*
* =============================================================================
*
* - File        : synchronization.v
* - Autor       : Rodrigo E. Sanchez Araya    (C37259)
*                 Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Máquina de estados del sincronizador.
*
* =============================================================================
*/

/*
* Incluir módulos
*/
`include "../synchronization/pudi_checker.v"


module synchronization #(
    parameter integer CG_WIDTH = 10
) (
    // INPUT
    input  wire                clk,               // Señal de reloj
    input  wire                mr_main_reset,     // Reinicio (activo en alto)
    input  wire                indicate,          // Se conecta a PUDR (pudi actualizado)
    input  wire [CG_WIDTH-1:0] pudi,              // Se conecta al tx_code_group
    // OUTPUT
    output reg                 code_sync_status,
    output reg                 rx_even,
    output reg  [  CG_WIDTH:0] sudi
);

  /*
  * Cables de conexión
  */
  wire pudi_invalid;
  wire comma_pudi;
  wire data_pudi;


  /*
  * Instanciación de pudi_checker
  */
  pudi_checker pudi_checker (
      .pudi        (pudi),
      .pudi_invalid(pudi_invalid),
      .comma_pudi  (comma_pudi),
      .data_pudi   (data_pudi)
  );


  /*
  * Asignación de states
  * Hot-One Encoding para evitar carreras de estado
  */
  localparam
    LOSS_OF_SYNC      = 10'b0000000001,
    COMMA_DETECT      = 10'b0000000010,
    ACQUIRE_SYNC      = 10'b0000000100,
    SYNC_ACQUIRED_1   = 10'b0000001000,
    SYNC_ACQUIRED_2   = 10'b0000010000,
    SYNC_ACQUIRED_3   = 10'b0000100000,
    SYNC_ACQUIRED_4   = 10'b0001000000,
    SYNC_ACQUIRED_2A  = 10'b0010000000,
    SYNC_ACQUIRED_3A  = 10'b0100000000,
    SYNC_ACQUIRED_4A  = 10'b1000000000;


  /*
  * Variables internas
  */
  // state actual y próximo state
  reg [9:0] state, next_state;

  // Almacenar paridad del rx
  reg rx_even_prev;

  // Contadores
  reg [1:0] comma_cont, comma_cont_next;
  reg [1:0] sync_cont, sync_cont_next;
  reg [1:0] good_cg_cont, good_cg_cont_prev;


  /*
  * Assigns auxiliares para variables intermedias
  */
  assign cggood = ~(pudi_invalid | (comma_pudi & rx_even));
  assign cgbad  = (pudi_invalid | (comma_pudi & rx_even));


  /*
  * Lógica secuencial
  */
  always @(posedge clk) begin
    if (mr_main_reset) begin
      // state inicial
      state             <= LOSS_OF_SYNC;
      rx_even_prev      <= 0;
      comma_cont        <= '0;
      sync_cont         <= '0;
      good_cg_cont_prev <= '0;

    end else begin
      // Actualizar al próximo estado
      state             <= next_state;
      rx_even_prev      <= rx_even;
      comma_cont        <= comma_cont_next;
      sync_cont         <= sync_cont_next;
      good_cg_cont_prev <= good_cg_cont;
      // Salida hacia receive
      sudi              <= {pudi, rx_even_prev};

    end
  end  // always @(posedge clk)


  /*
  * Lógica combinacional
  */
  always @(*) begin
    // Realimentación de los states: Valor por defecto
    next_state      = state;
    rx_even         = !rx_even_prev;
    comma_cont_next = comma_cont;
    sync_cont_next  = sync_cont;
    good_cg_cont    = good_cg_cont_prev;

    case (state)

      /*
      * LOSS_OF_SYNC
      * Cuando no hay sincronía, se espera una COMMA
      */
      LOSS_OF_SYNC: begin
        // No está sincronizado
        code_sync_status = 0;

        if (comma_pudi && indicate) begin
          next_state = COMMA_DETECT;
        end
      end  //LOSS_OF_SYNC

      /*
      * COMMA_DETECT
      * Se detectó una COMMA, se espera espera un dato válido para pasar de
      * estado.
      * Cuando detecta dos COMMAs y dos datos, se sincronizó
      */
      COMMA_DETECT: begin
        // Se coloca ciclo par
        rx_even = 1;

        if (comma_cont == 2'b10 && sync_cont == 2'b10) begin
          // Cuando se cuentan dos COMMAs y dos datos, se sincronizó
          next_state      = SYNC_ACQUIRED_1;
          sync_cont_next  = '0;
          comma_cont_next = '0;
        end else if (data_pudi) begin
          // Se detectó dato y pasa de estado
          next_state     = ACQUIRE_SYNC;
          sync_cont_next = sync_cont + 1;
        end else begin
          // Si no fue un dato válido, se perdió la sincronización
          next_state = LOSS_OF_SYNC;
        end

      end  //COMMA_DETECT

      /*
      * ACQUIRE_SYNC
      * Espera una COMMA en un ciclo impar.
      * Si el code-group es inválido, se pierde la sincronía
      */
      ACQUIRE_SYNC: begin
        if (cgbad) begin
          // Pérdida de sincronización
          next_state = LOSS_OF_SYNC;
        end else if (!rx_even && indicate && comma_pudi) begin
          // COMMA en ciclo impar
          next_state      = COMMA_DETECT;
          comma_cont_next = comma_cont + 1;
        end
      end  //ACQUIRE_SYNC

      /*
      * SYNC_ACQUIRED_1
      * Está sincronizado. Cambia de estado si recibe un code-group inválido
      */
      SYNC_ACQUIRED_1: begin
        // Está sincronizado
        code_sync_status = 1;

        if (cgbad) begin
          // Code group inválido
          next_state = SYNC_ACQUIRED_2;
        end
      end  // SYNC_ACQUIRED

      /*
      * SYNC_ACQUIRED_2
      * Recibió un code-group inválido después de estar sincronizado.
      */
      SYNC_ACQUIRED_2: begin
        // Contador de code-groups válidos en 0
        good_cg_cont = '0;

        if (cgbad) begin
          // Code-group inválido
          next_state = SYNC_ACQUIRED_3;
        end else if (cggood) begin
          // Code-group válido
          next_state = SYNC_ACQUIRED_2A;
        end
      end

      /*
      * SYNC_ACQUIRED_3
      * Recibió dos code-groups inválidos
      */
      SYNC_ACQUIRED_3: begin
        // Contador de code-groups válidos en 0
        good_cg_cont = '0;

        if (cgbad) begin
          // Code-group inválido
          next_state = SYNC_ACQUIRED_4;
        end else if (cggood) begin
          // Code-group válido
          next_state = SYNC_ACQUIRED_3A;
        end
      end  // SYNC_ACQUIRED_3

      /*
      * SYNC_ACQUIRED_4
      * Recibió tres code-groups inválidos
      */
      SYNC_ACQUIRED_4: begin
        // Contador de code-groups válidos en 0
        good_cg_cont = '0;

        if (cgbad) begin
          // Code-group válido
          next_state = LOSS_OF_SYNC;
        end else if (cggood) begin
          // Code-group inválido
          next_state = SYNC_ACQUIRED_4A;
        end
      end  // SYNC_ACQUIRED_4

      /*
      * SYNC_ACQUIRED_2A
      * Recibió un code-group válido después de estar en SYNC_ACQUIRED_2
      */
      SYNC_ACQUIRED_2A: begin
        // Aumentar contador de code-groups válidos
        good_cg_cont = good_cg_cont_prev + 1;

        if (cgbad) begin
          // Code-group inválido
          next_state = SYNC_ACQUIRED_3;
        end else if (good_cg_cont == 2'b11) begin
          // Si el contador llega a 3, se sincronizó nuevamente
          next_state = SYNC_ACQUIRED_1;
        end
      end  // SYNC_ACQUIRED_2A

      /*
      * SYNC_ACQUIRED_3A
      * Recibió un code-group válido después de estar en SYNC_ACQUIRED_3
      */
      SYNC_ACQUIRED_3A: begin
        // Aumentar contador de code-groups válidos
        good_cg_cont = good_cg_cont_prev + 1;

        if (cgbad) begin
          // Code-group inválido
          next_state = SYNC_ACQUIRED_4;
        end else if (good_cg_cont == 2'b11) begin
          // Si el contador llega a 3, pasa a SYNC_ACQUIRED_2
          next_state = SYNC_ACQUIRED_2;
        end
      end  // SYNC_ACQUIRED_3A

      /*
      * SYNC_ACQUIRED_4A
      * Recibió un code-group válido después de estar en SYNC_ACQUIRED_4
      */
      SYNC_ACQUIRED_4A: begin
        // Aumentar contador de code-groups válidos
        good_cg_cont = good_cg_cont_prev + 1;

        if (cgbad) begin
          // Code-group inválido: Pierde sincronización
          next_state = LOSS_OF_SYNC;
        end else if (good_cg_cont == 2'b11) begin
          // Si el contador llega a 3, pasa a SYNC_ACQUIRED_3
          next_state = SYNC_ACQUIRED_3;
        end
      end  // SYNC_ACQUIRED_4A

      /*
      * default
      * state inicial como predeterminado
      */
      default: begin
        next_state = LOSS_OF_SYNC;
      end  // default

    endcase

  end  // always @(*)

endmodule
