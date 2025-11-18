/*
* =============================================================================
*
* - File        : transmit/testbench.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Banco de pruebas para el módulo de transmisión.
*
* =============================================================================
*/


/*
 * Archivos incluidos
 */
`include "transmit_wrapper.v"
`include "tester.v"

module testbench;

  // Iniciar registro de variables para GTKWave
  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(-1, testbench);
  end

  /*
  * Variables internas
  */
  localparam integer CG_WIDTH = 10;
  localparam integer OCTET_WIDTH = 8;
  localparam integer CLK_PERIOD = 10;

  // Conexiones
  wire                   gtx_clk;
  wire                   mr_main_reset;
  wire                   tx_en;
  wire [OCTET_WIDTH-1:0] txd;
  wire [   CG_WIDTH-1:0] tx_code_group;
  wire                   pudr;


  /*
  * Instanciación de transmit_code_group
  */
  transmit_wrapper #(
      .CG_WIDTH   (CG_WIDTH),
      .OCTET_WIDTH(OCTET_WIDTH)
  ) tx_wrapper (
      .gtx_clk      (gtx_clk),
      .mr_main_reset(mr_main_reset),
      .tx_en        (tx_en),
      .txd          (txd),
      .tx_code_group(tx_code_group),
      .pudr         (pudr)
  );


  /*
  * Instanciación de transmit/tester
  */
  tester #(
      .CG_WIDTH   (CG_WIDTH),
      .OCTET_WIDTH(OCTET_WIDTH),
      .CLK_PERIOD(CLK_PERIOD)
  ) tx_tester (
      .gtx_clk      (gtx_clk),
      .mr_main_reset(mr_main_reset),
      .tx_en        (tx_en),
      .txd          (txd)
  );

endmodule
