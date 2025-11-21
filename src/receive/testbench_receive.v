/*
* ==================================================================================
*
* - File        : testbench_receive.v
* - Autor       : Brandon Jiménez Campos (C33972)
* - Curso       : Sistemas Digitales II, Universidad de Costa Rica
* - Fecha       : 05-12-2025
*
* - Descripción : 
*   Testbench para el bloque de recepción
* ==================================================================================
*/

`include "receive.v"
`include "tester_receive.v"

module testbench;

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			rx_clk;			// From test of tester_receive.v
wire			mr_main_reset;		// From test of tester_receive.v
wire			rx_dv;			// From rec of receive.v
wire			rx_er;			// From rec of receive.v
wire [7:0]		rxd;			// From rec of receive.v
wire [10:0]		sudi;			// From test of tester_receive.v
wire			sync_status;		// From test of tester_receive.v
// End of automatics

initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(0, testbench);
    end

    tester_receive test (/*AUTOINST*/
			 // Outputs
			 .rx_clk			(rx_clk),
			 .mr_main_reset		(mr_main_reset),
			 .sudi			(sudi[10:0]),
			 .sync_status		(sync_status));

    receive rec (/*AUTOINST*/
		 // Outputs
		 .rxd			(rxd[7:0]),
		 .rx_dv			(rx_dv),
		 .rx_er			(rx_er),
		 // Inputs
		 .rx_clk			(rx_clk),
		 .mr_main_reset		(mr_main_reset),
		 .sudi			(sudi[10:0]),
		 .sync_status		(sync_status));

endmodule
