/*
* =============================================================================
*
* - File        : testbench.v
* - Autor       : Rodrigo E. Sanchez Araya    (C37259)
*                 Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Banco de pruebas para el sincronizador.
*
* =============================================================================
*/

/*
* Incluir módulos
*/
`include "../synchronization/tester.v"
`include "../synchronization/synchronization.v"


module testbench;

  // Guardar variables para visualizar en GTKWave
  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(-1, U0);
  end

  /*
  * Parámetros locales
  */
  localparam CG_WIDTH = 10;
  localparam CLK_PERIOD = 10;


  /*
  * Cables de conexión
  */
  wire                mr_main_reset;
  wire                clk;
  wire                valid_pudi;  // Se conecta a PUDR
  wire [CG_WIDTH-1:0] pudi;  // Se conecta al code_group
  wire                code_sync_status;
  wire                rx_even;
  wire [  CG_WIDTH:0] sudi;


  /*
  * Instanciación de synchronization
  */
  synchronization #(
      .CG_WIDTH(CG_WIDTH)
  ) U0 (
      .clk             (clk),
      .mr_main_reset   (mr_main_reset),
      .indicate        (indicate),
      .pudi            (pudi),
      .code_sync_status(code_sync_status),
      .rx_even         (rx_even),
      .sudi            (sudi)
  );


  /*
  * Instanciación del tester
  */
  tester #(
      .CG_WIDTH  (CG_WIDTH),
      .CLK_PERIOD(CLK_PERIOD)
  ) P0 (
      .clk             (clk),
      .mr_main_reset   (mr_main_reset),
      .indicate        (indicate),
      .pudi            (pudi),
      .code_sync_status(code_sync_status),
      .rx_even         (rx_even),
      .sudi            (sudi)
  );


endmodule
