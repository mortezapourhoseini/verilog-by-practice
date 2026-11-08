// tb_swap.v - shows the race between two blocking clocked blocks.
// PASSES when the non-blocking version swaps and the blocking version
// collapses to two equal values (as chapter 11 explains).
`timescale 1ns/1ps

module tb_swap;

  reg        clk;
  reg        load;
  wire [7:0] nb_a, nb_b;
  wire [7:0] bl_a, bl_b;

  integer errors;
  integer k;

  swap_nonblocking u_nb (.clk(clk), .load(load), .init_a(8'h11), .init_b(8'h22), .a(nb_a), .b(nb_b));
  swap_blocking    u_bl (.clk(clk), .load(load), .init_a(8'h11), .init_b(8'h22), .a(bl_a), .b(bl_b));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_swap.vcd");
    $dumpvars(0, tb_swap);
  end

  initial begin
    errors = 0;
    load = 1'b1;
    @(negedge clk);
    load = 1'b0;
    $display("after load:      non-blocking a=%h b=%h   blocking a=%h b=%h", nb_a, nb_b, bl_a, bl_b);

    for (k = 1; k <= 4; k = k + 1) begin
      @(negedge clk);
      $display("after swap %0d:    non-blocking a=%h b=%h   blocking a=%h b=%h", k, nb_a, nb_b, bl_a, bl_b);
      // Non-blocking: a real swap. Odd steps: a = 22, even steps: a = 11.
      if (nb_a !== ((k % 2) ? 8'h22 : 8'h11) || nb_b !== ((k % 2) ? 8'h11 : 8'h22)) begin
        $display("ERROR: the non-blocking version did not swap");
        errors = errors + 1;
      end
      // Blocking: both registers hold the same value. Which one is a
      // simulator decision, so we do not check the value itself.
      if (bl_a !== bl_b) begin
        $display("ERROR: expected the blocking version to collapse (a == b)");
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_swap");
      $finish;
    end else begin
      $display("FAIL: tb_swap (%0d errors)", errors);
      $fatal(1, "tb_swap failed");
    end
  end

endmodule
