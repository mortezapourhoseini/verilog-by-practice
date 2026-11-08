// tb_avg4.v - testbench for the moving average (exercise 14.1).
`timescale 1ns/1ps

module tb_avg4;

  reg        clk;
  reg        rst;
  reg        valid;
  reg  [7:0] din;
  wire [7:0] avg;
  wire       out_valid;

  integer h0, h1, h2;      // model: the three previous valid samples
  integer want;
  reg     want_valid;
  integer errors;
  integer outputs;
  integer t;

  avg4 dut (.clk(clk), .rst(rst), .valid(valid), .din(din), .avg(avg), .out_valid(out_valid));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_avg4.vcd");
    $dumpvars(0, tb_avg4);
  end

  // At each rising edge: check the output of the last cycle, then update
  // the model with the inputs of this cycle.
  always @(posedge clk) begin
    if (!rst) begin
      if (out_valid !== want_valid) begin
        if (errors < 10)
          $display("ERROR at %0t: out_valid=%b, expected %b", $time, out_valid, want_valid);
        errors = errors + 1;
      end
      if (want_valid && avg !== want) begin
        if (errors < 10)
          $display("ERROR at %0t: avg=%0d, expected %0d", $time, avg, want);
        errors = errors + 1;
      end
      if (out_valid) outputs = outputs + 1;
    end
    if (rst) begin
      h0 = 0; h1 = 0; h2 = 0;
      want_valid = 1'b0;
    end else begin
      want_valid = valid;
      if (valid) begin
        want = (din + h0 + h1 + h2) / 4;
        h2 = h1; h1 = h0; h0 = din;
      end
    end
  end

  initial begin
    errors = 0; outputs = 0; want = 0; want_valid = 0;
    rst = 1'b1; valid = 1'b0; din = 8'd0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Directed: four samples of 200. The average must be 200.
    repeat (4) begin
      valid = 1'b1; din = 8'd200;
      @(negedge clk);
    end
    // A gap: valid = 0 must not change the history.
    valid = 1'b0; din = 8'd0;
    repeat (3) @(negedge clk);
    valid = 1'b1; din = 8'd200;
    @(negedge clk);

    // Random samples with gaps.
    for (t = 0; t < 1000; t = t + 1) begin
      valid = ($random % 3) != 0;
      din   = $random;
      @(negedge clk);
    end
    valid = 1'b0;
    repeat (2) @(negedge clk);

    $display("%0d averages checked", outputs);
    if (errors == 0) begin
      $display("PASS: tb_avg4");
      $finish;
    end else begin
      $display("FAIL: tb_avg4 (%0d errors)", errors);
      $fatal(1, "tb_avg4 failed");
    end
  end

endmodule
