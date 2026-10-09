class environment;
  mailbox m1;
  mailbox m2;
  generator  gen;
  driver     drv;
  monitor    mon;
  scoreboard sb;
  virtual intf inv;
  function new(virtual intf inv);
    this.inv = inv;
    m1 = new();
    m2 = new();
    gen = new(m1);
    drv = new(m1, inv);
    mon = new(m2, inv);
    sb  = new(m2);
  endfunction
  task run();
    fork
      gen.run();

      drv.run();

      mon.run();

      sb.run();

    join_none
  endtask
endclass