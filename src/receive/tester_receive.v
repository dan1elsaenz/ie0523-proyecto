/*
* ==================================================================================
*
* - File        : tester_receive.v
* - Autor       : Brandon Jiménez Campos (C33972)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción : 
*   Tester para el bloque de recepción
* ==================================================================================
*/

`include "../constants/code_group_constants.v"

module tester_receive (
    output reg rx_clk,
    output reg mr_main_reset,
    output reg [10:0] sudi,
    output reg sync_status
);

    initial begin
        rx_clk = 0;
        mr_main_reset = 0;
        sudi = 11'b0;
        sync_status = 0;

        #5 mr_main_reset = 1;
        #10 mr_main_reset = 0;
        #10 sync_status = 1;

        //Prueba en donde envía datos
        
        #10 sudi = {`K28_5_10B_RD_N, 1'b1};  // K28.5 RD- (Idle)
        #10 sudi = {`K28_5_10B_RD_P, 1'b1};  // K28.5 RD+ (Idle)
        #10 sudi = {`K27_7_10B_RD_N,1'b1};  // K27.7 RD+ START

        #20 sudi = {`D11_3_10B_RD_N, 1'b0};  // D11.3 RD- Data válido
        #10 sudi = {`D23_1_10B_RD_N, 1'b0};  // D23.1 RD+ Data válido
        #10 sudi = {`D7_4_10B_RD_P, 1'b0};   // D7.4 RD- Data válido
        #10 sudi = {`D8_6_10B_RD_N, 1'b0};  // D12.5 RD+  Data válido

        #10 sudi = {`K29_7_10B_RD_P, 1'b0}; // T
        #10 sudi = {`K23_7_10B_RD_P, 1'b1}; // R
        #10 sudi = {`K28_5_10B_RD_N, 1'b0}; // I

        //Prueba en donde no se está sincronizado, entonces no debería de enviar datos por rxd

        #10 sync_status = 0;
        
        #10 sudi = {`K28_5_10B_RD_N, 1'b1};  // K28.5 RD- 
        #10 sudi = {`K28_5_10B_RD_P, 1'b1};  // K28.5 RD+
        #10 sudi = {`K27_7_10B_RD_N,1'b1};

        #20 sudi = {`D11_3_10B_RD_N, 1'b0};  // D11.3 RD- 
        #10 sudi = {`D23_1_10B_RD_N, 1'b0};  // D23.1 RD+ 
        #10 sudi = {`D7_4_10B_RD_P, 1'b0};   // D7.4 RD- 
        #10 sudi = {`D8_6_10B_RD_N, 1'b0};  // D12.5 RD+ 

        #10 sudi = {`K29_7_10B_RD_P, 1'b0}; // T
        #10 sudi = {`K23_7_10B_RD_P, 1'b1}; // R
        #10 sudi = {`K28_5_10B_RD_P, 1'b0}; // I

        #10 sync_status = 1;
        #10 sudi = {`K28_5_10B_RD_N, 1'b1};  // K28.5 RD- (Idle)
        #10 sudi = {`K28_5_10B_RD_P, 1'b1};  // K28.5 RD+ (Idle)
        #10 sudi = {`K27_7_10B_RD_N,1'b1};  // K27.7 RD+ START

        #20 sudi = {`D11_3_10B_RD_N, 1'b0};  // D11.3 RD- Data válido
        #10 sudi = {`D23_1_10B_RD_N, 1'b0};  // D23.1 RD+ Data válido
        #10 sudi = {`D7_4_10B_RD_P, 1'b0};   // D7.4 RD- Data válido
        #10 sudi = {`D8_6_10B_RD_N, 1'b0};  // D12.5 RD+  Data válido

        #10 sudi = {`K29_7_10B_RD_P, 1'b0}; // T
        #10 sudi = {`K23_7_10B_RD_P, 1'b1}; // R
        #10 sudi = {`K23_7_10B_RD_P, 1'b0}; // R

        #40 $finish;
    end

    always begin
        #5 rx_clk = !rx_clk;
    end

endmodule