// tb_fifo8.v - directed full/empty tests and random traffic with a queue model.
`timescale 1ns/1ps

module tb_fifo8;

  reg        clk;
  reg        rst;
  reg        wr_en;
  reg  [7:0] din;
  reg        rd_en;
  wire [7:0] dout;
  wire       full;
  wire       empty;
  wire [3:0] count;

  // Queue model: q[head] is the oldest entry.
  reg  [7:0] q [0:15];
  integer    head;
  integer    size;
  integer    tail;
  integer    do_read;
  integer    do_write;
  reg  [7:0] exp_dout;
  integer    errors;
  integer    t;
  integer    k;

  fifo8 dut (
    .clk   (clk),
    .rst   (rst),
    .wr_en (wr_en),
    .din   (din),
    .rd_en (rd_en),
    .dout  (dout),
    .full  (full),
    .empty (empty),
    .count (count)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_fifo8.vcd");
    $dumpvars(0, tb_fifo8);
  end

  // At each edge: check the flags (they describe the state before the
  // edge), then update the model in the same way as the FIFO rules.
  always @(posedge clk) begin
    if (rst) begin
      head = 0;
      size = 0;
      exp_dout = 8'd0;
    end else begin
      if (count !== size || full !== (size == 8) || empty !== (size == 0)) begin
        if (errors < 10)
          $display("ERROR at %0t: count=%0d full=%b empty=%b, model size=%0d",
                   $time, count, full, empty, size);
        errors = errors + 1;
      end
      // Decide both operations from the state BEFORE the edge.
      do_read  = rd_en && (size > 0);
      do_write = wr_en && (size < 8);
      tail     = head + size;           // where a new entry goes
      if (do_write)
        q[tail % 16] = din;
      if (do_read) begin
        exp_dout = q[head % 16];
        head = head + 1;
      end
      size = size + do_write - do_read;
    end
  end

  // dout is checked half a cycle after the edge.
  always @(negedge clk) begin
    if (!rst && dout !== exp_dout) begin
      if (errors < 10)
        $display("ERROR at %0t: dout=%h, expected %h", $time, dout, exp_dout);
      errors = errors + 1;
    end
  end

  initial begin
    errors = 0; head = 0; size = 0; exp_dout = 0;
    rst = 1'b1; wr_en = 1'b0; rd_en = 1'b0; din = 8'd0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // 1. Write 10 values: the last 2 must be ignored (full).
    for (k = 0; k < 10; k = k + 1) begin
      wr_en = 1'b1; din = 8'h10 + k;
      @(negedge clk);
    end
    wr_en = 1'b0;
    if (!full) begin
      $display("ERROR: FIFO should be full");
      errors = errors + 1;
    end

    // 2. Read 10 times: values 10..17 come out, then empty.
    for (k = 0; k < 10; k = k + 1) begin
      rd_en = 1'b1;
      @(negedge clk);
      if (k < 8) $display("read %0d: %h", k, dout);
    end
    rd_en = 1'b0;
    if (!empty) begin
      $display("ERROR: FIFO should be empty");
      errors = errors + 1;
    end

    // 3. Random traffic.
    for (t = 0; t < 3000; t = t + 1) begin
      wr_en = $random;
      rd_en = $random;
      din   = $random;
      @(negedge clk);
    end

    if (errors == 0) begin
      $display("PASS: tb_fifo8");
      $finish;
    end else begin
      $display("FAIL: tb_fifo8 (%0d errors)", errors);
      $fatal(1, "tb_fifo8 failed");
    end
  end

endmodule
