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

`include "../synchronization/PUDI_checker.v"
module synchronization #(
    parameter integer param = 1
) (
    // INPUT
    input wire       mr_main_reset,
    input wire       clk,
    input wire       VALID_PUDI,     // Se conecta a PUDR
    input wire [9:0] PUDI,           // Se conecta al code_group




    // OUTPUT
    output reg        code_sync_status,
    output reg        rx_even,
    output reg [10:0] SUDI

);

  wire PUDI_INVALID;
  wire comma_PUDI;
  wire D_PUDI;


  PUDI_checker u1 (
      .PUDI(PUDI),
      .PUDI_INVALID(PUDI_INVALID),
      .comma_PUDI(comma_PUDI),
      .D_PUDI(D_PUDI)
  );


  /*
  * Asignación de states
  * Hot-One Encoding para evitar carreras de state
  */
  localparam
    IDLE              = 7'b0000001,
    LOSS_OF_SYNC      = 7'b0000010,
    COMMA_DETECT      = 7'b0000100,
    ACQUIRE_SYNC      = 7'b0001000,
    SYNC_ACQUIRED_1   = 7'b0010000,
    SYNC_ACQUIRED_2   = 7'b0100000,
    SYNC_ACQUIRED_3   = 7'b1000000;


  /*
  * Variables internas
  */
  // state actual y próximo state
  reg [6:0] state, next_state;  // Estado y proximo estado
  reg  [1:0] comma_cont;
  reg  [1:0] sync_cont;
  reg  [2:0] bad_cg_cont;
  reg  [1:0] good_cg_cont;
  reg        VALID_SIGNAL;
  wire       cg;

  /*
  * Assigns auxiliares para variables intermedias
  */
  assign cg = ~PUDI_INVALID;

  /*
  * Lógica secuencial
  */
  always @(posedge clk) begin
    if (mr_main_reset) begin
      // state inicial
      state        <= LOSS_OF_SYNC;
      bad_cg_cont  <= 2'b00;
      comma_cont   <= 2'b00;
      sync_cont    <= 2'b00;
      good_cg_cont <= 2'b00;
      rx_even      <= 0;
      VALID_SIGNAL <= 0;

    end else begin
      // Actualizar al próximo state
      state <= next_state;


      VALID_SIGNAL <= (VALID_PUDI);

      //Asignacion de parametros en el estado de LOSS_OF_SYNC
      if (state == LOSS_OF_SYNC) begin
        rx_even <= !rx_even;

        // FIX:
        // SUDI <= {PUDI, rx_even};
        SUDI <= '0;
      end


      //Asignacion de parametros en el estado de COMMA_DETECT
      if (state == COMMA_DETECT) begin
        comma_cont <= comma_cont + 1;
        rx_even <= 1;

        // FIX:
        // SUDI <= {PUDI, rx_even};
        SUDI <= '0;
      end


      //Asignacion de parametros en el estado de ACQUIRE_SYNC
      if (state == ACQUIRE_SYNC) begin

        sync_cont <= sync_cont + 1;
        rx_even <= !rx_even;
        SUDI <= {PUDI, rx_even};
        if (rx_even == 0 && PUDI == comma_PUDI) begin
          comma_cont <= comma_cont + 1;
        end
      end else if (state == ACQUIRE_SYNC && cg == 1) begin
        sync_cont <= sync_cont - 1;
      end

      //Asignacion de parametros en el estado de SYNC_ACQUIRED_1
      if (state == SYNC_ACQUIRED_1) begin
        rx_even <= !rx_even;
        SUDI <= {PUDI, rx_even};
        if (cg == 0) begin
          good_cg_cont <= 2'b00;
          bad_cg_cont  <= bad_cg_cont + 1;
        end else if (cg == 1) begin
          good_cg_cont <= good_cg_cont + 1;
          if (bad_cg_cont == 2'b00) begin
            bad_cg_cont <= 2'b00;
          end else begin
            bad_cg_cont <= bad_cg_cont - 1;
          end
        end
      end

      //Asignacion de parametros en el estado de SYNC_ACQUIRED_2
      if (state == SYNC_ACQUIRED_2) begin
        rx_even <= !rx_even;
        SUDI <= {PUDI, rx_even};
        if (good_cg_cont == 0) begin
          good_cg_cont <= 0;

        end else if (cg == 0) begin
          good_cg_cont <= good_cg_cont - 1;
          bad_cg_cont  <= bad_cg_cont + 1;
        end else if (cg == 1) begin
          good_cg_cont <= good_cg_cont + 1;
          if (bad_cg_cont == 2'b00) begin
            bad_cg_cont <= 2'b00;
          end else if (bad_cg_cont != 2'b00) begin
            bad_cg_cont <= bad_cg_cont - 1;
          end
        end
      end


      //Asignacion de parametros en el estado de SYNC_ACQUIRED_3
      if (state == SYNC_ACQUIRED_3) begin
        rx_even <= !rx_even;
        SUDI <= {PUDI, rx_even};
        if (cg == 0) begin
          bad_cg_cont  <= bad_cg_cont + 1;
          good_cg_cont <= 2'b00;
        end else if (cg == 1) begin
          good_cg_cont <= good_cg_cont + 1;
          if (bad_cg_cont == 2'b00) begin
            bad_cg_cont <= 2'b00;
          end else if (bad_cg_cont != 2'b00) begin
            bad_cg_cont <= bad_cg_cont - 1;
          end

        end
      end

      // Reseteo de contadores de cg_bad y cg_good
      if (bad_cg_cont == 3'b100) begin
        bad_cg_cont <= 3'b100;
      end

      if (good_cg_cont == 2'b11) begin
        good_cg_cont <= 2'b11;
      end


    end

  end  // always @(posedge clk)

  /*
  * Lógica combinacional
  */
  always @(*) begin
    next_state = state;
    // Realimentación de los states: Valor por defecto
    next_state = state;

    case (state)

      /*
      * LOSS_OF_SYNC
      *  Descripcion:
      */
      LOSS_OF_SYNC: begin
        code_sync_status = 0;
        if (comma_PUDI && VALID_SIGNAL) begin
          next_state = COMMA_DETECT;
        end
      end  //LOSS_OF_SYNC

      /*
      * COMMA_DETECT
      *  Descripcion:
      */

      COMMA_DETECT: begin
        if (D_PUDI) begin
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
      *  Descripcion:
      */

      ACQUIRE_SYNC: begin
        if (cg == 1) begin
          if (VALID_PUDI || comma_PUDI) begin
              next_state = COMMA_DETECT;
          end else begin
            next_state = ACQUIRE_SYNC;
          end
        end else if (cg == 0) begin
          next_state = LOSS_OF_SYNC;
        end
      end  //ACQUIRE_SYNC


      /*
      * SYNC_ACQUIRED_1
      *  Descripcion:
      */

      SYNC_ACQUIRED_1: begin
        code_sync_status = 1;
        if (cg == 1) begin
          next_state = SYNC_ACQUIRED_1;
        end else if (cg == 0) begin
          next_state = SYNC_ACQUIRED_2;
        end
      end  // SYNC_ACQUIRED

      /*
      * SYNC_ACQUIRED_2
      *  Descripcion:
      */
      SYNC_ACQUIRED_2: begin
        if (bad_cg_cont == 3'b100) begin
          next_state = LOSS_OF_SYNC;
        end else begin
          if (cg) begin
            next_state = SYNC_ACQUIRED_3;
          end else if (!cg) begin
            next_state = SYNC_ACQUIRED_2;
          end
        end
      end  // SYNC_ACQUIRED_2

      /*
      * SYNC_ACQUIRED_3
      *  Descripcion:
      */
      SYNC_ACQUIRED_3: begin
        if (cg) begin
          if (good_cg_cont == 2'b11) begin
            if (bad_cg_cont == 3'b000) begin
              next_state = SYNC_ACQUIRED_1;
            end else begin
              next_state = SYNC_ACQUIRED_2;
            end
          end else begin
            next_state = SYNC_ACQUIRED_2;
          end
        end

      end  //SYNC_ACQUIRED_3


      /*
      * default
      * state inicial como predeterminado
      */
      default: begin
        next_state = IDLE;
      end  // default

    endcase

  end  // always @(*)

endmodule
