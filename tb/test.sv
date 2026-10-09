class test;
  environment env;
  virtual intf inv;
  function new(virtual intf inv);
    this.inv = inv;
    env = new(inv);
  endfunction
  task run();
    env.run();
    // Allow time for all transactions
    #500;
    $display("======================================");
    $display("TEST COMPLETED");
    $display("======================================");
    $finish;
  endtask
endclass