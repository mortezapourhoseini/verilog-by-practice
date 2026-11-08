// tb_regfile.v - random writes, two read ports, register 0 stays 0.
`timescale 1ns/1ps

module tb_regfile;

  reg        clk;
  reg        we;
  reg  [2:0] waddr;
  reg  [7:0] wdata;
  reg  [2:0] raddr_a;
  reg  [2:0] raddr_b;
  wire [7:0] rdata_a;
  wire [7:0] rdata_b;

  reg  [7:0] model [0:7];
  integer    errors;
  integer    t;
  integer    k;

  regfile dut (
    .clk     (clk),
    .we      (we),
    .waddr   (waddr),
    .wdata   (wdata),
    .raddr_a (raddr_a),
    .rdata_a (rdata_a),
    .raddr_b (raddr_b),
    .rdata_b (rdata_b)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_regfile.vcd");
    $dumpvars(0, tb_regfile);
  end

  // The model is updated at the clock edge, like the DUT.
  always @(posedge clk)
    if (we && waddr != 0) model[waddr] <= wdata;

  initial begin
    errors = 0;
    for (k = 0; k < 8; k = k + 1) model[k] = 8'd0;
    we = 1'b0; waddr = 0; wdata = 0; raddr_a = 0; raddr_b = 0;

    for (t = 0; t < 2000; t = t + 1) begin
      @(negedge clk);
      // Combinational read: check now, with the current addresses.
      raddr_a = $random;
      raddr_b = $random;
      #1;
      if (rdata_a !== model[raddr_a] || rdata_b !== model[raddr_b]) begin
        if (errors < 10)
          $display("ERROR: r%0d=%h r%0d=%h, expected %h %h",
                   raddr_a, rdata_a, raddr_b, rdata_b, model[raddr_a], model[raddr_b]);
        errors = errors + 1;
      end
      // Schedule a write for the next edge. Register 0 is a target too.
      we    = $random;
      waddr = $random;
      wdata = $random;
    end

    @(negedge clk);
    raddr_a = 3'd0;
    #1;
    if (rdata_a !== 8'd0) begin
      $display("ERROR: register 0 reads %h", rdata_a);
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_regfile");
      $finish;
    end else begin
      $display("FAIL: tb_regfile (%0d errors)", errors);
      $fatal(1, "tb_regfile failed");
    end
  end

endmodule
