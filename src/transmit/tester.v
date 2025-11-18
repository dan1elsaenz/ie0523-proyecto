/*
* =============================================================================
*
* - File        : transmit/tester.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Probador para el módulo de transmisión.
*
* =============================================================================
*/


/*
 * Archivos incluidos
 */
`include "../constants/code_group_constants.v"

module tester #(
    parameter integer CG_WIDTH    = 10,
    parameter integer OCTET_WIDTH = 8,
    parameter integer CLK_PERIOD = 10
) (
    // OUTPUT
    output reg                   gtx_clk,
    output reg                   mr_main_reset,
    output reg                   tx_en,
    output reg [OCTET_WIDTH-1:0] txd
);


  /*
  * Generación de la señal de reloj
  */
  always begin
    #(CLK_PERIOD / 2) gtx_clk = ~gtx_clk;
  end


  /*
  * Tasks
  */
  // Espera que pasen n ciclos de reloj
  task ciclos(input integer n);
    integer k;
    begin
      for (k = 0; k < n; k = k + 1) @(posedge gtx_clk);
    end
  endtask

  // Reinicio activo en bajo del sistema
  task reiniciar;
    begin
      ciclos(1);
      mr_main_reset = 1'b1;
      ciclos(1);
      mr_main_reset = 1'b0;
      ciclos(1);
    end
  endtask


  /*
  * Pruebas realizadas
  */
  initial begin
    // Valores iniciales
    gtx_clk       = 1'b0;
    mr_main_reset = 1'b0;

    // Valores iniciales de entradas
    tx_en         = 0;
    txd           = '0;
    reiniciar();

    /*
    * Prueba 0: IDLEs
    */
    ciclos(7);

    /*
    * Prueba 1: Carrier extend y IDLE disparity OK
    */
    // Habilitar transmisión
    tx_en = 1;
    @(posedge gtx_clk) txd = `D11_3_8B;
    @(posedge gtx_clk) txd = `D23_1_8B;
    @(posedge gtx_clk) txd = `D7_4_8B;
    @(posedge gtx_clk) txd = `D12_5_8B;

    @(posedge gtx_clk) tx_en = 0;
    txd = 0;

    // Ciclos intermedios
    ciclos(7);

    /*
    * Prueba 2: Sin carrier extend y IDLE disparity WRONG
    */
    // Habilitar transmisión
    tx_en = 1;
    @(posedge gtx_clk) txd = `D11_3_8B;
    @(posedge gtx_clk) txd = `D23_1_8B;
    @(posedge gtx_clk) txd = `D7_4_8B;
    @(posedge gtx_clk) txd = `D12_5_8B;
    @(posedge gtx_clk) txd = `D8_6_8B;

    @(posedge gtx_clk) tx_en = 0;
    txd = 0;

    // Ciclos intermedios
    ciclos(7);

    /*
    * Prueba 3: Sin carrier extend y IDLE disparity OK
    */
    // Habilitar transmisión
    tx_en = 1;
    @(posedge gtx_clk) txd = `D11_3_8B;
    @(posedge gtx_clk) txd = `D23_1_8B;
    @(posedge gtx_clk) txd = `D1_0_8B;
    @(posedge gtx_clk) txd = `D31_1_8B;

    @(posedge gtx_clk) tx_en = 0;
    txd = 0;

    // Ciclos intermedios
    ciclos(7);

    $finish;
  end

endmodule
