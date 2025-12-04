/*
* =============================================================================
*
* - File        : transmit_code_group.v
* - Autor       : Daniel Alberto Sáenz Obando (C37099)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción :
*   Máquina de estados transmit code group descrita en la cláusula 36 del
*   estándar IEEE 802.3 de la capa PCS de Ethernet. Se encarga de generar los
*   code-groups de 10 bits a partir de 8 bits, para los cuales diferencia si
*   se trata de un ordered-set de control (/K/), de datos (/D/), de IDLE (/I/),
*   de inicio (/S/), de terminación (/T/) o de carrier extend (/R/).
*
* =============================================================================
*/


/*
 * Archivos incluidos
 */
`include "../constants/code_group_constants.v"
`include "../constants/tx_o_set_constants.v"
`include "../transmit/encode.v"
`include "../running_disparity/running_disparity.v"


module transmit_code_group #(
    parameter integer CG_WIDTH       = 10,
    parameter integer OCTET_WIDTH    = 8,
    parameter integer TX_O_SET_WIDTH = 5
) (
    // INPUT
    input                           gtx_clk,           // Reloj de transmisión
    input                           mr_main_reset,     // Reinicio activo en alto
    input      [   OCTET_WIDTH-1:0] txd,               // 8 bits a transmitir
    input      [TX_O_SET_WIDTH-1:0] tx_o_set,          // Identificador de CG
    // OUTPUT
    output     [      CG_WIDTH-1:0] tx_code_group,     // CG para transmitir
    output reg                      tx_even,           // Ciclo par/impar
    output reg                      tx_oset_indicate,  // Indicador CG listo
    output reg                      pudr               // Indicador CG a PMA
);


  /*
  * Asignación de estados
  * Hot-One Encoding para evitar carreras de estado
  */
  localparam integer GENERATE_CODE_GROUPS = 2'b01, IDLE_2 = 2'b10;


  /*
  * Variables internas
  */
  // Estado actual y próximo estado
  reg [1:0] estado, prox_estado;

  // Registro de 8 bits a transformar
  reg [OCTET_WIDTH-1:0] octet;

  // Indicador para el encoder si es code-group tipo K
  reg tx_is_k;

  // Almacenar running_disparity actual y previa
  reg tx_disparity, tx_disparity_next;

  // Guardar memoria de envío par/impar
  reg tx_even_prev;


  /*
  * Instanciación de submódulos
  */
  // encode se encarga de realizar la codificación 8B/10B
  encode #(
      .CG_WIDTH   (CG_WIDTH),
      .OCTET_WIDTH(OCTET_WIDTH)
  ) encoder (
      .octet        (octet),
      .tx_is_k      (tx_is_k),
      .tx_disparity (tx_disparity),
      .tx_code_group(tx_code_group)
  );

  // running_disparity calcula el siguiente running_disparity
  running_disparity #(
      .CG_WIDTH(CG_WIDTH)
  ) rd1 (
      .rd_in     (tx_disparity),
      .code_group(tx_code_group),
      .rd_out    (tx_disparity_next)
  );


  /*
  * Lógica secuencial
  */
  always @(posedge gtx_clk) begin
    if (mr_main_reset) begin
      // Estado inicial
      estado       <= GENERATE_CODE_GROUPS;
      tx_even_prev <= 1;  // Ciclo par
      tx_disparity <= 0;  // Negativo

    end else begin
      // Actualizar al próximo estado
      estado       <= prox_estado;
      tx_even_prev <= tx_even;
      tx_disparity <= tx_disparity_next;
    end

  end  // always @(posedge clk)


  /*
  * Lógica combinacional
  */
  always @(*) begin

    // Realimentación de los estados: Valor por defecto
    prox_estado      = estado;
    tx_even          = tx_even_prev;

    // Valores predeterminados
    octet            = '0;
    tx_oset_indicate = 0;
    pudr             = 0;
    tx_is_k          = 0;

    case (estado)

      /*
      * GENERATE_CODE_GROUPS
      *
      * Clasifica dependiendo de tx_o_set para determinar el siguiente estado
      */
      GENERATE_CODE_GROUPS: begin
        // Selección de octet
        if (tx_o_set == `D_OS) begin
          octet            = txd;

          tx_even          = !tx_even_prev;
          tx_oset_indicate = 1;
          pudr             = 1;

        end else if (tx_o_set == `I_OS) begin
          octet       = `K28_5_8B;
          tx_is_k     = 1;

          tx_even     = !tx_even_prev;
          pudr        = 1;

          // Cambio de estado
          prox_estado = IDLE_2;

        end else if (tx_o_set == `S_OS) begin
          octet            = `K27_7_8B;
          tx_is_k          = 1;

          tx_even          = !tx_even_prev;
          tx_oset_indicate = 1;
          pudr             = 1;

        end else if (tx_o_set == `T_OS) begin
          octet            = `K29_7_8B;
          tx_is_k          = 1;

          tx_even          = !tx_even_prev;
          tx_oset_indicate = 1;
          pudr             = 1;

        end else if (tx_o_set == `R_OS) begin
          octet            = `K23_7_8B;
          tx_is_k          = 1;

          tx_even          = !tx_even_prev;
          tx_oset_indicate = 1;
          pudr             = 1;

        end


      end  // GENERATE_CODE_GROUPS

      /*
      * IDLE_2
      *
      * Envía K5.6 o K16.2 dependiendo de si se tiene running_disparity
      * positivo o negativo respectivamente
      * Apaga señal de ciclo par
      */
      IDLE_2: begin
        if (!tx_disparity) begin
          // running_disparity inicial positivo: WRONG
          octet = `D5_6_8B;
        end else begin
          // running_disparity inicial negativo: OK
          octet = `D16_2_8B;
        end

        tx_even          = 0;
        tx_oset_indicate = 1;
        pudr             = 1;

        // Cambio de estados
        prox_estado      = GENERATE_CODE_GROUPS;
      end  // IDLE_1

      /*
      * default
      * Estado inicial como predeterminado
      */
      default: begin
        prox_estado = estado;
      end  // default

    endcase

  end  // always @(*)

endmodule
