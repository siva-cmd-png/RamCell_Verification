class driver;

  mailbox m1;
  virtual intf inv;
  function new(mailbox m1, virtual intf inv);
    this.m1  = m1;
    this.inv = inv;
  endfunction
  task run();
    forever begin
      transaction t;
      t = new();
      // Get transaction from generator
      m1.get(t);
      // Drive before DUT samples at posedge
      @(negedge inv.clk);
      inv.wr_en   = t.wr_en;
      inv.wr_add  = t.wr_add;
      inv.rd_add  = t.rd_add;
      inv.data_in = t.data_in;

      t.display("DRIVER");
    end
  endtask
endclass