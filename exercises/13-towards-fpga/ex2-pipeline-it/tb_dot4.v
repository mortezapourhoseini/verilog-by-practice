// tb_dot4.v - checks the result and the latency of exactly 3 cycles.
`timescale 1ns/1ps

module tb_dot4;

  reg         clk;
  reg         rst;
  reg         valid_in;
  reg  [31:0] a;
  reg  [31:0] b;
  wire [17:0] y;
  wire        valid_out;

  reg  [17:0] exp_q [1:3];
  reg         vld_q [1:3];
  integer     s;
  integer     k;
  integer     t;
  integer     errors;
  integer     results;

  dot4 dut (.clk(clk), .rst(rst), .valid_in(valid_in), .a(a), .b(b),
            .y(y), .valid_out(valid_out));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_dot4.vcd");
    $dumpvars(0, tb_dot4);
  end

  // At each rising edge: compare (old values), then shift the expected queue.
  always @(posedge clk) begin
    if (!rst) begin
      if (valid_out !== vld_q[3]) begin
        $display("ERROR at %0t: valid_out=%b, expected %b", $time, valid_out, vld_q[3]);
        errors = errors + 1;
      end
      if (vld_q[3] && y !== exp_q[3]) begin
        if (errors < 10)
          $display("ERROR at %0t: y=%0d, expected %0d", $time, y, exp_q[3]);
        errors = errors + 1;
      end
      if (valid_out) results = results + 1;
    end
    s = 0;
    for (k = 0; k < 4; k = k + 1)
      s = s + a[8*k +: 8] * b[8*k +: 8];
    exp_q[3] = exp_q[2]; vld_q[3] = vld_q[2];
    exp_q[2] = exp_q[1]; vld_q[2] = vld_q[1];
    exp_q[1] = s;        vld_q[1] = valid_in && !rst;
  end

  initial begin
    errors = 0; results = 0;
    for (k = 1; k <= 3; k = k + 1) vld_q[k] = 1'b0;
    rst = 1'b1; valid_in = 1'b0; a = 0; b = 0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // The largest result: 4 x 255 x 255 = 260100 (needs 18 bits).
    valid_in = 1'b1; a = 32'hFFFF_FFFF; b = 32'hFFFF_FFFF;
    @(negedge clk);

    // Back-to-back random inputs with some gaps.
    for (t = 0; t < 1000; t = t + 1) begin
      valid_in = ($random % 5) != 0;
      a = $random;
      b = $random;
      @(negedge clk);
    end
    valid_in = 1'b0;
    repeat (4) @(negedge clk);

    $display("%0d results checked", results);
    if (results < 500) begin
      $display("ERROR: too few results");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_dot4");
      $finish;
    end else begin
      $display("FAIL: tb_dot4 (%0d errors)", errors);
      $fatal(1, "tb_dot4 failed");
    end
  end

endmodule
