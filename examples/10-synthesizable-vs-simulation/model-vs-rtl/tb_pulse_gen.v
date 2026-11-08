// tb_pulse_gen.v - the RTL must behave exactly like the behavioural model.
`timescale 1ns/1ps

module tb_pulse_gen;

  reg  clk;
  reg  rst;
  wire pulse_model_out;
  wire pulse_rtl_out;

  integer errors;
  integer pulses;
  integer cycle;

  pulse_model #(.PERIOD(8)) u_model (.clk(clk), .rst(rst), .pulse(pulse_model_out));
  pulse_rtl   #(.PERIOD(8)) u_rtl   (.clk(clk), .rst(rst), .pulse(pulse_rtl_out));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_pulse_gen.vcd");
    $dumpvars(0, tb_pulse_gen);
  end

  initial begin
    errors = 0;
    pulses = 0;
    rst = 1'b1;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Compare at every falling edge: both outputs are stable then.
    for (cycle = 0; cycle < 100; cycle = cycle + 1) begin
      @(negedge clk);
      if (pulse_rtl_out !== pulse_model_out) begin
        $display("ERROR at %0t: rtl=%b model=%b", $time, pulse_rtl_out, pulse_model_out);
        errors = errors + 1;
      end
      if (pulse_rtl_out) pulses = pulses + 1;
    end

    $display("%0d pulses in 100 cycles (expected 12)", pulses);
    if (pulses != 12) errors = errors + 1;

    if (errors == 0) begin
      $display("PASS: tb_pulse_gen");
      $finish;
    end else begin
      $display("FAIL: tb_pulse_gen (%0d errors)", errors);
      $fatal(1, "tb_pulse_gen failed");
    end
  end

endmodule
