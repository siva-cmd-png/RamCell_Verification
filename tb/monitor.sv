class monitor;

  mailbox m2;
  virtual intf inv;
  function new(mailbox m2, virtual intf inv);
    this.m2  = m2;
    this.inv = inv;
  endfunction
  task run();
    forever begin
      transaction t;
      t = new();
      @(posedge inv.clk);
      // Allow DUT NBA assignments to update
      #1;
      t.wr_en    = inv.wr_en;
      t.wr_add   = inv.wr_add;
      t.rd_add   = inv.rd_add;
      t.data_in  = inv.data_in;
      t.data_out = inv.data_out;
      m2.put(t);
      t.display("MONITOR");
    end
  endtask
endclass