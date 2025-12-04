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
    VALID_PUDI = 0;
    mr_main_reset = 1; 
    #10
    mr_main_reset = 0;

       VALID_PUDI = 1; 
    // entrar al estado de Loss_of_sync
    #20
    // Next_state = COMMA DETECT 
    PUDI  = 10'b0101101001; // D
    #10
    // comma_cont = 1
    PUDI = 10'b1100000101;
    //next_state =  COMMA_DETECT
    #10
    PUDI  = 10'b0101101001; // D

    #10
    // comma_cont = 2
    PUDI = 10'b1100000101;
    //next_state =  COMMA_DETECT
    #10
    PUDI  = 10'b0101101001; // D
    #10
    // comma_cont = 3
    PUDI = 10'b1100000101;
    // NEXT_STATE = SYNC_ACQUIRE_1 



    #20
    mr_main_reset = 1;

    #15
    mr_main_reset = 0;
    VALID_PUDI = 1; 
        // entrar al estado de Loss_of_sync
    #20
    // Next_state = COMMA DETECT 
    PUDI  = 10'b0101101001; // D
    #10
    // comma_cont = 1
    PUDI = 10'b1100000101;
    //next_state =  COMMA_DETECT
    #10
    PUDI  = 10'b0101101001; // D

    #10
    // comma_cont = 2
    PUDI = 10'b1100000101;
    //next_state =  COMMA_DETECT
    #10
    PUDI  = 10'b0101101001; // D
    #10
    // comma_cont = 3
    PUDI = 10'b1100000101;
    // NEXT_STATE = SYNC_ACQUIRE_1 
    #10
    PUDI  = 10'b0101101001; // D
    #20 
    PUDI = 10'b1111111111;
    VALID_PUDI =0;
    #25
    PUDI  = 10'b0101101001; // D
    VALID_PUDI = 1;
    
    // Espera iteraciones hasta llegar a bad_cg = 4 -> muere y va a IDLE 
    




    // #80
    // mr_main_reset = 0;
    // signal_detectCHANGE = 0;
    // signal_detect = 0;
    // #15
    // mr_main_reset = 1;
    // signal_detectCHANGE = 1; 
    // VALID_PUDI = 1; 
    // signal_detect = 1;
    //     // entrar al estado de Loss_of_sync
    // #20
    // // Next_state = COMMA DETECT 
    // PUDI  = 10'b0101101001; // D
    // #10
    // // comma_cont = 1
    // PUDI = 10'b1100000101;
    // //next_state =  COMMA_DETECT
    // #10
    // PUDI  = 10'b0101101001; // D

    // #10
    // // comma_cont = 2
    // PUDI = 10'b1100000101;
    // //next_state =  COMMA_DETECT
    // #10
    // PUDI  = 10'b0101101001; // D
    // #10
    // // comma_cont = 3
    // PUDI = 10'b1100000101;
    // // NEXT_STATE = SYNC_ACQUIRE_1 
    // #10
    // PUDI  = 10'b0101101001; // D
    // #20 
    // PUDI = 10'b1111111111;
    // VALID_PUDI = 0; 
    // // Espera iteraciones hasta llegar a bad_cg = 4 -> muere y va a IDLE
    // #30
    // VALID_PUDI = 1;
    // #10
    // // comma_cont = 1
    // PUDI = 10'b1100000101;
    // //next_state =  COMMA_DETECT
    // #10
    // PUDI  = 10'b0101101001; // D
    
    

    // #80

    #100 $finish;

end

always begin
    #5 clk = !clk;
end


endmodule 
