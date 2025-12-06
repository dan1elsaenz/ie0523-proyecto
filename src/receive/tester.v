/*
* ==================================================================================
*
* - File        : tester.v
* - Autor       : Brandon Jiménez Campos (C33972)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Tester para el bloque de recepción
* ==================================================================================
*/

/*
* Incluir módulos
*/
`include "../constants/code_group_constants.v"


module tester (
    output reg        rx_clk,
    output reg        mr_main_reset,
    output reg [10:0] sudi,
    output reg        sync_status
);

  /*
  * Generación de reloj
  */
  always begin
    #5 rx_clk = !rx_clk;
  end

  // Inicio de pruebas
  initial begin
    rx_clk = 0;
    mr_main_reset = 1;
    sudi = 11'b0;
    sync_status = 0;

    @(posedge rx_clk);
    mr_main_reset = 0;

    @(posedge rx_clk);
    sync_status = 1;

    /*
    * PRUEBA 1
    * Está sincronizado, por lo que se envían datos por rxd
    */

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_N, 1'b1};  // K28.5 RD- (Idle)

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_P, 1'b1};  // K28.5 RD+ (Idle)

    @(posedge rx_clk);
    sudi = {`K27_7_10B_RD_N, 1'b1};  // K27.7 RD+ START

    @(posedge rx_clk);

    @(posedge rx_clk);
    sudi = {`D11_3_10B_RD_N, 1'b0};  // D11.3 RD- Data válido

    @(posedge rx_clk);
    sudi = {`D23_1_10B_RD_N, 1'b0};  // D23.1 RD+ Data válido

    @(posedge rx_clk);
    sudi = {`D7_4_10B_RD_P, 1'b0};  // D7.4 RD- Data válido

    @(posedge rx_clk);
    sudi = {`D8_6_10B_RD_N, 1'b0};  // D12.5 RD+  Data válido

    @(posedge rx_clk);
    sudi = {`K29_7_10B_RD_P, 1'b0};  // T

    @(posedge rx_clk);
    sudi = {`K23_7_10B_RD_P, 1'b1};  // R

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_N, 1'b0};  // I

    /*
    * PRUEBA 2
    * No está sincronizado, entonces no debe enviar datos por rxd
    */

    @(posedge rx_clk);
    sync_status = 0;

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_N, 1'b1};  // K28.5 RD-

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_P, 1'b1};  // K28.5 RD+

    @(posedge rx_clk);
    sudi = {`K27_7_10B_RD_N, 1'b1};
    @(posedge rx_clk);

    @(posedge rx_clk);
    sudi = {`D11_3_10B_RD_N, 1'b0};  // D11.3 RD-

    @(posedge rx_clk);
    sudi = {`D23_1_10B_RD_N, 1'b0};  // D23.1 RD+

    @(posedge rx_clk);
    sudi = {`D7_4_10B_RD_P, 1'b0};  // D7.4 RD-

    @(posedge rx_clk);
    sudi = {`D8_6_10B_RD_N, 1'b0};  // D12.5 RD+

    @(posedge rx_clk);
    sudi = {`K29_7_10B_RD_P, 1'b0};  // T

    @(posedge rx_clk);
    sudi = {`K23_7_10B_RD_P, 1'b1};  // R

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_P, 1'b0};  // I

    /*
    * PRUEBA 3
    * Se realiza con una terminación /T/R/R
    */

    @(posedge rx_clk);
    sync_status = 1;

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_N, 1'b1};  // K28.5 RD- (Idle)

    @(posedge rx_clk);
    sudi = {`K28_5_10B_RD_P, 1'b1};  // K28.5 RD+ (Idle)

    @(posedge rx_clk);
    sudi = {`K27_7_10B_RD_N, 1'b1};  // K27.7 RD+ START

    @(posedge rx_clk);

    @(posedge rx_clk);
    sudi = {`D11_3_10B_RD_N, 1'b0};  // D11.3 RD- Data válido

    @(posedge rx_clk);
    sudi = {`D23_1_10B_RD_N, 1'b0};  // D23.1 RD+ Data válido

    @(posedge rx_clk);
    sudi = {`D7_4_10B_RD_P, 1'b0};  // D7.4 RD- Data válido

    @(posedge rx_clk);
    sudi = {`D8_6_10B_RD_N, 1'b0};  // D12.5 RD+  Data válido

    @(posedge rx_clk);
    sudi = {`K29_7_10B_RD_P, 1'b0};  // T

    @(posedge rx_clk);
    sudi = {`K23_7_10B_RD_P, 1'b1};  // R

    @(posedge rx_clk);
    sudi = {`K23_7_10B_RD_P, 1'b0};  // R

    #40 $finish;
  end

endmodule
