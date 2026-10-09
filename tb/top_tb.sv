`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"


module tb;
  reg clk;
  intf inv(clk);
  ram8_8 dut (
    .clk      (clk),
    .reset    (inv.reset),
    .wr_en    (inv.wr_en),
    .wr_add   (inv.wr_add),
    .rd_add   (inv.rd_add),
    .data_in  (inv.data_in),
    .data_out (inv.data_out)
  );
  // Clock generation
  initial begin
    clk = 0;
    forever
      #5 clk = ~clk;
  end
  initial begin
    // Initial values
    inv.reset  = 1;
    inv.wr_en  = 0;
    inv.wr_add = 0;
    inv.rd_add = 0;
    inv.data_in = 0;
    // Reset
    #12;
    inv.reset = 0;
  end
  initial begin
    test t;
    t = new(inv);
    #12;
    t.run();
  end
endmodule