// tb_mac_q7.v - dot products in Q1.7, checked with an integer model.
// The real numbers are only printed, to make the fixed-point values readable.
`timescale 1ns/1ps

module tb_mac_q7;

  reg               clk;
  reg               rst;
  reg               valid;
  reg               first;
  reg  signed [7:0] a;
  reg  signed [7:0] b;
  wire signed [19:0] acc;
  wire              acc_valid;
  wire signed [7:0] y;

  integer model_acc;      // the exact sum of products, in units of 2^-14
  integer want_y;
  integer errors;
  integer v;
  integer n;
  integer len;
  integer k;

  mac_q7 dut (
    .clk(clk), .rst(rst), .valid(valid), .first(first), .a(a), .b(b),
    .acc(acc), .acc_valid(acc_valid), .y(y)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_mac_q7.vcd");
    $dumpvars(0, tb_mac_q7);
  end

  // Round to nearest (half up) and saturate, written with integer division
  // instead of shifts. floor(x / 128) for negative x needs care in Verilog,
  // because "/" truncates toward zero.
  function integer round_sat;
    input integer x;
    integer q;
    begin
      q = x + 64;
      if (q >= 0) q = q / 128;
      else        q = -((-q + 127) / 128);   // floor for negative values
      if (q > 127)  q = 127;
      if (q < -128) q = -128;
      round_sat = q;
    end
  endfunction

  // Feed one dot product of length len, then wait for the pipeline.
  task dot_product;
    input integer length;
    begin
      for (k = 0; k < length; k = k + 1) begin
        @(negedge clk);
        valid = 1'b1;
        first = (k == 0);
        a = $random;
        b = $random;
        if (k == 0) model_acc = 0;
        model_acc = model_acc + a * b;    // a and b are signed: signed product
      end
      @(negedge clk);
      valid = 1'b0;
      first = 1'b0;
      // Two pipeline stages: after the last input, wait until acc is updated.
      @(negedge clk);
      want_y = round_sat(model_acc);
      if (acc !== model_acc || y !== want_y) begin
        $display("ERROR: length %0d: acc=%0d y=%0d, expected acc=%0d y=%0d",
                 length, acc, y, model_acc, want_y);
        errors = errors + 1;
      end
      n = n + 1;
    end
  endtask

  initial begin
    errors = 0;
    n = 0;
    rst = 1'b1; valid = 1'b0; first = 1'b0; a = 0; b = 0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // A readable example: 0.5 * 0.5 + 0.25 * -1.0 = 0.0
    @(negedge clk); valid = 1; first = 1; a = 8'sd64; b = 8'sd64;     // 0.5 * 0.5
    @(negedge clk);             first = 0; a = 8'sd32; b = -8'sd128;  // 0.25 * -1.0
    @(negedge clk); valid = 0;
    @(negedge clk);
    $display("0.5*0.5 + 0.25*(-1.0) = %f (acc=%0d, y=%0d)", acc / 16384.0, acc, y);
    if (acc !== 0) errors = errors + 1;

    // Saturation: 8 x (0.99 * 0.99) = 7.84 -> y saturates to 127 (0.99).
    @(negedge clk); valid = 1; first = 1; a = 8'sd127; b = 8'sd127;
    repeat (7) begin @(negedge clk); first = 0; end
    @(negedge clk); valid = 0;
    @(negedge clk);
    $display("8 x 0.99^2 = %f -> y = %0d (saturated)", acc / 16384.0, y);
    if (y !== 8'sd127) errors = errors + 1;

    // Random dot products of length 1 to 16.
    for (v = 0; v < 300; v = v + 1) begin
      len = 1 + ($unsigned($random) % 16);
      dot_product(len);
    end
    $display("%0d random dot products checked", n);

    if (errors == 0) begin
      $display("PASS: tb_mac_q7");
      $finish;
    end else begin
      $display("FAIL: tb_mac_q7 (%0d errors)", errors);
      $fatal(1, "tb_mac_q7 failed");
    end
  end

endmodule
