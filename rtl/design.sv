module ram8_8(
  input clk,
  input reset,
  input wr_en,
  input [2:0] wr_add,
  input [2:0] rd_add,
  input [7:0] data_in,
  output reg [7:0] data_out
);

  reg [7:0] mem [0:7];
  integer i;

  always @(posedge clk or posedge reset) begin

    if (reset) begin

      for (i = 0; i < 8; i = i + 1)
        mem[i] <= 8'd0;

      data_out <= 8'd0;

    end

    else begin

      if (wr_en) begin

        mem[wr_add] <= data_in;

      end

      else begin

        data_out <= mem[rd_add];

      end

    end

  end

endmodule