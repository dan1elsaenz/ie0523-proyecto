/*
* =============================================================================
*
* - File        : tester.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Probador para la subcapa PCS completa.
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
    parameter integer CLK_PERIOD  = 10
) (
    // INPUT
    input [OCTET_WIDTH-1:0] rxd,    // 8 bits recibidos
    input                   rx_dv,  // Indicador de dato válido
    input                   rx_er,  // Indicador de error

    // OUTPUT
    output reg                   clk,            // Señal de reloj
    output reg                   mr_main_reset,  // Reinicio (activo en alto)
    output reg                   tx_en,          // Habilitación de transmit
    output reg [OCTET_WIDTH-1:0] txd             // 8 bits a transmitir
);


  /*
  * Generación de la señal de reloj
  */
  always begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end


  /*
  * Tasks
  */
  // Espera que pasen n ciclos de reloj
  task ciclos(input integer n);
    integer k;
    begin
      for (k = 0; k < n; k = k + 1) @(posedge clk);
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
    clk           = 1'b0;
    mr_main_reset = 1'b0;

    // Valores iniciales de entradas
    tx_en         = 0;
    txd           = '0;
    reiniciar();

    /*
    * Prueba 0: IDLEs (sincronización)
    */
    ciclos(9);

    /*
    * Prueba 1: Carrier extend y IDLE disparity OK
    */
    // Habilitar transmisión
    tx_en = 1;
    @(posedge clk) txd = `D11_3_8B;
    @(posedge clk) txd = `D23_1_8B;
    @(posedge clk) txd = `D7_4_8B;
    @(posedge clk) txd = `D12_5_8B;

    @(posedge clk) tx_en = 0;
    txd = 0;

    // Ciclos intermedios
    ciclos(7);

    /*
    * Prueba 2: Sin carrier extend y IDLE disparity WRONG
    */
    // Habilitar transmisión
    tx_en = 1;
    @(posedge clk) txd = `D11_3_8B;
    @(posedge clk) txd = `D23_1_8B;
    @(posedge clk) txd = `D7_4_8B;
    @(posedge clk) txd = `D12_5_8B;
    @(posedge clk) txd = `D8_6_8B;

    @(posedge clk) tx_en = 0;
    txd = 0;

    // Ciclos intermedios
    ciclos(8);

    /*
    * Prueba 3: Sin carrier extend y IDLE disparity OK
    */
    // Habilitar transmisión
    tx_en = 1;
    @(posedge clk) txd = `D11_3_8B;
    @(posedge clk) txd = `D23_1_8B;
    @(posedge clk) txd = `D31_1_8B;

    @(posedge clk) tx_en = 0;
    txd = 0;

    // Ciclos intermedios
    ciclos(8);


    /*
    * Prueba 4: Envío del subconjunto de todos los ordered sets definido
    */
    tx_en = 1;

    @(posedge clk) txd = `D5_6_8B;
    @(posedge clk) txd = `D16_2_8B;
    @(posedge clk) txd = `D0_0_8B;
    @(posedge clk) txd = `D1_0_8B;
    @(posedge clk) txd = `D2_0_8B;
    @(posedge clk) txd = `D2_2_8B;
    @(posedge clk) txd = `D21_5_8B;
    @(posedge clk) txd = `D11_3_8B;
    @(posedge clk) txd = `D23_1_8B;
    @(posedge clk) txd = `D7_4_8B;
    @(posedge clk) txd = `D12_5_8B;
    @(posedge clk) txd = `D28_5_8B;
    @(posedge clk) txd = `D3_6_8B;
    @(posedge clk) txd = `D8_6_8B;
    @(posedge clk) txd = `D19_2_8B;
    @(posedge clk) txd = `D24_3_8B;
    @(posedge clk) txd = `D31_1_8B;
    @(posedge clk) txd = `D10_1_8B;
    @(posedge clk) txd = `D29_3_8B;
    @(posedge clk) txd = `D4_6_8B;

    @(posedge clk) tx_en = 0;
    txd = 0;

    // Ciclos intermedios
    ciclos(7);


    /*
    * Prueba 5: Pérdida de sincronización
    */
    tx_en = 1;
    @(posedge clk) txd = 10000001;
    @(posedge clk) txd = 10000001;
    @(posedge clk) txd = 10000001;
    @(posedge clk) txd = 10000001;
    @(posedge clk) txd = 10000001;
    @(posedge clk) tx_en = 0;
    txd = 0;

    $finish;
  end

endmodule
