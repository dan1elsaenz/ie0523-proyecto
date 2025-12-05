`include "tester.v"
`include "synchronization.v"
`include "PUDI_checker.v"

module testbench;

  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(-1, U0);
  end

  wire        mr_main_reset;
  wire        clk;
  wire        valid_pudi;  // Se conecta a PUDR
  wire [ 9:0] pudi;  // Se conecta al code_group
  wire        code_sync_status;
  wire        rx_even;
  wire [10:0] sudi;


  synchronization U0 (
      .clk         (clk),
      .mr_main_reset(mr_main_reset),
      .valid_pudi(valid_pudi),
      .pudi(pudi),
      .code_sync_status(code_sync_status),
      .rx_even(rx_even),
      .sudi(sudi)
  );


  probador P0 (
      .clk             (clk),
      .mr_main_reset   (mr_main_reset),
      .valid_pudi      (valid_pudi),
      .pudi            (pudi),
      .code_sync_status(code_sync_status),
      .rx_even         (rx_even),
      .sudi            (sudi)
  );


endmodule
