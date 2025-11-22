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

);

initial begin 
    // inicializaciones
    PUDI = 10'b1100000101;
    clk = 0;
    mr_main_reset = 0;
    signal_detectCHANGE = 0;
    signal_detect = 0;
    VALID_PUDI = 0;

    #10
    mr_main_reset = 1;
    signal_detectCHANGE = 1; 
    VALID_PUDI = 1; 
    // entrar al estado de Loss_of_sync
    #10 

    // Next_state = COMMA DETECT
    PUDI  = 10'b0101101001;
    #10 
    //next_state =  ACQUIRE_SYNC
    // drive valid PUDI and a next sample
    VALID_PUDI = 1;
    PUDI = 10'b1100000101;
    // NEXT_STATE = SYNC_ACQUIRE_1 (observer-driven)


    #100 $finish;

end

always begin
    #5 clk = !clk;
end


endmodule 