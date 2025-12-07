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


/*
 * Archivos incluidos
 */
`include "../constants/code_group_constants.v"
`include "../receive/decode.v"
`include "../running_disparity/running_disparity.v"


module receive (
    // INPUT
    input             rx_clk,         // Reloj de recepción
    input             mr_main_reset,  // Reinicio activo en alto
    input      [10:0] sudi,           // Señal en donde se recibe el code-group y el bit de paridad
    input             sync_status,    // Estado de sincronización
    // OUTPUT
    output reg [ 7:0] rxd,            // Dato recibido de 8 bits
    output reg        rx_dv,          // Indicador de dato válido
    output reg        rx_er           // Indicador de error
);


  /*
  * Variables internas
  */
  // Extracción de señales desde sudi
  wire [ 9:0] rx_code_group;  // Almacena los 10 bits del code-group
  wire        rx_even;  // Bit de paridad (ciclo par/impar)

  // Registro de verificación de fin de paquete
  reg  [29:0] check_end;  // Almacena los últimos 3 code-groups

  // Salida del decodificador
  wire [ 7:0] decoded_octet;  // Octeto decodificado

  // Running disparity actual y siguiente
  reg         rx_running_disparity;
  wire        next_rx_running_disparity;
  wire        rx_dv_decoded;

  // Asignación de señales de entrada
  assign rx_code_group = sudi[10:1];  // Asignar los 10 bits de entrada
  assign rx_even       = sudi[0];  // Asignar el bit de paridad


  /*
  * Instanciación de submódulos
  */
  // running_disparity calcula el siguiente running_disparity
  running_disparity #(
      .CG_WIDTH(10)
  ) rd2 (
      .rd_in     (rx_running_disparity),
      .code_group(rx_code_group),
      .rd_out    (next_rx_running_disparity)
  );

  // decode se encarga de realizar la decodificación 10B/8B
  decode #(
      .CG_WIDTH   (10),
      .OCTET_WIDTH(8)
  ) decode (
      .rx_code_group       (rx_code_group),
      .rx_running_disparity(rx_running_disparity),
      .rx_octet            (decoded_octet),
      .rx_dv_decoded       (rx_dv_decoded)
  );


  /*
  * Asignación de estados
  * Hot-One Encoding para evitar carreras de estado
  */
  localparam LINK_FAILED = 6'b000001;
  localparam WAIT_FOR_K = 6'b000010;
  localparam RX_K = 6'b000100;
  localparam IDLE_D = 6'b001000;
  localparam RECEIVE = 6'b010000;
  localparam TRI_RRI = 6'b100000;

  // Estado actual y próximo estado
  reg [5:0] state, next_state;


  /*
  * Lógica secuencial
  */
  always @(posedge rx_clk) begin
    if (mr_main_reset) begin
      // Estado inicial
      state                <= LINK_FAILED;
      rxd                  <= 0;
      rx_dv                <= 0;
      rx_er                <= 0;
      check_end            <= 30'b0;
      rx_running_disparity <= 0;  // Running disparity negativo inicialmente

    end else begin
      // Actualizar al próximo estado
      state                <= next_state;
      rx_running_disparity <= next_rx_running_disparity;

      // Actualizar el registro de verificación de fin de paquete (desplazamiento)
      check_end            <= {check_end[19:0], rx_code_group};
    end

  end  // always @(posedge rx_clk)


  /*
  * Lógica combinacional
  */
  always @(*) begin

    // Realimentación de los estados: Valor por defecto
    next_state = state;

    // Valores predeterminados
    rx_dv      = 1'b0;
    rx_er      = 1'b0;
    rxd        = 8'b0;

    // Verificar estado de sincronización
    if (sync_status) begin
      // Si se encuentra sincronizado funciona la máquina de estados

      case (state)

        /*
        * LINK_FAILED
        *
        * Estado de enlace fallido. Espera a que sync_status se active
        * para pasar al siguiente estado
        */
        LINK_FAILED: begin
          if (sync_status) begin
            // Si se activa la señal de sincronizado seguir
            next_state = WAIT_FOR_K;
          end
        end  // LINK_FAILED

        /*
        * WAIT_FOR_K
        *
        * Espera a recibir un code-group K28.5 (IDLE) con ciclo par
        * para sincronizar el inicio de la recepción
        */
        WAIT_FOR_K: begin
          // Si rx_even está activado y lo que se recibe es un IDLE pasa de estado
          if (rx_even && (rx_code_group == `K28_5_10B_RD_P || rx_code_group == `K28_5_10B_RD_N)) begin
            next_state = RX_K;
          end
        end  // WAIT_FOR_K

        /*
        * RX_K
        *
        * Recibe el segundo code-group del IDLE (D21.5 o D2.2)
        * Verifica que sea uno de estos valores válidos
        */
        RX_K: begin
          rx_dv = 0;
          rx_er = 0;

          // Verificar que el valor de /D/ sea válido
          if (rx_code_group != `D21_5_10B_RD_P && rx_code_group != `D21_5_10B_RD_N &&
              rx_code_group != `D2_2_10B_RD_P && rx_code_group != `D2_2_10B_RD_N) begin
            next_state = IDLE_D;
          end
        end  // RX_K

        /*
        * IDLE_D
        *
        * Estado de espera. Puede recibir:
        * - K28.5: Nueva secuencia IDLE, vuelve a RX_K
        * - K27.7: Start of Packet, pasa a START
        */
        IDLE_D: begin
          rx_dv = 0;
          rx_er = 0;

          // Verificar si es una coma, si es una coma se devuelve al estado RX_K
          if (rx_code_group == `K28_5_10B_RD_P || rx_code_group == `K28_5_10B_RD_N) begin
            next_state = RX_K;

            // Si se recibe la señal de START irse al estado de START
          end else if (rx_code_group == `K27_7_10B_RD_P || rx_code_group == `K27_7_10B_RD_N) begin

            rx_dv      = 1'b1;  // Se enciende la salida de dato válido
            rxd        = 8'b0101_0101;  // Se manda la secuencia de datos que se envia en START
            next_state = RECEIVE;  // Se envía al estado de recibido
          end
        end  // IDLE_D

        /*
        * RECEIVE
        *
        * Recibe datos del paquete. Verifica constantemente si se recibe
        * una secuencia de fin de paquete:
        * - /T/R/I (K29.7, K23.7, K28.5): Fin normal
        * - /T/R/R (K29.7, K23.7, K23.7): Extensión de carrier
        * Si no es fin de paquete, decodifica y envía el octeto
        */
        RECEIVE: begin
          // Verificar si check_end contiene /T/R/I (últimos 3 code-groups)
          if ((check_end[29:20] == `K29_7_10B_RD_P || check_end[29:20] == `K29_7_10B_RD_N) &&
              (check_end[19:10] == `K23_7_10B_RD_P || check_end[19:10] == `K23_7_10B_RD_N) &&
              (check_end[9:0] == `K28_5_10B_RD_P || check_end[9:0] == `K28_5_10B_RD_N)) begin
            next_state = TRI_RRI;

            // Si no es /T/R/I, verificar /T/R/R
          end else if ((check_end[29:20] == `K29_7_10B_RD_P || check_end[29:20] == `K29_7_10B_RD_N) &&
                       (check_end[19:10] == `K23_7_10B_RD_P || check_end[19:10] == `K23_7_10B_RD_N) &&
                       (check_end[9:0] == `K23_7_10B_RD_P || check_end[9:0] == `K23_7_10B_RD_N)) begin
            rx_dv      = 0;
            rx_er      = 1'b1;  // Se activa la señal de error
            rxd        = 8'b0000_1111;  // Se envía la siguiente señal de 8 bits por la salida
            next_state = TRI_RRI;

            // Si no es ninguno de los anteriores, continuar recibiendo datos
          end else if (rx_code_group != `K28_5_10B_RD_P && rx_code_group != `K28_5_10B_RD_N) begin
            rx_dv = rx_dv_decoded;
            rxd   = decoded_octet;
          end
        end  // RECEIVE

        /*
        * TRI_RRI
        *
        * Fin de paquete. Regresa al estado RX_K para esperar
        * la siguiente secuencia IDLE
        */
        TRI_RRI: begin
          next_state = RX_K;
        end  // TRI_RRI

        /*
        * default
        *
        * Caso contrario de lo demás se envía a LINK_FAILED
        */
        default: begin
          next_state = LINK_FAILED;
        end  // default

      endcase

    end else begin
      // Si sync_status = 0, no está sincronizado
      state = LINK_FAILED;
    end

  end  // always @(*)

endmodule
