// tb_event_counter.v - power-up garbage and a reset in the middle.
`timescale 1ns/1ps

module tb_event_counter;

  reg        clk;
  reg        rst;
  reg        tick;
  wire [7:0] count;

  integer model;
  integer errors;
  integer cycle;

  event_counter dut (.clk(clk), .rst(rst), .tick(tick), .count(count));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_event_counter.vcd");
    $dumpvars(0, tb_event_counter);
  end

  initial begin
    errors = 0;
    rst = 1'b1;
    tick = 1'b0;

    // Simulate a chip that powers up with a random register value.
    #1 dut.count = 8'hA5;

    repeat (2) @(negedge clk);
    if (count !== 8'd0) begin
      $display("ERROR: count=%h after reset, expected 00", count);
      errors = errors + 1;
    end
    rst = 1'b0;
    model = 0;

    for (cycle = 0; cycle < 600; cycle = cycle + 1) begin
      tick = $random;
      // A reset in the middle of the test.
      rst = (cycle == 300);
      @(negedge clk);
      if (rst)       model = 0;
      else if (tick) model = (model + 1) % 256;
      if (count !== model) begin
        if (errors < 10)
          $display("ERROR at cycle %0d: count=%0d, expected %0d", cycle, count, model);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_event_counter");
      $finish;
    end else begin
      $display("FAIL: tb_event_counter (%0d errors)", errors);
      $fatal(1, "tb_event_counter failed");
    end
  end

endmodule
