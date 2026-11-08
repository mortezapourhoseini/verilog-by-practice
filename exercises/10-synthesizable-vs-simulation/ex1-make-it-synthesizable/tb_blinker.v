// tb_blinker.v - compares the RTL blinker with the behavioural model.
`timescale 1ns/1ps

module tb_blinker;

  localparam HALF = 5;

  reg  clk;
  reg  rst;
  wire led;
  reg  model_led;

  integer errors;
  integer toggles;
  integer cycle;

  blinker #(.HALF(HALF)) dut (.clk(clk), .rst(rst), .led(led));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_blinker.vcd");
    $dumpvars(0, tb_blinker);
  end

  // The behavioural model from the README (simulation only).
  initial begin
    model_led = 1'b0;
    @(negedge rst);
    forever begin
      repeat (HALF) @(posedge clk);
      #1 model_led = ~model_led;
    end
  end

  initial begin
    errors = 0;
    toggles = 0;
    rst = 1'b1;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    for (cycle = 0; cycle < 200; cycle = cycle + 1) begin
      @(negedge clk);
      if (led !== model_led) begin
        if (errors < 10)
          $display("ERROR at %0t: led=%b, model=%b", $time, led, model_led);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_blinker");
      $finish;
    end else begin
      $display("FAIL: tb_blinker (%0d errors)", errors);
      $fatal(1, "tb_blinker failed");
    end
  end

endmodule
