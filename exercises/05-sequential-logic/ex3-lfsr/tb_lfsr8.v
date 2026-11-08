// tb_lfsr8.v - checks the sequence and its period.
`timescale 1ns/1ps

module tb_lfsr8;

  reg        clk;
  reg        rst;
  reg        en;
  wire [7:0] q;

  reg  [7:0] model;
  reg        seen [0:255];   // seen[v] = 1 after value v appeared
  integer    errors;
  integer    step;
  integer    period;
  integer    v;

  lfsr8 dut (
    .clk (clk),
    .rst (rst),
    .en  (en),
    .q   (q)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_lfsr8.vcd");
    $dumpvars(0, tb_lfsr8);
  end

  initial begin
    errors = 0;
    period = 0;
    for (v = 0; v < 256; v = v + 1) seen[v] = 1'b0;

    rst = 1'b1; en = 1'b0;
    @(negedge clk);
    rst = 1'b0;
    if (q !== 8'h01) begin
      $display("ERROR: after reset q=%h, expected 01", q);
      errors = errors + 1;
    end

    // 1. Compare with a model for 20 steps. The model writes the feedback
    //    as the parity of the tapped bits: ^(q & mask).
    model = 8'h01;
    en = 1'b1;
    for (step = 0; step < 20; step = step + 1) begin
      @(negedge clk);
      model = {model[6:0], ^(model & 8'b1011_1000)};
      if (q !== model) begin
        $display("ERROR: step %0d: q=%b, expected %b", step + 1, q, model);
        errors = errors + 1;
      end
    end

    // 2. and 3. Restart and run until the seed comes back.
    rst = 1'b1;
    @(negedge clk);
    rst = 1'b0;
    seen[q] = 1'b1;
    for (step = 1; step <= 300 && period == 0; step = step + 1) begin
      @(negedge clk);
      if (q === 8'h00 || q === 8'hxx) begin
        $display("ERROR: q=%h at step %0d", q, step);
        errors = errors + 1;
      end
      if (q === 8'h01)
        period = step;
      else if (seen[q]) begin
        $display("ERROR: value %h repeated before the seed came back", q);
        errors = errors + 1;
      end
      seen[q] = 1'b1;
    end

    $display("period = %0d", period);
    if (period != 255) begin
      $display("ERROR: the period should be 255");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_lfsr8");
      $finish;
    end else begin
      $display("FAIL: tb_lfsr8 (%0d errors)", errors);
      $fatal(1, "tb_lfsr8 failed");
    end
  end

endmodule
