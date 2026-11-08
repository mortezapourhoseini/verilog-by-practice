// tb_pipe3.v - dout must equal the input from exactly three edges ago.
`timescale 1ns/1ps

module tb_pipe3;

  reg        clk;
  reg  [7:0] din;
  wire [7:0] dout;

  reg  [7:0] hist [1:3];   // hist[k]: input sampled k edges ago
  integer    errors;
  integer    cycle;

  pipe3 dut (.clk(clk), .din(din), .dout(dout));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_pipe3.vcd");
    $dumpvars(0, tb_pipe3);
  end

  initial begin
    errors = 0;
    din = 8'd0;
    for (cycle = 0; cycle < 50; cycle = cycle + 1) begin
      @(negedge clk);
      if (cycle >= 4 && dout !== hist[3]) begin
        if (errors < 5)
          $display("ERROR at cycle %0d: dout=%0d, expected %0d", cycle, dout, hist[3]);
        errors = errors + 1;
      end
      din = cycle + 1;
      // The DUT will sample this din at the next rising edge.
      hist[3] = hist[2];
      hist[2] = hist[1];
      hist[1] = din;
    end

    if (errors == 0) begin
      $display("PASS: tb_pipe3");
      $finish;
    end else begin
      $display("FAIL: tb_pipe3 (%0d errors)", errors);
      $fatal(1, "tb_pipe3 failed");
    end
  end

endmodule
