// tb_delays.v - a short pulse and a long pulse through three delay styles.
`timescale 1ns/1ps

module tb_delays;

  reg  a;
  wire y_inertial;
  wire y_transport;
  wire y_blocked;

  integer errors;
  integer pulses_inertial;
  integer pulses_transport;

  delays dut (
    .a           (a),
    .y_inertial  (y_inertial),
    .y_transport (y_transport),
    .y_blocked   (y_blocked)
  );

  initial begin
    $dumpfile("tb_delays.vcd");
    $dumpvars(0, tb_delays);
  end

  always @(posedge y_inertial)  pulses_inertial  = pulses_inertial + 1;
  always @(posedge y_transport) pulses_transport = pulses_transport + 1;

  initial begin
    errors = 0;
    pulses_inertial = 0;
    pulses_transport = 0;
    a = 1'b0;
    #20;

    // A 2 ns pulse at t = 20: shorter than the 5 ns delay.
    a = 1'b1; #2 a = 1'b0;
    #20;
    // A 10 ns pulse at t = 42: longer than the delay.
    a = 1'b1; #10 a = 1'b0;
    #20;

    $display("short and long pulse: inertial saw %0d, transport saw %0d",
             pulses_inertial, pulses_transport);
    if (pulses_inertial != 1) begin
      $display("ERROR: the inertial delay should swallow the short pulse");
      errors = errors + 1;
    end
    if (pulses_transport != 2) begin
      $display("ERROR: the transport delay should pass both pulses");
      errors = errors + 1;
    end

    // The sleeping block: at t = 20 it woke up, slept until 25 and then
    // sampled a = 0. The short pulse never reached y_blocked.
    $display("y_blocked is %b at the end", y_blocked);
    if (y_blocked !== 1'b0) errors = errors + 1;

    if (errors == 0) begin
      $display("PASS: tb_delays");
      $finish;
    end else begin
      $display("FAIL: tb_delays (%0d errors)", errors);
      $fatal(1, "tb_delays failed");
    end
  end

endmodule
