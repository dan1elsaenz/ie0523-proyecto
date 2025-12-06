/*
* ==================================================================================
*
* - File        : testbench.v
* - Autor       : Brandon Jiménez Campos (C33972)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Testbench para el bloque de receive

* ==================================================================================
*/

/*
* Incluir módulos
*/
`include "receive.v"
`include "tester.v"


module testbench;

  // Iniciar registro de variables para GTKWave
  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(0, testbench);
  end

  /*
  * Cables de conexión
  */
  wire        rx_clk;
  wire        mr_main_reset;
  wire        rx_dv;
  wire        rx_er;
  wire [ 7:0] rxd;
  wire [10:0] sudi;
  wire        sync_status;

  /*
  * Instanciación de probador
  */
  tester test (
      .rx_clk       (rx_clk),
      .mr_main_reset(mr_main_reset),
      .sudi         (sudi[10:0]),
      .sync_status  (sync_status)
  );


  /*
  * Instanciación de receive
  */
  receive rec (
      .rx_clk       (rx_clk),
      .mr_main_reset(mr_main_reset),
      .sudi         (sudi[10:0]),
      .sync_status  (sync_status),
      .rxd          (rxd[7:0]),
      .rx_dv        (rx_dv),
      .rx_er        (rx_er)
  );

endmodule
