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


module synchronization #(
    parameter integer param = 1
) (
    // INPUT
    input wire       mr_main_reset, 
    input wire       clk,
    input wire       signal_detectCHANGE, 
    input wire       signal_detect, 
    input wire       VALID_PUDI, // Se conecta a PUDR
    input wire [9:0] PUDI,  // Se conecta al code_group




    // OUTPUT
    output reg        code_sync_status,
    output reg        rx_even,
    output reg [10:0] SUDI

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

  // De momento meintras hago el include de los valores
  localparam [9:0] COMMA = 10'b1100000101; // ASUMIENDO CASO IDEAL DE RD+
  localparam [9:0] D     = 10'b0101101001;


  /*
  * Variables internas
  */
  // state actual y próximo state
  reg [6:0] state, next_state; // Estado y proximo estado
  reg [1:0] comma_cont; 
  reg [1:0] sync_cont; 
  reg [2:0] bad_cg_cont; 
  reg [1:0] good_cg_cont; 
  reg       cg; // cg = 1 -> good_cg | cg = 0 -> bad_cg
  reg       loss_sync; 
  reg       VALID_SIGNAL;
  /*
  * Assigns auxiliares para variables intermedias
  */


  /*
  * Lógica secuencial
  */
  always @(posedge clk) begin
    if (!mr_main_reset) begin
      // state inicial
      state <= IDLE;

    end else begin
      // Actualizar al próximo state
      state <= next_state;


      VALID_SIGNAL <= (VALID_PUDI || signal_detect);
      loss_sync <= (signal_detectCHANGE && VALID_PUDI);
      //Asignacion de parametros en el estado de LOSS_OF_SYNC
      if (state == LOSS_OF_SYNC) begin 
        code_sync_status <= 0;
        rx_even <= !rx_even;
        SUDI <= {PUDI, rx_even}; 
      end 


      //Asignacion de parametros en el estado de COMMA_DETECT
      if (state == COMMA_DETECT) begin 
        comma_cont <= comma_cont + 1; 
        rx_even <= 1;
        SUDI <= {PUDI, rx_even}; 
      end 


     //Asignacion de parametros en el estado de ACQUIRE_SYNC
      if (state == ACQUIRE_SYNC) begin 
        sync_cont <= sync_cont + 1; 
        rx_even <= !rx_even;
        SUDI <= {PUDI, rx_even}; 
      end else if (state == ACQUIRE_SYNC && cg == 1) begin 
        sync_cont <= sync_cont - 1; 
      end

      //Asignacion de parametros en el estado de SYNC_ACQUIRED_1
      if (state == SYNC_ACQUIRED_1) begin 
        code_sync_status <=  1; 
        rx_even <= !rx_even;
        SUDI <= {PUDI, rx_even}; 
      end 

      //Asignacion de parametros en el estado de SYNC_ACQUIRED_2
      if (state == SYNC_ACQUIRED_2) begin 
        bad_cg_cont <= bad_cg_cont + 1; 
        rx_even <= !rx_even; 
        SUDI <= {PUDI, rx_even}; 
        good_cg_cont <= 0; 
      end


      //Asignacion de parametros en el estado de SYNC_ACQUIRED_3
      if (state == SYNC_ACQUIRED_3) begin 
        bad_cg_cont <= bad_cg_cont - 1; 
        good_cg_cont <= good_cg_cont + 1; 
        rx_even <= !rx_even; 
        SUDI <= {PUDI, rx_even}; 
        good_cg_cont <= 0; 
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
      * IDLE
      * Descripcion:
      */
      IDLE: begin
        if(mr_main_reset && loss_sync) begin 
          next_state = LOSS_OF_SYNC;
        end else begin 
          next_state = IDLE; 
        end
      end  // Idle



      /*
      * LOSS_OF_SYNC
      *  Descripcion: 
      */
      LOSS_OF_SYNC: begin 
        // AGREGAR EL CODIGO DE COMA
        if (PUDI == COMMA && VALID_SIGNAL) begin 
          next_state = COMMA_DETECT;
        end else begin
          next_state = LOSS_OF_SYNC; 
        end 
      end //LOSS_OF_SYNC

      /*
      * COMMA_DETECT
      *  Descripcion: 
      */

      COMMA_DETECT: begin 
        if (PUDI == D) begin 
          next_state = ACQUIRE_SYNC; 
        end else begin 
          next_state = LOSS_OF_SYNC; 
        end 
      end //COMMA_DETECT


      /*
      * ACQUIRED_SYNC
      *  Descripcion: 
      */

      ACQUIRE_SYNC: begin 
        if (!cg) begin 
          if (VALID_PUDI || PUDI == COMMA) begin 
            if (rx_even) begin 
              next_state = LOSS_OF_SYNC;
            end else begin
              if (comma_cont == 2'b11 && sync_cont == 2'b10) begin 
                next_state = SYNC_ACQUIRED_1;
              end else begin 
                next_state = COMMA_DETECT;
              end 
            end
          end else begin 
            next_state = ACQUIRE_SYNC; 
          end 

        end else begin 
          next_state = LOSS_OF_SYNC;
        end 
      end //ACQUIRE_SYNC


      /*
      * SYNC_ACQUIRED_1
      *  Descripcion: 
      */

      SYNC_ACQUIRED_1: begin
        if (cg) begin 
          next_state = SYNC_ACQUIRED_1;
        end else begin
          next_state = SYNC_ACQUIRED_2;  
        end
      end // SYNC_ACQUIRED

      /*
      * SYNC_ACQUIRED_2
      *  Descripcion: 
      */
      SYNC_ACQUIRED_2 : begin 
        if (bad_cg_cont == 3'b100) begin 
          next_state = LOSS_OF_SYNC; 
        end else begin
            if (cg) begin 
              next_state = SYNC_ACQUIRED_3;
            end else if (!cg) begin
              next_state = SYNC_ACQUIRED_2;  
            end 
        end
      end // SYNC_ACQUIRED_2

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

      end //SYNC_ACQUIRED_3


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
