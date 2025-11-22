`include "tester.v"
`include "synchronization.v"


module Controlador_tb; 


    wire        mr_main_reset;
    wire        clk;
    wire        signal_detectCHANGE;
    wire        signal_detect; 
    wire        VALID_PUDI; // Se conecta a PUDR
    wire [9:0]  PUDI;  // Se conecta al code_group
    wire        code_sync_status;
    wire        rx_even;
    wire [10:0] SUDI;

    initial begin 
        $dumpfile("resultados.vcd");
        $dumpvars(-1, U0);

    end 


synchronization U0 (
    .mr_main_reset(mr_main_reset),
    .clk(clk),
    .signal_detectCHANGE(signal_detectCHANGE),
    .signal_detect(signal_detect),
    .VALID_PUDI(VALID_PUDI),
    .PUDI(PUDI),
    .code_sync_status(code_sync_status),
    .rx_even(rx_even),
    .SUDI(SUDI)
);


probador P0 (
    .mr_main_reset(mr_main_reset),
    .clk(clk),
    .signal_detectCHANGE(signal_detectCHANGE),
    .signal_detect(signal_detect),
    .VALID_PUDI(VALID_PUDI),
    .PUDI(PUDI),
    .code_sync_status(code_sync_status),
    .rx_even(rx_even),
    .SUDI(SUDI)
);


endmodule