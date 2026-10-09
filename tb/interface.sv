interface intf(input clk);
  logic reset;
  logic       wr_en;
  logic [2:0] wr_add;
  logic [2:0] rd_add;
  logic [7:0] data_in;
  logic [7:0] data_out;
endinterface