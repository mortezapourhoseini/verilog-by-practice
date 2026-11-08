// tb_light_decode.v - testbench for exercise 04.3.
//
// The input sequence is chosen so that a latch shows up: each step
// starts from a state where the "forgotten" output was 1.
`timescale 1ns/1ps

module tb_light_decode;

  reg  [1:0] state;
  reg        emergency;
  wire       red;
  wire       yellow;
  wire       green;

  reg  [2:0] want;   // {red, yellow, green}
  integer    errors;
  integer    i;
  integer    j;

  light_decode dut (
    .state     (state),
    .emergency (emergency),
    .red       (red),
    .yellow    (yellow),
    .green     (green)
  );

  initial begin
    $dumpfile("tb_light_decode.vcd");
    $dumpvars(0, tb_light_decode);
  end

  task apply;
    input       e;
    input [1:0] s;
    begin
      emergency = e;
      state     = s;
      #5;
      if (e)            want = 3'b100;
      else if (s == 0)  want = 3'b100;
      else if (s == 1)  want = 3'b001;
      else if (s == 2)  want = 3'b010;
      else              want = 3'b000;
      if ({red, yellow, green} !== want) begin
        $display("ERROR: emergency=%b state=%0d -> ryg=%b, expected %b",
                 e, s, {red, yellow, green}, want);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;

    // Every ordered pair of (emergency, state) inputs: 8 x 8 steps.
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
        apply(i[2], i[1:0]);
        apply(j[2], j[1:0]);
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_light_decode");
      $finish;
    end else begin
      $display("FAIL: tb_light_decode (%0d errors)", errors);
      $fatal(1, "tb_light_decode failed");
    end
  end

endmodule
