/*
* =============================================================================
*
* - File        : running_disparity.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Calcula el nuevo running disparity según la cláusula 36 de IEEE 802.3.
*   Se implementó el procedimiento a continuación:
*
*   1) Separación del code-group
*     - Se toma la parte alta de 6 bits.
*     - Se toma la parte baja de 4 bits.
*
*   2) Evaluación del sub-bloque de 6 bits
*     - Se cuenta la cantidad de unos en six_bits.
*     - Se consideran los casos:
*         a) Patrón especial 6'b000111: RD+.
*         b) Patrón especial 6'b111000: RD−.
*         c) Más unos que ceros: RD+.
*         d) Más ceros que unos: RD−.
*         e) Mismo número de unos y ceros: RD anterior.
*
*   3) Evaluación del sub-bloque de 4 bits
*     - Se cuenta la cantidad de unos en four_bits.
*     - Se consideran los casos:
*         a) Patrón especial 4'b0011: RD+.
*         b) Patrón especial 4'b1100: RD−.
*         c) Más unos que ceros: RD+.
*         d) Más ceros que unos: RD−.
*         e) Mismo número de unos y ceros: RD de 6 bits.
*
*   La salida rd_out corresponde al running disparity al final del code-group
*   completo (10 bits).
*
* =============================================================================
*/

`ifndef RUNNING_DISPARITY_VH
`define RUNNING_DISPARITY_VH

module running_disparity #(
    parameter CG_WIDTH = 10
) (
    // INPUT
    input  wire                rd_in,       // RD- = 0, RD+ = 1
    input  wire [CG_WIDTH-1:0] code_group,  // CG entrante
    // OUTPUT
    output reg                 rd_out       // RD de salida
);

  /*
  * Variables internas
  */
  // Se separan en 6 bits y 4 bits para el cálculo
  wire [5:0] six_bits;
  wire [3:0] four_bits;

  // Guardar el RD intermedio
  reg        rd_after_six;

  // Contadores de unos
  reg  [2:0] ones_count_6b;
  reg  [2:0] ones_count_4b;


  /*
  * Assigns auxiliares para variables intermedias
  */
  assign six_bits  = code_group[9:4];
  assign four_bits = code_group[3:0];


  /*
  * Lógica combinacional
  */
  always @(*) begin

    /*
    * Contar unos en los 6 bits más significativos
    */
    ones_count_6b =
            six_bits[0] + six_bits[1] +
            six_bits[2] + six_bits[3] +
            six_bits[4] + six_bits[5];

    // Determinar RD al final del bloque de 6 bits
    if (six_bits == 6'b000111) begin
      // Caso 1: Este empate genera RD+
      rd_after_six = 1'b1;
    end else if (six_bits == 6'b111000) begin
      // Caso 2: Este empate genera RD-
      rd_after_six = 1'b0;
    end else if (ones_count_6b > 3) begin
      // Caso 3: Mayor cantidad de unos genera RD+
      rd_after_six = 1'b1;
    end else if (ones_count_6b < 3) begin
      // Caso 4: Menor cantidad de unos genera RD-
      rd_after_six = 1'b0;
    end else begin
      // Caso 5: Otros empates mantienen RD anterior
      rd_after_six = rd_in;
    end

    /*
    * Contar unos en los 4 bits menos significativos
    */
    ones_count_4b = four_bits[0] + four_bits[1] + four_bits[2] + four_bits[3];

    // Cálculo RD final
    if (four_bits == 4'b0011) begin
      // Caso 1: Este empate genera RD+
      rd_out = 1'b1;
    end else if (four_bits == 4'b1100) begin
      // Caso 2: Este empate genera RD-
      rd_out = 1'b0;
    end else if (ones_count_4b > 2) begin
      // Caso 3: Mayor cantidad de unos genera RD+
      rd_out = 1'b1;
    end else if (ones_count_4b < 2) begin
      // Caso 4: Menor cantidad de unos genera RD-
      rd_out = 1'b0;
    end else begin
      // Caso 5: Otros empates mantienen RD de 6 bits
      rd_out = rd_after_six;
    end

  end  // always @(*)

endmodule

`endif
