

`include "../constants/code_group_constants.v"

module probador #(
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
    output reg                 valid_pudi,        // Se conecta a PUDR
    output reg  [CG_WIDTH-1:0] pudi               // Se conecta al code_group
);

  /*
  * Generación de la señal de reloj
  */
  always begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    // inicializaciones
    pudi = '0;
    clk  = 0;
    #5;

    valid_pudi = 0;
    mr_main_reset = 1;
    @(posedge clk) mr_main_reset = 0;
    @(posedge clk);

    /*
    * COMMA
    */
    valid_pudi = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    valid_pudi = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    /*
    * COMMA
    */
    valid_pudi = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    valid_pudi = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    /*
    * COMMA
    */
    valid_pudi = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    valid_pudi = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    /*
    * COMMA
    */
    valid_pudi = 1;
    pudi = `K28_5_10B_RD_N;
    @(posedge clk);

    valid_pudi = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);


    /*
    * Ya está sincronizado
    * Ahora se manda uno inválido y uno válido
    */
    valid_pudi = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    // Vuelve a sincronizarse
    valid_pudi = 1;
    pudi = `D5_6_10B_RD_N;
    @(posedge clk);

    valid_pudi = 1;
    pudi = `D16_2_10B_RD_P;
    @(posedge clk);

    valid_pudi = 1;
    pudi = `D0_0_10B_RD_N;
    @(posedge clk);

    valid_pudi = 1;
    pudi = `D2_0_10B_RD_N;
    @(posedge clk);


    /*
    * Desincronización completa
    */
    valid_pudi = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    valid_pudi = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    valid_pudi = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    valid_pudi = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    valid_pudi = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    valid_pudi = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    valid_pudi = 1;
    pudi = 10'b11_1111_1111;
    @(posedge clk);

    valid_pudi = 1;
    pudi = 10'b00_0000_0001;
    @(posedge clk);

    #20 $finish;

  end



endmodule
