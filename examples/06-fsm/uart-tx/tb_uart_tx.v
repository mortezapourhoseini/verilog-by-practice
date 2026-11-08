// tb_uart_tx.v - a UART receiver model decodes the tx line.
`timescale 1ns/1ps

module tb_uart_tx;

  localparam CLKS_PER_BIT = 8;
  localparam CLK_PERIOD   = 10;                         // ns
  localparam BIT_TIME     = CLKS_PER_BIT * CLK_PERIOD;  // ns

  reg        clk;
  reg        rst;
  reg        start;
  reg  [7:0] data;
  wire       tx;
  wire       busy;

  reg  [7:0] sent   [0:7];
  reg  [7:0] rx_byte;
  integer    n_sent;
  integer    n_recv;
  integer    errors;
  integer    k;
  integer    b;

  uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) dut (
    .clk   (clk),
    .rst   (rst),
    .start (start),
    .data  (data),
    .tx    (tx),
    .busy  (busy)
  );

  initial clk = 1'b0;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("tb_uart_tx.vcd");
    $dumpvars(0, tb_uart_tx);
  end

  // Receiver model. It only looks at the tx line, like a real receiver:
  // wait for the falling start edge, go to the middle of the start bit,
  // then sample every BIT_TIME.
  initial begin
    n_recv = 0;
    forever begin
      @(negedge tx);
      #(BIT_TIME / 2);
      if (tx !== 1'b0) begin
        $display("ERROR at %0t: start bit is not 0 in its middle", $time);
        errors = errors + 1;
      end
      for (b = 0; b < 8; b = b + 1) begin
        #(BIT_TIME);
        rx_byte[b] = tx;              // LSB first
      end
      #(BIT_TIME);
      if (tx !== 1'b1) begin
        $display("ERROR at %0t: stop bit is not 1", $time);
        errors = errors + 1;
      end
      if (rx_byte !== sent[n_recv]) begin
        $display("ERROR: received %h, expected %h", rx_byte, sent[n_recv]);
        errors = errors + 1;
      end else begin
        $display("received byte %0d: %h", n_recv, rx_byte);
      end
      n_recv = n_recv + 1;
    end
  end

  // Send one byte: pulse start for one cycle, then wait until not busy.
  task send;
    input [7:0] value;
    begin
      @(negedge clk);
      sent[n_sent] = value;
      n_sent = n_sent + 1;
      data  = value;
      start = 1'b1;
      @(negedge clk);
      start = 1'b0;
      data  = 8'hxx;     // the DUT must have captured the data already
      while (busy) @(negedge clk);
    end
  endtask

  initial begin
    errors = 0; n_sent = 0;
    rst = 1'b1; start = 1'b0; data = 8'h00;
    repeat (3) @(negedge clk);
    rst = 1'b0;

    if (tx !== 1'b1) begin
      $display("ERROR: tx must be 1 when idle");
      errors = errors + 1;
    end

    send(8'h55);    // 0101_0101: alternating bits
    send(8'hA3);
    send(8'h00);
    send(8'hFF);
    for (k = 0; k < 4; k = k + 1)
      send($random);

    repeat (2 * CLKS_PER_BIT) @(negedge clk);

    if (n_recv != n_sent) begin
      $display("ERROR: sent %0d bytes, received %0d", n_sent, n_recv);
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_uart_tx");
      $finish;
    end else begin
      $display("FAIL: tb_uart_tx (%0d errors)", errors);
      $fatal(1, "tb_uart_tx failed");
    end
  end

endmodule
