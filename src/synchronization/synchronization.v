/*
* =============================================================================
*
* - File        : synchronization.v
* - Autor       : Rodrigo E. Sanchez Araya
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 19-11-2025
*
* - Descripción :
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
    input  wire                valid_pudi,        // Se conecta a PUDR
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
  reg  [1:0] comma_cont;
  reg  [1:0] sync_cont;
  reg  [2:0] bad_cg_cont;
  reg  [1:0] good_cg_cont;
  reg        rx_even_prev;
  wire       cg;

  /*
  * Assigns auxiliares para variables intermedias
  */
  assign cg     = ~pudi_invalid;
  assign cggood = ~(pudi_invalid | (comma_pudi & rx_even)) & (pudi != '0);
  assign cgbad  = (pudi_invalid | (comma_pudi & rx_even)) & (pudi != '0);

  /*
  * Lógica secuencial
  */
  always @(posedge clk) begin

    if (mr_main_reset) begin
      // state inicial
      state        <= LOSS_OF_SYNC;
      bad_cg_cont  <= '0;
      comma_cont   <= '0;
      sync_cont    <= '0;
      good_cg_cont <= '0;
      rx_even_prev <= 0;

    end else begin
      // Actualizar al próximo estado
      state        <= next_state;
      rx_even_prev <= rx_even;
      sudi         <= {pudi, rx_even_prev};

      // Señales en COMMA_DETECT
      if (state == COMMA_DETECT) begin
        comma_cont <= comma_cont + 1;
      end

      // Señales en ACQUIRE_SYNC
      if (state == ACQUIRE_SYNC) begin
        if (!rx_even && valid_pudi && comma_pudi) begin
          sync_cont <= sync_cont + 1;
        end
      end

      if (state == SYNC_ACQUIRED_2) begin
        good_cg_cont <= '0;
      end

      if (state == SYNC_ACQUIRED_3) begin
        good_cg_cont <= '0;
      end

      if (state == SYNC_ACQUIRED_4) begin
        good_cg_cont <= '0;
      end

      if (state == SYNC_ACQUIRED_2A) begin
        good_cg_cont <= good_cg_cont + 1;
      end

      if (state == SYNC_ACQUIRED_3A) begin
        good_cg_cont <= good_cg_cont + 1;
      end

      if (state == SYNC_ACQUIRED_4A) begin
        good_cg_cont <= good_cg_cont + 1;
      end

    end
  end  // always @(posedge clk)


  /*
  * Lógica combinacional
  */
  always @(*) begin
    // Realimentación de los states: Valor por defecto
    next_state = state;
    rx_even    = !rx_even_prev;

    case (state)

      /*
      * LOSS_OF_SYNC
      */
      LOSS_OF_SYNC: begin
        code_sync_status = 0;
        if (comma_pudi && valid_pudi) begin
          next_state = COMMA_DETECT;
        end
      end  //LOSS_OF_SYNC


      /*
      * COMMA_DETECT
      */
      COMMA_DETECT: begin
        rx_even = 1;

        if (data_pudi) begin
          next_state = ACQUIRE_SYNC;

          if (comma_cont == 2'b10 && sync_cont == 2'b10) begin
            next_state = SYNC_ACQUIRED_1;
          end
        end else begin
          next_state = LOSS_OF_SYNC;
        end

      end  //COMMA_DETECT


      /*
      * ACQUIRED_SYNC
      */
      ACQUIRE_SYNC: begin
        if (cgbad) begin
          next_state = LOSS_OF_SYNC;
        end else begin
          if (!rx_even && valid_pudi && comma_pudi) begin
            next_state = COMMA_DETECT;
          end else next_state = ACQUIRE_SYNC;
        end
      end  //ACQUIRE_SYNC


      /*
      * SYNC_ACQUIRED_1
      */
      SYNC_ACQUIRED_1: begin
        code_sync_status = 1;
        if (cgbad) begin
          next_state = SYNC_ACQUIRED_2;
        end
      end  // SYNC_ACQUIRED


      /*
      * SYNC_ACQUIRED_2
      */
      SYNC_ACQUIRED_2: begin
        if (cgbad) begin
          next_state = SYNC_ACQUIRED_3;
        end else if (cggood) begin
          next_state = SYNC_ACQUIRED_2A;
        end
      end

      /*
      * SYNC_ACQUIRED_3
      */
      SYNC_ACQUIRED_3: begin
        if (cgbad) begin
          next_state = SYNC_ACQUIRED_4;
        end else if (cggood) begin
          next_state = SYNC_ACQUIRED_3A;
        end
      end

      /*
      * SYNC_ACQUIRED_4
      */
      SYNC_ACQUIRED_4: begin
        if (cgbad) begin
          next_state = LOSS_OF_SYNC;
        end else if (cggood) begin
          next_state = SYNC_ACQUIRED_4A;
        end
      end

      /*
      * SYNC_ACQUIRED_2A
      */
      SYNC_ACQUIRED_2A: begin
        if (cgbad) begin
          next_state = SYNC_ACQUIRED_3;
        end else if (good_cg_cont == 2'b01) begin
          next_state = SYNC_ACQUIRED_1;
        end
      end

      /*
      * SYNC_ACQUIRED_3A
      */
      SYNC_ACQUIRED_3A: begin
        if (cgbad) begin
          next_state = SYNC_ACQUIRED_4;
        end else if (good_cg_cont == 2'b10) begin
          next_state = SYNC_ACQUIRED_2;
        end
      end

      /*
      * SYNC_ACQUIRED_4A
      */
      SYNC_ACQUIRED_4A: begin
        if (cgbad) begin
          next_state = LOSS_OF_SYNC;
        end else if (good_cg_cont == 2'b10) begin
          next_state = SYNC_ACQUIRED_3;
        end
      end

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
