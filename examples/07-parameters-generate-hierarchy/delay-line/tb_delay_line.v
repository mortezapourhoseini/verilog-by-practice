// tb_delay_line.v - three instances with different parameters.
`timescale 1ns/1ps

module tb_delay_line;

  reg        clk;
  reg  [7:0] din;
  wire [7:0] dout0;
  wire [7:0] dout3;
  wire [3:0] dout5;

  reg  [7:0] hist [0:5];   // hist[k] = input sampled k edges ago (k >= 1)
  integer    errors;
  integer    cycle;
  integer    k;

  delay_line #(.WIDTH(8), .DEPTH(0)) d0 (.clk(clk), .din(din),      .dout(dout0));
  delay_line #(.WIDTH(8), .DEPTH(3)) d3 (.clk(clk), .din(din),      .dout(dout3));
  delay_line #(.WIDTH(4), .DEPTH(5)) d5 (.clk(clk), .din(din[3:0]), .dout(dout5));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_delay_line.vcd");
    $dumpvars(0, tb_delay_line);
  end

  initial begin
    errors = 0;
    for (k = 0; k <= 5; k = k + 1) hist[k] = 8'hxx;

    for (cycle = 0; cycle < 40; cycle = cycle + 1) begin
      din = $random;
      #1;
      if (dout0 !== din) begin
        $display("ERROR: DEPTH=0 must be a wire: dout0=%h din=%h", dout0, din);
        errors = errors + 1;
      end
      @(posedge clk);
      // Shift the history at the edge (the DUT samples din now).
      for (k = 5; k >= 1; k = k - 1) hist[k] = hist[k-1];
      hist[1] = din;
      @(negedge clk);
      if (cycle >= 5) begin
        if (dout3 !== hist[3]) begin
          $display("ERROR: DEPTH=3: dout3=%h, expected %h", dout3, hist[3]);
          errors = errors + 1;
        end
        if (dout5 !== hist[5][3:0]) begin
          $display("ERROR: DEPTH=5: dout5=%h, expected %h", dout5, hist[5][3:0]);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_delay_line");
      $finish;
    end else begin
      $display("FAIL: tb_delay_line (%0d errors)", errors);
      $fatal(1, "tb_delay_line failed");
    end
  end

endmodule
