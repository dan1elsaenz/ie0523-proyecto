/*
* ==================================================================================
*
* - File        : decode.v
* - Autor       : Brandon Jiménez Campos (C33972)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Módulo donde se decodifica los datos enviados a través del SUDI, es decir
*   se pasa de 10B a 8B, para que así el receptor envíe a la capa GMII los
*   datos de manera correcta, además de verificar según el running disparity
*
*   Solamente se decodificaran los code-groups definidos en code_group_constants.v
* ==================================================================================
*/

/*
* Incluir módulos
*/
`include "../constants/code_group_constants.v"


module decode #(
    parameter integer CG_WIDTH = 10,
    parameter integer OCTET_WIDTH = 8
) (
    input  wire [   CG_WIDTH-1:0] rx_code_group,         // entrada de 10 bits
    input  wire                   rx_running_disparity,  // si es 1 es positivo, si es 0 es negativo
    output reg  [OCTET_WIDTH-1:0] rx_octet,              // salida de 8 bits
    output reg                    rx_dv_decoded                  // Validez del rx
);

  /*
  * Lógica combinacional
  */
  always @(*) begin
    // Predeterminado
    rx_dv_decoded = 1;

    case ({
      rx_running_disparity, rx_code_group
    })

      /*
      * Caracteres especiales K
      */
      // K28.5 (IDLE)
      {1'b1, `K28_5_10B_RD_P} : rx_octet = `K28_5_8B;
      {1'b0, `K28_5_10B_RD_N} : rx_octet = `K28_5_8B;

      // K23.7 (Carrier_Extend)
      {1'b1, `K23_7_10B_RD_P} : rx_octet = `K23_7_8B;
      {1'b0, `K23_7_10B_RD_N} : rx_octet = `K23_7_8B;

      // K27.7 (Start_of_Packet)
      {1'b1, `K27_7_10B_RD_P} : rx_octet = `K27_7_8B;
      {1'b0, `K27_7_10B_RD_N} : rx_octet = `K27_7_8B;

      // K29.7 (End_of_Packet)
      {1'b1, `K29_7_10B_RD_P} : rx_octet = `K29_7_8B;
      {1'b0, `K29_7_10B_RD_N} : rx_octet = `K29_7_8B;

      /*
      * Datos válidos D
      */
      // D5.6 (IDLE)
      {1'b1, `D5_6_10B_RD_P} : rx_octet = `D5_6_8B;
      {1'b0, `D5_6_10B_RD_N} : rx_octet = `D5_6_8B;

      // D16.2 (IDLE)
      {1'b1, `D16_2_10B_RD_P} : rx_octet = `D16_2_8B;
      {1'b0, `D16_2_10B_RD_N} : rx_octet = `D16_2_8B;

      // D0.0
      {1'b1, `D0_0_10B_RD_P} : rx_octet = `D0_0_8B;
      {1'b0, `D0_0_10B_RD_N} : rx_octet = `D0_0_8B;

      // D1.0
      {1'b1, `D1_0_10B_RD_P} : rx_octet = `D1_0_8B;
      {1'b0, `D1_0_10B_RD_N} : rx_octet = `D1_0_8B;

      // D2.0
      {1'b1, `D2_0_10B_RD_P} : rx_octet = `D2_0_8B;
      {1'b0, `D2_0_10B_RD_N} : rx_octet = `D2_0_8B;

      // D2.2
      {1'b1, `D2_2_10B_RD_P} : rx_octet = `D2_2_8B;
      {1'b0, `D2_2_10B_RD_N} : rx_octet = `D2_2_8B;

      // D21.5
      {1'b1, `D21_5_10B_RD_P} : rx_octet = `D21_5_8B;
      {1'b0, `D21_5_10B_RD_N} : rx_octet = `D21_5_8B;

      // D11.3
      {1'b1, `D11_3_10B_RD_P} : rx_octet = `D11_3_8B;
      {1'b0, `D11_3_10B_RD_N} : rx_octet = `D11_3_8B;

      // D23.1
      {1'b1, `D23_1_10B_RD_P} : rx_octet = `D23_1_8B;
      {1'b0, `D23_1_10B_RD_N} : rx_octet = `D23_1_8B;

      // D7.4
      {1'b1, `D7_4_10B_RD_P} : rx_octet = `D7_4_8B;
      {1'b0, `D7_4_10B_RD_N} : rx_octet = `D7_4_8B;

      // D12.5
      {1'b1, `D12_5_10B_RD_P} : rx_octet = `D12_5_8B;
      {1'b0, `D12_5_10B_RD_N} : rx_octet = `D12_5_8B;

      // D28.5
      {1'b1, `D28_5_10B_RD_P} : rx_octet = `D28_5_8B;
      {1'b0, `D28_5_10B_RD_N} : rx_octet = `D28_5_8B;

      // D3.6
      {1'b1, `D3_6_10B_RD_P} : rx_octet = `D3_6_8B;
      {1'b0, `D3_6_10B_RD_N} : rx_octet = `D3_6_8B;

      // D8.6
      {1'b1, `D8_6_10B_RD_P} : rx_octet = `D8_6_8B;
      {1'b0, `D8_6_10B_RD_N} : rx_octet = `D8_6_8B;

      // D19.2
      {1'b1, `D19_2_10B_RD_P} : rx_octet = `D19_2_8B;
      {1'b0, `D19_2_10B_RD_N} : rx_octet = `D19_2_8B;

      // D24.3
      {1'b1, `D24_3_10B_RD_P} : rx_octet = `D24_3_8B;
      {1'b0, `D24_3_10B_RD_N} : rx_octet = `D24_3_8B;

      // D31.1
      {1'b1, `D31_1_10B_RD_P} : rx_octet = `D31_1_8B;
      {1'b0, `D31_1_10B_RD_N} : rx_octet = `D31_1_8B;

      // D10.1
      {1'b1, `D10_1_10B_RD_P} : rx_octet = `D10_1_8B;
      {1'b0, `D10_1_10B_RD_N} : rx_octet = `D10_1_8B;

      // D29.3
      {1'b1, `D29_3_10B_RD_P} : rx_octet = `D29_3_8B;
      {1'b0, `D29_3_10B_RD_N} : rx_octet = `D29_3_8B;

      // D4.6
      {1'b1, `D4_6_10B_RD_P} : rx_octet = `D4_6_8B;
      {1'b0, `D4_6_10B_RD_N} : rx_octet = `D4_6_8B;

      default: begin
        rx_octet = 8'b0000_0000;
        rx_dv_decoded    = 0;
      end

    endcase

  end

endmodule
