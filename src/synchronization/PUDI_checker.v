/*
* =============================================================================
*
* - File        : PUDI_checker.v
* - Autor       : Rodrigo E. Sanchez Araya
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 4-12-2025
*
* - Descripción : 
*
* =============================================================================
*/

`include "../constants/code_group_constants.v"

module PUDI_checker #(
    parameter integer param = -1 
)(

    // Recibe como parámetro el PUDI
    input wire [9:0] PUDI,

    // Decide si es válido o inválido 
    output reg PUDI_INVALID, comma_PUDI, D_PUDI
    ); 
    
    always @(*) begin
        // Valores por defecto 
        PUDI_INVALID = 1'b0;
        comma_PUDI   = 1'b0; 
        D_PUDI       = 1'b0; 

        case (PUDI)
            
            // COMMAs
            `K28_5_10B_RD_P : begin
                PUDI_INVALID = 1'b0;
                comma_PUDI   = 1'b1;    
            end
            `K28_5_10B_RD_N : begin 
                PUDI_INVALID = 1'b0;
                comma_PUDI   = 1'b1; 
            end 

            // /R/ Carrier_Extend
            `K23_7_10B_RD_P : PUDI_INVALID = 1'b0; 
            `K23_7_10B_RD_N : PUDI_INVALID = 1'b0;

            // /S/ Start_of_Packet
            `K27_7_10B_RD_P : PUDI_INVALID = 1'b0;
            `K27_7_10B_RD_N : PUDI_INVALID = 1'b0;

            // /T/ End_of_Packet
            `K29_7_10B_RD_P :  PUDI_INVALID = 1'b0;
            `K29_7_10B_RD_N : PUDI_INVALID = 1'b0;

            // Para IDLE: D5.6
            `D5_6_10B_RD_P :  begin
                PUDI_INVALID = 1'b0;
                D_PUDI       = 1'b1;
            end
            `D5_6_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end
            // Para IDLE: D16.2
            `D16_2_10B_RD_P : begin 
                PUDI_INVALID = 1'b0;
                D_PUDI       = 1'b1;
            end
            `D16_2_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D0_0_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end
            `D0_0_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D1_0_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end
            `D1_0_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1; 
            end

            `D2_0_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end
            `D2_0_10B_RD_N : begin 
                    PUDI_INVALID = 1'b0; 
                    D_PUDI       = 1'b1; 
            end

            `D2_2_10B_RD_P : begin 
                PUDI_INVALID = 1'b0;
                D_PUDI       = 1'b1; 
            end
            `D2_2_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D21_5_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end
            `D21_5_10B_RD_N: begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D11_3_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D11_3_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D23_1_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D23_1_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end
            `D7_4_10B_RD_P : begin 
            PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D7_4_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D12_5_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end
  
                
            `D12_5_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end


            `D28_5_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end


            `D28_5_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end


            `D3_6_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D3_6_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end



            `D8_6_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D8_6_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end


            `D19_2_10B_RD_P : begin
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end




            `D19_2_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D24_3_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end



            `D24_3_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

 

            `D31_1_10B_RD_P : begin  
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end




            `D31_1_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end



            `D10_1_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D10_1_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end



            `D29_3_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end

            `D29_3_10B_RD_N : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end


            `D4_6_10B_RD_P : begin 
                PUDI_INVALID = 1'b0; 
                D_PUDI      = 1'b1; 
    
            end 
            
            `D4_6_10B_RD_N : begin
                PUDI_INVALID = 1'b0; 
                D_PUDI       = 1'b1;
            end



            default : PUDI_INVALID = 1'b1; 
        endcase
    end
 endmodule
