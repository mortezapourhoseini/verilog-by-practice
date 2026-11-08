// tb_pipeline3.v - shows the difference between <= and = in clocked blocks.
//
// The testbench PASSES when both versions behave as chapter 05 explains:
// the non-blocking version delays by 3 cycles, the blocking one by 1.
`timescale 1ns/1ps

module tb_pipeline3;

  reg        clk;
  reg  [7:0] d;
  wire [7:0] nb_q1, nb_q2, nb_q3;
  wire [7:0] b_q1,  b_q2,  b_q3;

  reg  [7:0] history [0:3];   // the last four input values
  integer    errors;
  integer    cycle;

  pipeline3_nb u_nb (.clk(clk), .d(d), .q1(nb_q1), .q2(nb_q2), .q3(nb_q3));
  pipeline3_b  u_b  (.clk(clk), .d(d), .q1(b_q1),  .q2(b_q2),  .q3(b_q3));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_pipeline3.vcd");
    $dumpvars(0, tb_pipeline3);
  end

  initial begin
    errors = 0;

    for (cycle = 0; cycle < 12; cycle = cycle + 1) begin
      @(negedge clk);
      // history[0] is the value sampled at the last edge, history[2]
      // the value sampled three edges ago.
      if (cycle >= 4) begin
        if (nb_q3 !== history[2]) begin
          $display("ERROR: non-blocking q3=%0d, expected %0d", nb_q3, history[2]);
          errors = errors + 1;
        end
        if (b_q3 !== history[0]) begin
          $display("ERROR: blocking q3=%0d, expected %0d", b_q3, history[0]);
          errors = errors + 1;
        end
      end
      $display("cycle %2d: d(sampled)=%3d   non-blocking q1,q2,q3 = %3d %3d %3d   blocking = %3d %3d %3d",
               cycle, history[0], nb_q1, nb_q2, nb_q3, b_q1, b_q2, b_q3);
      // New input for the next edge.
      d = 10 * (cycle + 1);
      history[3] = history[2];
      history[2] = history[1];
      history[1] = history[0];
      history[0] = d;
    end

    if (errors == 0) begin
      $display("PASS: tb_pipeline3");
      $finish;
    end else begin
      $display("FAIL: tb_pipeline3 (%0d errors)", errors);
      $fatal(1, "tb_pipeline3 failed");
    end
  end

endmodule
