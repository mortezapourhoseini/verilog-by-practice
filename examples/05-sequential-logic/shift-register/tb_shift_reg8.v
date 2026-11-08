// tb_shift_reg8.v - serial-to-parallel and parallel-to-serial tests.
`timescale 1ns/1ps

module tb_shift_reg8;

  reg        clk;
  reg        rst;
  reg        en;
  reg        load;
  reg  [7:0] parallel_in;
  reg        serial_in;
  wire [7:0] q;
  wire       serial_out;

  reg  [7:0] byte_value;
  reg  [7:0] received;
  integer    errors;
  integer    k;

  shift_reg8 dut (
    .clk         (clk),
    .rst         (rst),
    .en          (en),
    .load        (load),
    .parallel_in (parallel_in),
    .serial_in   (serial_in),
    .q           (q),
    .serial_out  (serial_out)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_shift_reg8.vcd");
    $dumpvars(0, tb_shift_reg8);
  end

  initial begin
    errors = 0;
    rst = 1'b1; en = 1'b0; load = 1'b0;
    parallel_in = 8'd0; serial_in = 1'b0;
    @(negedge clk);
    rst = 1'b0;

    // Test 1: serial in, MSB first. After 8 shifts, q holds the byte.
    byte_value = 8'b1011_0010;
    en = 1'b1;
    for (k = 7; k >= 0; k = k - 1) begin
      serial_in = byte_value[k];
      @(negedge clk);
    end
    en = 1'b0;
    if (q !== byte_value) begin
      $display("ERROR: serial in: q=%b, expected %b", q, byte_value);
      errors = errors + 1;
    end else begin
      $display("ok    serial in, MSB first: q=%b", q);
    end

    // Test 2: hold. With en = 0 the value must not change.
    serial_in = 1'b1;
    repeat (3) @(negedge clk);
    if (q !== byte_value) begin
      $display("ERROR: hold: q=%b", q);
      errors = errors + 1;
    end

    // Test 3: parallel load, then serial out, MSB first.
    parallel_in = 8'hC5;
    load = 1'b1;
    @(negedge clk);
    load = 1'b0;
    en = 1'b1;
    serial_in = 1'b0;
    received = 8'd0;
    for (k = 0; k < 8; k = k + 1) begin
      received = {received[6:0], serial_out};   // read before the shift
      @(negedge clk);
    end
    if (received !== 8'hC5) begin
      $display("ERROR: serial out: received %h, expected c5", received);
      errors = errors + 1;
    end else begin
      $display("ok    parallel in, serial out: received %h", received);
    end

    if (errors == 0) begin
      $display("PASS: tb_shift_reg8");
      $finish;
    end else begin
      $display("FAIL: tb_shift_reg8 (%0d errors)", errors);
      $fatal(1, "tb_shift_reg8 failed");
    end
  end

endmodule
