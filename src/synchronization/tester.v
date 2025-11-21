module probador(

    output reg       mr_main_reset, 
    output reg       clk,
    output reg       signal_detectCHANGE, 
    output reg       signal_detect, 
    output reg       VALID_PUDI, // Se conecta a PUDR
    output reg [9:0] PUDI,  // Se conecta al code_group



    input wire        code_sync_status,
    input wire        rx_even,
    input wire [10:0] SUDI

)

initial begin 
    PUDI = 10'b110000 0101;
    clk = 0;
    reset = 0;


    // entrar al estado de Loss_of_sync



end