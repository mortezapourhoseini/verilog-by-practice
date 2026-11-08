// tb_vending.v - random coins, a money model and protocol checks.
`timescale 1ns/1ps

module tb_vending;

  reg  clk;
  reg  rst;
  reg  coin5;
  reg  coin10;
  wire vend;
  wire change;

  integer credit;      // money inserted and not yet used (model)
  integer paid;        // total money inserted
  integer drinks;
  integer returned;
  integer errors;
  integer k;
  reg     expect_vend;
  reg     expect_change;

  vending dut (
    .clk    (clk),
    .rst    (rst),
    .coin5  (coin5),
    .coin10 (coin10),
    .vend   (vend),
    .change (change)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_vending.vcd");
    $dumpvars(0, tb_vending);
  end

  // At each rising edge: check outputs against what the model expects for
  // this cycle, then process the coin of this cycle.
  always @(posedge clk) begin
    if (!rst) begin
      if (vend !== expect_vend || change !== expect_change) begin
        $display("ERROR at %0t: vend=%b change=%b, expected %b %b",
                 $time, vend, change, expect_vend, expect_change);
        errors = errors + 1;
      end
      if (vend)   drinks   = drinks + 1;
      if (change) returned = returned + 5;

      expect_vend   = 1'b0;
      expect_change = 1'b0;
      if (coin5)  begin credit = credit + 5;  paid = paid + 5;  end
      if (coin10) begin credit = credit + 10; paid = paid + 10; end
      if (credit >= 15) begin
        expect_vend   = 1'b1;
        expect_change = (credit == 20);
        credit = 0;
      end
    end
  end

  initial begin
    errors = 0; credit = 0; paid = 0; drinks = 0; returned = 0;
    expect_vend = 1'b0; expect_change = 1'b0;
    rst = 1'b1; coin5 = 1'b0; coin10 = 1'b0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    for (k = 0; k < 500; k = k + 1) begin
      coin5  = 1'b0;
      coin10 = 1'b0;
      // No coin in the vend cycle (see the README).
      if (!expect_vend) begin
        case ($unsigned($random) % 3)
          0: coin5  = 1'b1;
          1: coin10 = 1'b1;
          default: ;   // no coin this cycle
        endcase
      end
      @(negedge clk);
      if (expect_vend) begin
        coin5 = 1'b0; coin10 = 1'b0;
        @(negedge clk);
      end
    end
    coin5 = 1'b0; coin10 = 1'b0;
    repeat (3) @(negedge clk);

    // Money check: paid = 15 per drink + change + credit still inside.
    $display("paid %0d, drinks %0d, change %0d, credit left %0d",
             paid, drinks, returned, credit);
    if (paid != 15 * drinks + returned + credit) begin
      $display("ERROR: the money does not add up");
      errors = errors + 1;
    end
    if (drinks == 0) begin
      $display("ERROR: no drink was ever given");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_vending");
      $finish;
    end else begin
      $display("FAIL: tb_vending (%0d errors)", errors);
      $fatal(1, "tb_vending failed");
    end
  end

endmodule
