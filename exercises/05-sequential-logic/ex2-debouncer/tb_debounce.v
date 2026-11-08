// tb_debounce.v - bouncing button presses and a cycle-accurate model.
`timescale 1ns/1ps

module tb_debounce;

  reg  clk;
  reg  rst;
  reg  btn_in;
  wire btn_out;

  reg     model_out;
  integer model_cnt;
  integer changes;     // how often btn_out changed
  integer errors;
  integer press;
  integer k;

  debounce dut (
    .clk     (clk),
    .rst     (rst),
    .btn_in  (btn_in),
    .btn_out (btn_out)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_debounce.vcd");
    $dumpvars(0, tb_debounce);
  end

  // Model of the four rules. Compare first (old values), then update.
  always @(posedge clk) begin
    if (!rst && btn_out !== model_out) begin
      if (errors < 10)
        $display("ERROR at %0t: btn_out=%b, expected %b", $time, btn_out, model_out);
      errors = errors + 1;
    end
    if (rst) begin
      model_out = 1'b0;
      model_cnt = 0;
    end else if (btn_in == model_out) begin
      model_cnt = 0;
    end else if (model_cnt == 3) begin
      model_out = btn_in;
      model_cnt = 0;
    end else begin
      model_cnt = model_cnt + 1;
    end
  end

  always @(btn_out) if (!rst) changes = changes + 1;

  // One button press: some bounces, a stable phase, bounces, release.
  task press_button;
    input integer bounces;
    input integer hold;
    begin
      for (k = 0; k < bounces; k = k + 1) begin
        btn_in = ~btn_in;
        repeat (1 + ($unsigned($random) % 3)) @(negedge clk);   // 1 to 3 cycles
      end
      btn_in = 1'b1;
      repeat (hold) @(negedge clk);
      for (k = 0; k < bounces; k = k + 1) begin
        btn_in = ~btn_in;
        repeat (1 + ($unsigned($random) % 3)) @(negedge clk);
      end
      btn_in = 1'b0;
      repeat (hold) @(negedge clk);
    end
  endtask

  initial begin
    errors = 0;
    changes = 0;
    model_out = 1'b0;
    model_cnt = 0;
    rst = 1'b1;
    btn_in = 1'b0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Ten presses. Bounces last at most 3 cycles each, so they never
    // reach STABLE = 4. The hold phase (10 cycles) does.
    for (press = 0; press < 10; press = press + 1)
      press_button(5, 10);

    // Each press must give exactly one rise and one fall.
    $display("btn_out changed %0d times for 10 presses", changes);
    if (changes != 20) begin
      $display("ERROR: expected 20 changes (one press and one release each)");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_debounce");
      $finish;
    end else begin
      $display("FAIL: tb_debounce (%0d errors)", errors);
      $fatal(1, "tb_debounce failed");
    end
  end

endmodule
