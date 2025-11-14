/*
* =============================================================================
*
* - File        : code_group_constants.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Constantes definidas para la prueba del PCS. Incluye code-groups
*   especiales y datos válidos, así como las combinaciones requeridas para los
*   ordered-sets definidos.
*
* =============================================================================
*/

`ifndef CODE_GROUP_CONSTANTS
`define CODE_GROUP_CONSTANTS

/*
 * Caracteres especiales K
 * Se incluyen únicamente los requeridos para la solución
 */

// /I/ IDLE
`define K28_5_8B 8'hBC    // 1011_1100
`define K28_5_10B_RD_P 10'b110000_0101
`define K28_5_10B_RD_N 10'b001111_1010

// /R/ Carrier_Extend
`define K23_7_8B 8'hF7    // 1111_0111
`define K23_7_10B_RD_P 10'b000101_0111
`define K23_7_10B_RD_N 10'b111010_1000

// /S/ Start_of_Packet
`define K27_7_8B 8'hFB    // 1111_1011
`define K27_7_10B_RD_P 10'b001001_0111
`define K27_7_10B_RD_N 10'b110110_1000

// /T/ End_of_Packet
`define K29_7_8B 8'hFD    // 1111_1101
`define K29_7_10B_RD_P 10'b010001_0111
`define K29_7_10B_RD_N 10'b101110_1000


/*
 * Datos válidos (D)
 * Se seleccionaron 20 code-groups aleatoriamente
 */

// Para IDLE: D5.6
`define D5_6_8B 8'hC5    // 1100_0101
`define D5_6_10B_RD_P 10'b101001_0110
`define D5_6_10B_RD_N 10'b101001_0110

// Para IDLE: D16.2
`define D16_2_8B 8'h50   // 0101_0000
`define D16_2_10B_RD_P 10'b1001000101
`define D16_2_10B_RD_N 10'b0110110101

`define D0_0_8B 8'h00    // 0000_0000
`define D0_0_10B_RD_P 10'b011000_1011
`define D0_0_10B_RD_N 10'b100111_0100

`define D1_0_8B 8'h01    // 0000_0001
`define D1_0_10B_RD_P 10'b100010_1011
`define D1_0_10B_RD_N 10'b011101_0100

`define D2_0_8B 8'h02    // 0000_0010
`define D2_0_10B_RD_P 10'b010010_1011
`define D2_0_10B_RD_N 10'b101101_0100

`define D2_2_8B 8'h42    // 0100_0010
`define D2_2_10B_RD_P 10'b010010_0101
`define D2_2_10B_RD_N 10'b101101_0101

`define D21_5_8B 8'hB5    // 1011_0101
`define D21_5_10B_RD_P 10'b101010_1010
`define D21_5_10B_RD_N 10'b101010_1010

`define D11_3_8B 8'h6B    // 0110_1011
`define D11_3_10B_RD_P 10'b110100_0011
`define D11_3_10B_RD_N 10'b110100_1100

`define D23_1_8B 8'h37    // 0011_0111
`define D23_1_10B_RD_P 10'b000101_1001
`define D23_1_10B_RD_N 10'b111010_1001

`define D7_4_8B 8'h87    // 1000_0111
`define D7_4_10B_RD_P 10'b000111_0010
`define D7_4_10B_RD_N 10'b111000_1101

`define D12_5_8B 8'hAC    // 1010_1100
`define D12_5_10B_RD_P 10'b001101_1010
`define D12_5_10B_RD_N 10'b001101_1010

`define D28_5_8B 8'hBC    // 1011_1100
`define D28_5_10B_RD_P 10'b001110_1010
`define D28_5_10B_RD_N 10'b001110_1010

`define D3_6_8B 8'hC3    // 1100_0011
`define D3_6_10B_RD_P 10'b110001_0110
`define D3_6_10B_RD_N 10'b110001_0110

`define D8_6_8B 8'hC8    // 1100_1000
`define D8_6_10B_RD_P 10'b000110_0110
`define D8_6_10B_RD_N 10'b111001_0110

`define D19_2_8B 8'h53    // 0101_0011
`define D19_2_10B_RD_P 10'b110010_0101
`define D19_2_10B_RD_N 10'b110010_0101

`define D24_3_8B 8'h78    // 0111_1000
`define D24_3_10B_RD_P 10'b001100_1100
`define D24_3_10B_RD_N 10'b110011_0011

`define D31_1_8B 8'h3F    // 0011_1111
`define D31_1_10B_RD_P 10'b010100_1001
`define D31_1_10B_RD_N 10'b101011_1001

`define D10_1_8B 8'h2A    // 0010_1010
`define D10_1_10B_RD_P 10'b010101_1001
`define D10_1_10B_RD_N 10'b010101_1001

`define D29_3_8B 8'h7D    // 0111_1101
`define D29_3_10B_RD_P 10'b010001_1100
`define D29_3_10B_RD_N 10'b101110_0011

`define D4_6_8B 8'hC4    // 1100_0100
`define D4_6_10B_RD_P 10'b001010_0110
`define D4_6_10B_RD_N 10'b110101_0110

`endif  // CODE_GROUP_CONSTANTS
