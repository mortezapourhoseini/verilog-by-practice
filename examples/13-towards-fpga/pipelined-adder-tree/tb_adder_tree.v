// tb_adder_tree.v - same results, different latency.
// The pipelined result must match the input from exactly 3 edges earlier.
`timescale 1ns/1ps

module tb_adder_tree;

  reg         clk;
  reg         rst;
  reg         valid_in;
  reg  [63:0] din;
  wire [10:0] sum_comb;
  wire [10:0] sum_pipe;
  wire        valid_out;

  reg  [10:0] expect_q [0:3];   // expected sums, delayed like the pipeline
  reg         vexp_q   [0:3];
  integer     errors;
  integer     results;
  integer     t;
  integer     k;
  integer     s;

  adder_tree_comb u_comb (.clk(clk), .din(din), .sum(sum_comb));
  adder_tree_pipe u_pipe (.clk(clk), .rst(rst), .valid_in(valid_in), .din(din),
                          .sum(sum_pipe), .valid_out(valid_out));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_adder_tree.vcd");
    $dumpvars(0, tb_adder_tree);
  end

  // At each rising edge (before the updates), shift the expected values,
  // like the pipeline does, and compare the pipeline output.
  always @(posedge clk) begin
    if (!rst) begin
      if (valid_out !== vexp_q[3]) begin
        $display("ERROR at %0t: valid_out=%b, expected %b", $time, valid_out, vexp_q[3]);
        errors = errors + 1;
      end
      if (vexp_q[3] && sum_pipe !== expect_q[3]) begin
        $display("ERROR at %0t: sum_pipe=%0d, expected %0d", $time, sum_pipe, expect_q[3]);
        errors = errors + 1;
      end
      if (valid_out) results = results + 1;
    end
    s = 0;
    for (k = 0; k < 8; k = k + 1) s = s + din[8*k +: 8];
    expect_q[3] = expect_q[2]; vexp_q[3] = vexp_q[2];
    expect_q[2] = expect_q[1]; vexp_q[2] = vexp_q[1];
    expect_q[1] = s;           vexp_q[1] = valid_in && !rst;
  end

  initial begin
    errors = 0; results = 0;
    for (k = 1; k <= 3; k = k + 1) vexp_q[k] = 1'b0;
    rst = 1'b1; valid_in = 1'b0; din = 64'd0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // All values 255: the largest sum (2040).
    valid_in = 1'b1; din = {8{8'hFF}};
    @(negedge clk);
    // The comb version has one register: its result is ready now.
    if (sum_comb !== 11'd2040) begin
      $display("ERROR: sum_comb=%0d, expected 2040", sum_comb);
      errors = errors + 1;
    end

    for (t = 0; t < 500; t = t + 1) begin
      valid_in = ($random % 4) != 0;
      din = {$random, $random};
      @(negedge clk);
    end
    valid_in = 1'b0;
    repeat (4) @(negedge clk);

    $display("%0d pipelined results checked", results);

    if (errors == 0) begin
      $display("PASS: tb_adder_tree");
      $finish;
    end else begin
      $display("FAIL: tb_adder_tree (%0d errors)", errors);
      $fatal(1, "tb_adder_tree failed");
    end
  end

endmodule
