/*
* =============================================================================
*
* - File        : transmit_ordered_set.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Máquina de estadaos de transmit ordered set, descrita en la cláusula 36
*   del estándar IEEE 802.3 de la capa PCS de Ethernet. Genera las señales de
*   tx_o_set que son enviadas al transmit_code_group para codificar el octeto.
*
* =============================================================================
*/


/*
 * Archivos incluidos
 */
`include "../constants/tx_o_set_constants.v"


module transmit_ordered_set #(
    parameter integer TX_O_SET_WIDTH = 5
) (
    // INPUT
    input                           gtx_clk,           // Reloj de transmisión
    input                           mr_main_reset,     // Reinicio activo en alto
    input                           tx_even,           // Indicador ciclo par/impar
    input                           tx_oset_indicate,  // Indicador CG listo
    input                           tx_en,             // Habilitación de TX
    // OUTPUT
    output reg [TX_O_SET_WIDTH-1:0] tx_o_set           // Identificador de CG
);


  /*
  * Asignación de estados
  * Hot-One Encoding para evitar carreras de estado
  */
  localparam integer XMIT_DATA = 3'b001, TX_PACKET = 3'b010, EPD = 3'b100;


  /*
  * Variables internas
  */
  // Estado actual y próximo estado
  reg [2:0] estado, prox_estado;


  /*
  * Lógica secuencial
  */
  always @(posedge gtx_clk) begin
    if (mr_main_reset) begin
      // Estado inicial
      estado <= XMIT_DATA;

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
      * XMIT_DATA
      *
      * Transmite IDLEs /I/ o condición de inicio /S/ si se activa tx_en
      */
      XMIT_DATA: begin

        // Cambio de estado
        if (tx_en && tx_oset_indicate) begin
          tx_o_set = `S_OS;

          // Cambio de estado
          prox_estado = TX_PACKET;
        end else begin
          // IDLE
          tx_o_set = `I_OS;
        end
      end  // XMIT_DATA

      /*
      * TX_PACKET
      *
      * tx_o_set dependiendo de tx_en (habilitación de tx)
      * Envía /D/ (dato) o /T/ (terminate) si !tx_en
      */
      TX_PACKET: begin
        if (tx_en) begin
          // Dato
          tx_o_set = `D_OS;

        end else begin
          // Terminate
          tx_o_set = `T_OS;

          if (tx_oset_indicate) prox_estado = EPD;
        end
      end  // TX_PACKET

      /*
      * EPD
      *
      * Envía primer /R/
      * Decide si hay que hacer carrier extend (/R/ en
      * ciclo par)
      */
      EPD: begin
        tx_o_set = `R_OS;

        // Determinar si hay que hacer carrier_extend
        if (!tx_even && tx_oset_indicate) begin
          // Ciclo impar: No se hace
          prox_estado = XMIT_DATA;
        end
      end  // EPD

      /*
      * default
      * Estado inicial como predeterminado
      */
      default: begin
        prox_estado = estado;
      end  // default

    endcase

  end  // always @(*)

endmodule
