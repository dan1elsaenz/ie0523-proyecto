/*
* =============================================================================
*
* - File        : pcs.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025

* - Descripción :
*
* =============================================================================
*/

`include "../transmit/transmit_wrapper.v"
`include "../synchronization/synchronization.v"
`include "../receive/receive.v"

module pcs #(
    parameter integer CG_WIDTH    = 10,
    parameter integer OCTET_WIDTH = 8
) (
    // INPUT
    input                        clk,            // Señal de reloj
    input                        mr_main_reset,  // Reinicio (activo en alto)
    input                        tx_en,          // Habilitación de transmit
    input      [OCTET_WIDTH-1:0] txd,            // 8 bits a transmitir
    // OUTPUT
    output reg [OCTET_WIDTH-1:0] rxd,            // 8 bits recibidos
    output reg                   rx_dv,          // Indicador de dato válido
    output reg                   rx_er           // Indicador de error
);

  // Iniciar registro de variables para GTKWave
  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(-1, testbench);
  end

  /*
  * Cables de conexión TRANSMIT - SYNCHRONIZATION
  */
  wire                pudr;
  wire [CG_WIDTH-1:0] tx_code_group;

  /*
  * Cables de conexión SYNCHRONIZATION - RECEIVE
  */
  wire                code_sync_status;
  wire [  CG_WIDTH:0] sudi;



  /*
  * Instanciación de TRANSMIT
  */
  transmit_wrapper #(
      .CG_WIDTH   (CG_WIDTH),
      .OCTET_WIDTH(OCTET_WIDTH)
  ) transmit (
      .gtx_clk      (clk),
      .mr_main_reset(mr_main_reset),
      .tx_en        (tx_en),
      .txd          (txd),
      .tx_code_group(tx_code_group),
      .pudr         (pudr)
  );


  /*
  * Instanciación de SYNCHRONIZATION
  */
  synchronization #(
      .CG_WIDTH(CG_WIDTH)
  ) sync (
      .mr_main_reset   (mr_main_reset),
      .clk             (clk),
      .indicate        (pudr),
      .pudi            (tx_code_group),
      .code_sync_status(code_sync_status),
      .rx_even         (rx_even),
      .sudi            (sudi)
  );


  /*
  * Instanciación de RECEIVE
  */
  receive #() receive (
      .rx_clk       (clk),
      .mr_main_reset(mr_main_reset),
      .sudi         (sudi),
      .sync_status  (code_sync_status),
      .rxd          (rxd),
      .rx_dv        (rx_dv),
      .rx_er        (rx_er)
  );


endmodule
