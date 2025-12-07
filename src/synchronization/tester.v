/*
* =============================================================================
*
* - File        : tester.v
* - Autor       : Rodrigo E. Sanchez Araya    (C37259)
*                 Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Probador para el sincronizador. Se realizaron pruebas para verificar el
*   inicio de la sincronización y la pérdida de sincronía bajo diferentes
*   condiciones.
*
* =============================================================================
*/

/*
* Incluir módulos
*/
`include "../constants/code_group_constants.v"


module tester #(
    parameter integer CG_WIDTH   = 10,
    parameter integer CLK_PERIOD = 10
) (
    // INPUT
    input  wire                code_sync_status,
    input  wire                rx_even,
    input  wire [  CG_WIDTH:0] sudi,
    // OUTPUT
    output reg                 mr_main_reset,
    output reg                 clk,
    output reg                 indicate,          // Se conecta a PUDR
    output reg  [CG_WIDTH-1:0] pudi               // Se conecta al code_group
);

  /*
  * Generación de la señal de reloj
  */
  always begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end

  /*
  * Pruebas realizadas
  */
  initial begin
    // Valores iniciales
    pudi = '0;
    clk = 0;
    indicate = 0;
    #5;

    /*
    * Reiniciar
    */
    mr_main_reset = 1;
    @(posedge clk) mr_main_reset = 0;
    @(posedge clk);

    /*
    * Prueba 1: Sincronizar
    */
    // COMMA
    indicate = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    // COMMA
    indicate = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    // COMMA
    indicate = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    // COMMA
    indicate = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);


    /*
    * Prueba 2: Un dato inválido
    * Ya está sincronizado
    * Ahora se manda uno inválido y se vuelve a sincronizar
    */
    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    // Vuelve a sincronizarse
    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    /*
    * Prueba 3: Dos inválidos consecutivos
    * Dos inválidos y vuelve a sincronizarse
    */
    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    // Vuelve a sincronizarse
    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    /*
    * Prueba 4: Tres inválidos consecutivos
    * Tres inválidos y vuelve a sincronizarse
    */
    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    // Vuelve a sincronizarse
    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    /*
    * Prueba 5: Inválidos intercalados durante resincronización
    */
    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    // Vuelve a sincronizarse
    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    indicate = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    indicate = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);


    /*
    * Prueba 6: Pérdida de sincronización completa
    * 4 inválidos
    */
    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    indicate = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    #20 $finish;
  end

endmodule
