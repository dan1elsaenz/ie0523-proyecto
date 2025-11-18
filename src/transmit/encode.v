/*
* =============================================================================
*
* - File        : encode.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Módulo de codificación 8B/10B para la transmisión del PCS.
*   Recibe un octeto (D o K) y el running_disparity (tx_disparity). Retorna el
*   code-group de 10 bits correspondiente en tx_code_group, al seleccionar la
*   versión RD+ o RD− según tx_disparity.
*
*   Sólo se codifican los code-groups definidos en code_group_constants.v
*   Cualquier otro valor genera 10'b0.
*
* =============================================================================
*/


/*
 * Archivos incluidos
 */
`include "../constants/code_group_constants.v"

module encode #(
    parameter integer CG_WIDTH = 10,
    parameter integer OCTET_WIDTH = 8
) (
    input  wire [OCTET_WIDTH-1:0] octet,         // Entrada de 8 bits
    input  wire                   tx_is_k,       // K = 1, D = 0
    input  wire                   tx_disparity,  // RD- = 0, RD+ = 1
    output reg  [   CG_WIDTH-1:0] tx_code_group  // CG de 10 bits
);

  /*
  * Lógica combinacional
  */
  always @(*) begin

    case ({
      tx_is_k, octet
    })

      /*
       * Caracteres especiales K
       * tx_is_k = 1
       */
      {1'b1, `K28_5_8B} : tx_code_group = (tx_disparity) ? `K28_5_10B_RD_P : `K28_5_10B_RD_N;

      {1'b1, `K23_7_8B} : tx_code_group = (tx_disparity) ? `K23_7_10B_RD_P : `K23_7_10B_RD_N;

      {1'b1, `K27_7_8B} : tx_code_group = (tx_disparity) ? `K27_7_10B_RD_P : `K27_7_10B_RD_N;

      {1'b1, `K29_7_8B} : tx_code_group = (tx_disparity) ? `K29_7_10B_RD_P : `K29_7_10B_RD_N;

      /*
       * Datos válidos D
       * tx_is_k = 0
       */
      // Para IDLE
      {1'b0, `D5_6_8B} : tx_code_group = (tx_disparity) ? `D5_6_10B_RD_P : `D5_6_10B_RD_N;

      {1'b0, `D16_2_8B} : tx_code_group = (tx_disparity) ? `D16_2_10B_RD_P : `D16_2_10B_RD_N;

      // Restantes
      {1'b0, `D0_0_8B} : tx_code_group = (tx_disparity) ? `D0_0_10B_RD_P : `D0_0_10B_RD_N;

      {1'b0, `D1_0_8B} : tx_code_group = (tx_disparity) ? `D1_0_10B_RD_P : `D1_0_10B_RD_N;

      {1'b0, `D2_0_8B} : tx_code_group = (tx_disparity) ? `D2_0_10B_RD_P : `D2_0_10B_RD_N;

      {1'b0, `D2_2_8B} : tx_code_group = (tx_disparity) ? `D2_2_10B_RD_P : `D2_2_10B_RD_N;

      {1'b0, `D21_5_8B} : tx_code_group = (tx_disparity) ? `D21_5_10B_RD_P : `D21_5_10B_RD_N;

      {1'b0, `D11_3_8B} : tx_code_group = (tx_disparity) ? `D11_3_10B_RD_P : `D11_3_10B_RD_N;

      {1'b0, `D23_1_8B} : tx_code_group = (tx_disparity) ? `D23_1_10B_RD_P : `D23_1_10B_RD_N;

      {1'b0, `D7_4_8B} : tx_code_group = (tx_disparity) ? `D7_4_10B_RD_P : `D7_4_10B_RD_N;

      {1'b0, `D12_5_8B} : tx_code_group = (tx_disparity) ? `D12_5_10B_RD_P : `D12_5_10B_RD_N;

      {1'b0, `D28_5_8B} : tx_code_group = (tx_disparity) ? `D28_5_10B_RD_P : `D28_5_10B_RD_N;

      {1'b0, `D3_6_8B} : tx_code_group = (tx_disparity) ? `D3_6_10B_RD_P : `D3_6_10B_RD_N;

      {1'b0, `D8_6_8B} : tx_code_group = (tx_disparity) ? `D8_6_10B_RD_P : `D8_6_10B_RD_N;

      {1'b0, `D19_2_8B} : tx_code_group = (tx_disparity) ? `D19_2_10B_RD_P : `D19_2_10B_RD_N;

      {1'b0, `D24_3_8B} : tx_code_group = (tx_disparity) ? `D24_3_10B_RD_P : `D24_3_10B_RD_N;

      {1'b0, `D31_1_8B} : tx_code_group = (tx_disparity) ? `D31_1_10B_RD_P : `D31_1_10B_RD_N;

      {1'b0, `D10_1_8B} : tx_code_group = (tx_disparity) ? `D10_1_10B_RD_P : `D10_1_10B_RD_N;

      {1'b0, `D29_3_8B} : tx_code_group = (tx_disparity) ? `D29_3_10B_RD_P : `D29_3_10B_RD_N;

      {1'b0, `D4_6_8B} : tx_code_group = (tx_disparity) ? `D4_6_10B_RD_P : `D4_6_10B_RD_N;

      default: begin
        // Valor predeterminado
        tx_code_group = 10'b000000_0000;
      end
    endcase

  end  // always @(*)

endmodule
