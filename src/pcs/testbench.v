/*
* =============================================================================
*
* - File        : testbench.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Banco de pruebas para la subcapa PCS completa.
*
* =============================================================================
*/

`include "pcs.v"
`include "tester.v"

module testbench;

  /*
  * Parámetros locales
  */
  localparam CG_WIDTH = 10;
  localparam OCTET_WIDTH = 8;
  localparam CLK_PERIOD = 10;


  /*
  * Cables de conexión
  */
  wire clk;
  wire mr_main_reset;
  wire tx_en;
  wire [OCTET_WIDTH-1:0] txd;
  wire [OCTET_WIDTH-1:0] rxd;
  wire rx_dv;
  wire rx_er;



  /*
  * Instanciación del dut (PCS)
  */
  pcs #(
      .CG_WIDTH   (CG_WIDTH),
      .OCTET_WIDTH(OCTET_WIDTH)
  ) pcs (
      .clk          (clk),
      .mr_main_reset(mr_main_reset),
      .tx_en        (tx_en),
      .txd          (txd),
      .rxd          (rxd),
      .rx_dv        (rx_dv),
      .rx_er        (rx_er)
  );


  /*
  * Instanciación del probador (GMII)
  */
  tester #(
      .CG_WIDTH   (CG_WIDTH),
      .OCTET_WIDTH(OCTET_WIDTH),
      .CLK_PERIOD (CLK_PERIOD)
  ) gmii (
      .clk          (clk),
      .mr_main_reset(mr_main_reset),
      .tx_en        (tx_en),
      .txd          (txd),
      .rxd          (rxd),
      .rx_dv        (rx_dv),
      .rx_er        (rx_er)
  );


endmodule
