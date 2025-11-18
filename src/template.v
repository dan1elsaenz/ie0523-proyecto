/*
* =============================================================================
*
* - File        : template.v
* - Autor       : nombre (carné)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : dd-mm-yyyy
*
* - Descripción :
*
* =============================================================================
*/


module template #(
    parameter integer param = 1
) (
    // INPUT

    // OUTPUT
);


  /*
  * Asignación de estados
  * Hot-One Encoding para evitar carreras de estado
  */
  localparam integer
    STATE1  = 5'b00001,
    STATE2  = 5'b00010,
    STATE3  = 5'b00100,
    STATE4  = 5'b01000,
    STATE5  = 5'b10000;


  /*
  * Variables internas
  */
  // Estado actual y próximo estado
  reg [4:0] estado, prox_estado;


  /*
  * Assigns auxiliares para variables intermedias
  */


  /*
  * Lógica secuencial
  */
  always @(posedge clk) begin
    if (~reset) begin
      // Estado inicial
      estado <= STATE1;

    end else begin
      // Actualizar al próximo estado
      estado <= prox_estado;
    end

  end  // always @(posedge clk)


  /*
  * Lógica combinacional
  */
  always @(*) begin

    // Realimentación de los estados: Valor por defecto
    prox_estado = estado;

    case (estado)

      /*
      * STATE1
      * Descripción
      */
      STATE1: begin

      end  // STATE1


      /*
      * default
      * Estado inicial como predeterminado
      */
      default: begin
        prox_estado = STATE1;
      end  // default

    endcase

  end  // always @(*)

endmodule
