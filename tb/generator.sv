class generator;

  mailbox m1;
  function new(mailbox m1);
    this.m1 = m1;
  endfunction
  task run();
    repeat (20) begin
      transaction t;
      t = new();
      if (!t.randomize()) begin
        $display("RANDOMIZATION FAILED");
        $finish;
      end
      m1.put(t);
      t.display("GENERATOR");
    end
  endtask
endclass