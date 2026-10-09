class transaction;

  rand bit       wr_en;
  rand bit [2:0] wr_add;
  rand bit [2:0] rd_add;
  rand bit [7:0] data_in;

  bit [7:0] data_out;
  function void display(string name);
  $display("%s", name);
  $display("wr_en=%0d , wr_add=%0d , rd_add=%0d , data_in=%0d ,                data_out=%0d",wr_en,wr_add,rd_add,data_in,data_out);
 endfunction

endclass