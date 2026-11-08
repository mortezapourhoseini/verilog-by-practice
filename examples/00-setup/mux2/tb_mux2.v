// tb_mux2.v - self-checking testbench for mux2.
//
// Every testbench in this repository follows the same five steps:
//   1. declare signals, 2. connect the DUT, 3. dump waveforms,
//   4. apply stimulus and check, 5. print PASS or FAIL.
`timescale 1ns/1ps

module tb_mux2;

  // 1. Signals. We drive the DUT inputs, so they are reg.
  //    The DUT drives y, so it is a wire.
  reg  a;
  reg  b;
  reg  sel;
  wire y;

  reg     expected;
  integer errors;
  integer i;

  // 2. Device under test (DUT). Always connect ports by name.
  mux2 dut (
    .a   (a),
    .b   (b),
    .sel (sel),
    .y   (y)
  );

  // 3. Waveform dump. Open tb_mux2.vcd with GTKWave after the run.
  initial begin
    $dumpfile("tb_mux2.vcd");
    $dumpvars(0, tb_mux2);
  end

  // 4. Stimulus and checks.
  initial begin
    errors = 0;

    // Try all 8 input combinations.
    for (i = 0; i < 8; i = i + 1) begin
      {sel, b, a} = i[2:0];
      #10;  // wait so the output can settle

      // The reference model uses gates, not "? :", so it is written
      // differently from the design. This makes the check more useful.
      expected = (a & ~sel) | (b & sel);

      // Use !== (not !=) so that x or z on y is also caught.
      if (y !== expected) begin
        $display("ERROR: a=%b b=%b sel=%b -> y=%b, expected %b",
                 a, b, sel, y, expected);
        errors = errors + 1;
      end
    end

    // 5. Report. $fatal makes vvp exit with a non-zero status.
    if (errors == 0) begin
      $display("PASS: tb_mux2");
      $finish;
    end else begin
      $display("FAIL: tb_mux2 (%0d errors)", errors);
      $fatal(1, "tb_mux2 failed");
    end
  end

endmodule
