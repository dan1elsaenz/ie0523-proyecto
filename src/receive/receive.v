/*
* ==================================================================================
*
* - File        : receive.v
* - Autor       : Brandon Jiménez Campos (C33972)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción : 
*   Módulo de recepción que decodifica code-groups 8B/10B y controla el flujo
*   de datos mediante una máquina de estados.
*
* ==================================================================================
*/

`include "../constants/code_group_constants.v"
`include "decode.v"
`include "../running_disparity/running_disparity.v"

module receive (
    input rx_clk,
    input mr_main_reset,
    input [10:0] sudi,
    input sync_status,

    output reg [7:0] rxd,
    output reg rx_dv,
    output reg rx_er
);

    wire [9:0] rx_code_group;           // Almacena los 10 bits del code-group
    wire rx_even;                       // Bit de paridad
    reg [29:0] check_end;               // Almacena los últimos 3 code-groups
    wire [7:0] decoded_octet;           // Salida del decodificador

    assign rx_code_group = sudi[10:1];  // Asignar los 10 bits de entrada
    assign rx_even = sudi[0];           // Asignar el bit de paridad
    reg rx_running_disparity;
    wire next_rx_running_disparity;

    // Instancia del módulo de running_disparity
    running_disparity #(
        .CG_WIDTH(10)
    ) rd (
        .rd_in     (rx_running_disparity),
        .code_group(rx_code_group),
        .rd_out    (next_rx_running_disparity)
    );

    // Instancia del módulo decode
    decode #(
        .CG_WIDTH(10),
        .OCTET_WIDTH(8)
    ) decode_inst (
        .rx_code_group(rx_code_group),
        .rx_running_disparity(rx_running_disparity),
        .rx_octet(decoded_octet)
    );

    // Estados de la máquina
    localparam LINK_FAILED   = 8'b00000001;
    localparam WAIT_FOR_K    = 8'b00000010;
    localparam RX_K          = 8'b00000100;
    localparam IDLE_D        = 8'b00001000;
    localparam START         = 8'b00010000;
    localparam RECEIVE       = 8'b00100000;
    //localparam RD_DATA       = 9'b001000000;
    localparam TRR_EXTEND    = 8'b01000000;
    localparam TRI_RRI       = 8'b10000000;

    reg [7:0] state, next_state;

    // Lógica secuencial
    always @(posedge rx_clk) begin
        if (mr_main_reset) begin
            state <= LINK_FAILED;
            rxd <= 0;
            rx_dv <= 0;
            rx_er <= 0;
            check_end <= 30'b0;
            rx_running_disparity <= 0; // running disparity negativo inicialmente
        end else begin
            state <= next_state;
            rx_running_disparity <= next_rx_running_disparity; // actualizar el running disparity
            // Actualizar el registro de verificación de fin de paquete (desplazamiento)
            check_end <= {check_end[19:0], rx_code_group};
        end
    end

    // Lógica combinacional
    always @(*) begin
        next_state = state;
        rx_dv = 1'b0;
        rx_er = 1'b0;
        rxd = 8'b0;
        if (sync_status) begin // si se encuentra sincronizado funciona la máquina de estados, caso contrario se queda esperando a que se sincronice
        case(state)
            LINK_FAILED: begin
                if (sync_status) begin // si se activa la señal de sincronizado seguir
                    next_state = WAIT_FOR_K;
                end
            end

            WAIT_FOR_K: begin
                if (rx_even && (rx_code_group == `K28_5_10B_RD_P || rx_code_group == `K28_5_10B_RD_N)) begin // si rx_even está activado y lo que se recibe es un IDLE pasa de estado
                    next_state = RX_K;
                end
            end

            RX_K: begin
                rx_dv = 0;
                rx_er = 0;
                if (rx_code_group != `D21_5_10B_RD_P && rx_code_group != `D21_5_10B_RD_N && 
                    rx_code_group != `D2_2_10B_RD_P && rx_code_group != `D2_2_10B_RD_N) begin // verificar que el valor de /D/ sea válido
                    next_state = IDLE_D;
                end
            end

            IDLE_D: begin
                rx_dv = 0;
                rx_er = 0;
                if (rx_code_group == `K28_5_10B_RD_P || rx_code_group == `K28_5_10B_RD_N) begin // Verificar si es una coma, si es una coma se devuelve al estado RX_K
                    next_state = RX_K;
                end else if (rx_code_group == `K27_7_10B_RD_P || rx_code_group == `K27_7_10B_RD_N) begin // si se recibe la señal de START irse al estado de START
                    next_state = START;
                end
            end

            START: begin
                rx_dv = 1'b1; // se enciende la salida de dato válido
                rxd = 8'b0101_0101; // Se manda la siguiente secuencia de datos
                next_state = RECEIVE; // Se envía al estado de recibido
            end

            RECEIVE: begin 
                // Verificar si check_end contiene /T/R/I (últimos 3 code-groups)

                if ((check_end[29:20] == `K29_7_10B_RD_P || check_end[29:20] == `K29_7_10B_RD_N) &&
                    (check_end[19:10] == `K23_7_10B_RD_P || check_end[19:10] == `K23_7_10B_RD_N) &&
                    (check_end[9:0] == `K28_5_10B_RD_P || check_end[9:0] == `K28_5_10B_RD_N)) begin
                    next_state = TRI_RRI;
                end 
                // Si no es /T/R/I, verificar /T/R/R
                else if ((check_end[29:20] == `K29_7_10B_RD_P || check_end[29:20] == `K29_7_10B_RD_N) &&
                    (check_end[19:10] == `K23_7_10B_RD_P || check_end[19:10] == `K23_7_10B_RD_N) &&
                    (check_end[9:0] == `K23_7_10B_RD_P || check_end[9:0] == `K23_7_10B_RD_N)) begin
                    rx_dv = 1'b1;
                    rxd = decoded_octet;
                    next_state = TRR_EXTEND;
                end
                // Si no es ninguno de los anteriores
                else if (rx_code_group != `D21_5_10B_RD_P && rx_code_group != `D21_5_10B_RD_N && 
                        rx_code_group != `D2_2_10B_RD_P && rx_code_group != `D2_2_10B_RD_N) begin
                    rx_dv = 1'b1;
                    rxd = decoded_octet;
                end
            end

            //RD_DATA: begin
                //rx_dv = 1'b1;
                //rxd = decoded_octet;  // Decodificar el code-group
                //next_state = RECEIVE;
            //end

            TRR_EXTEND: begin
                rx_er = 1'b1; // se activa la señal de error
                rxd = 8'b0000_1111; // se envía la siguiente señal de 8 bits por la salida
                next_state = TRI_RRI; 
            end

            TRI_RRI: begin
                next_state = RX_K;
            end

            default: begin
                next_state = LINK_FAILED; // caso contrario de lo demás se envía a link_failed
            end
        endcase
        end else begin
            state = LINK_FAILED; // si sync_status = 0, no está sincronizado
        end
    end


endmodule