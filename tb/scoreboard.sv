class scoreboard;

  mailbox m2;
  bit [7:0] ref_mem [0:7];
  bit [2:0] prev_rd_addr;
  bit       prev_was_read;
  function new(mailbox m2);
    this.m2 = m2;
    foreach (ref_mem[i])
      ref_mem[i] = 8'd0;
    prev_rd_addr = 3'd0;
    prev_was_read = 1'b0;
  endfunction
  task run();
    forever begin
      transaction t;
      m2.get(t);
      // ------------------------------------------------
      // 1. Check previous cycle's read
      // ------------------------------------------------
      if (prev_was_read) begin
        if (t.data_out !== ref_mem[prev_rd_addr]) begin
          $display("❌ SCOREBOARD ERROR: addr=%0d expected=%0d got=%0d",
                   prev_rd_addr,
                   ref_mem[prev_rd_addr],
                   t.data_out);
        end
        else begin
          $display("✅ SCOREBOARD PASS: addr=%0d data=%0d",
                   prev_rd_addr,
                   t.data_out);
        end
      end
      // ------------------------------------------------
      // 2. Update reference memory for current write
      // ------------------------------------------------
      if (t.wr_en) begin
        ref_mem[t.wr_add] = t.data_in;
        $display("REFERENCE MODEL: mem[%0d] = %0d",
                 t.wr_add,
                 t.data_in);
      end
      // ------------------------------------------------
      // 3. Remember current read
      // ------------------------------------------------
      if (!t.wr_en) begin
        prev_was_read = 1'b1;
        prev_rd_addr = t.rd_add;
      end
      else begin
        prev_was_read = 1'b0;
      end
    end
  endtask
endclass