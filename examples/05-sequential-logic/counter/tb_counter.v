// tb_counter.v - self-checking testbench with a cycle-by-cycle model.
//
// The model is a second counter inside the testbench. It is updated at
// the same clock edge, and the outputs are compared on every cycle.
`timescale 1ns/1ps

module tb_counter;

  reg        clk;
  reg        rst;
  reg        en;
  wire [3:0] count;
  wire       wrap;

  integer model;      // expected count
  integer wraps;      // number of wrap pulses seen
  integer errors;
  integer cycle;

  counter dut (
    .clk   (clk),
    .rst   (rst),
    .en    (en),
    .count (count),
    .wrap  (wrap)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_counter.vcd");
    $dumpvars(0, tb_counter);
  end

  // Reference model: updated at the same rising edge as the DUT,
  // using the input values that were stable before the edge.
  always @(posedge clk) begin
    if (rst)
      model <= 0;
    else if (en)
      model <= (model + 1) % 16;
  end

  // Check at every rising edge. At this moment the non-blocking updates
  // of the DUT and of the model have not happened yet, so both still show
  // the values of the cycle that just ended. The inputs were set at the
  // falling edge, so they are stable too. This makes the check race-free.
  always @(posedge clk) begin
    if (!rst) begin
      if (count !== model[3:0]) begin
        $display("ERROR at %0t: count=%0d, expected %0d", $time, count, model);
        errors = errors + 1;
      end
      if (wrap !== (en && model == 15)) begin
        $display("ERROR at %0t: wrap=%b with count=%0d en=%b", $time, wrap, count, en);
        errors = errors + 1;
      end
      if (wrap) wraps = wraps + 1;
    end
  end

  initial begin
    errors = 0;
    wraps  = 0;
    model  = 0;
    rst = 1'b1;
    en  = 1'b0;

    // Hold reset for two clock edges.
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Count for 40 cycles. Every 7th cycle, en is 0 (a pause).
    for (cycle = 0; cycle < 40; cycle = cycle + 1) begin
      en = (cycle % 7 != 6);
      @(negedge clk);
    end

    // A reset in the middle of counting.
    rst = 1'b1;
    @(negedge clk);
    rst = 1'b0;
    if (count !== 4'd0) begin
      $display("ERROR: count=%0d after reset", count);
      errors = errors + 1;
    end

    // Count exactly 16 steps: one full turn back to 0.
    en = 1'b1;
    repeat (16) @(negedge clk);
    if (count !== 4'd0) begin
      $display("ERROR: count=%0d after 16 steps, expected 0", count);
      errors = errors + 1;
    end

    $display("Saw %0d wrap pulses", wraps);
    if (wraps != 3) begin
      $display("ERROR: expected 3 wrap pulses");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_counter");
      $finish;
    end else begin
      $display("FAIL: tb_counter (%0d errors)", errors);
      $fatal(1, "tb_counter failed");
    end
  end

endmodule
