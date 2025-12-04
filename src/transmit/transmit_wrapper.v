/*
* =============================================================================
*
* - File        : transmit_wrapper.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Wrapper para el módulo de transmisión.
*   Conecta transmit_ordered_set con transmit_code_group.
*
* =============================================================================
*/

/*
 * Archivos incluidos
 */
`include "../transmit/transmit_code_group.v"
`include "../transmit/transmit_ordered_set.v"

module transmit_wrapper #(
    parameter integer CG_WIDTH = 10,
    parameter integer OCTET_WIDTH = 8
) (
    // INPUT
    input                        gtx_clk,        // Reloj de transmisión
    input                        mr_main_reset,  // Reinicio activo en alto
    input                        tx_en,          // Habilitación de TX
    input      [OCTET_WIDTH-1:0] txd,            // 8 bits a transmitir
    // OUTPUT
    output     [   CG_WIDTH-1:0] tx_code_group,  // CG para transmitir
    output reg                   pudr            // Indicador CG a PMA
);


  /*
  * Variables internas
  */
  localparam integer TX_O_SET_WIDTH = 5;

  // Conexiones
  wire [TX_O_SET_WIDTH-1:0] tx_o_set;
  wire                      tx_even;
  wire                      tx_oset_indicate;


  /*
  * Instanciación de transmit_code_group
  */
  transmit_code_group #(
      .CG_WIDTH      (CG_WIDTH),
      .OCTET_WIDTH   (OCTET_WIDTH),
      .TX_O_SET_WIDTH(TX_O_SET_WIDTH)
  ) cg (
      .gtx_clk         (gtx_clk),
      .mr_main_reset   (mr_main_reset),
      .txd             (txd),
      .tx_o_set        (tx_o_set),
      .tx_code_group   (tx_code_group),
      .tx_even         (tx_even),
      .tx_oset_indicate(tx_oset_indicate),
      .pudr            (pudr)
  );


  /*
  * Instanciación de transmit_ordered_set
  */
  transmit_ordered_set #(
      .TX_O_SET_WIDTH(TX_O_SET_WIDTH)
  ) os (
      .gtx_clk         (gtx_clk),
      .mr_main_reset   (mr_main_reset),
      .tx_even         (tx_even),
      .tx_oset_indicate(tx_oset_indicate),
      .tx_en           (tx_en),
      .tx_o_set        (tx_o_set)
  );


endmodule
