// tb_up_down_counter8.v - random stimulus with a cycle-accurate model.
`timescale 1ns/1ps

module tb_up_down_counter8;

  reg        clk;
  reg        rst;
  reg        load;
  reg  [7:0] load_value;
  reg        en;
  reg        up;
  wire [7:0] count;

  integer model;
  integer errors;
  integer cycle;

  up_down_counter8 dut (
    .clk        (clk),
    .rst        (rst),
    .load       (load),
    .load_value (load_value),
    .en         (en),
    .up         (up),
    .count      (count)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_up_down_counter8.vcd");
    $dumpvars(0, tb_up_down_counter8);
  end

  // Compare at the rising edge (before the update), then update the model.
  always @(posedge clk) begin
    if (cycle > 0 && count !== model[7:0]) begin
      if (errors < 10)
        $display("ERROR at %0t: count=%0d, expected %0d", $time, count, model);
      errors = errors + 1;
    end
    if (rst)            model = 0;
    else if (load)      model = load_value;
    else if (en && up)  model = (model + 1) % 256;
    else if (en)        model = (model + 255) % 256;
  end

  initial begin
    errors = 0;
    model  = 0;
    cycle  = 0;
    rst = 1'b1; load = 1'b0; load_value = 8'd0; en = 1'b0; up = 1'b1;
    @(negedge clk);
    rst = 1'b0;

    // Directed: count down from 0 must wrap to 255.
    en = 1'b1; up = 1'b0;
    cycle = 1;
    @(negedge clk);
    if (count !== 8'd255) begin
      $display("ERROR: 0 - 1 gave %0d, expected 255", count);
      errors = errors + 1;
    end

    // Random: 2000 cycles of random control inputs.
    for (cycle = 1; cycle < 2000; cycle = cycle + 1) begin
      rst        = ($random % 50) == 0;   // rare
      load       = ($random % 10) == 0;
      load_value = $random;
      en         = ($random % 4) != 0;
      up         = $random;
      @(negedge clk);
    end

    if (errors == 0) begin
      $display("PASS: tb_up_down_counter8");
      $finish;
    end else begin
      $display("FAIL: tb_up_down_counter8 (%0d errors)", errors);
      $fatal(1, "tb_up_down_counter8 failed");
    end
  end

endmodule
