// tb_alu8.v - self-checking testbench for alu8.
//
// The reference model uses integer arithmetic and simple bit tricks,
// not the same operators as the design. If both agree, we can trust them.
`timescale 1ns/1ps

module tb_alu8;

  reg  [7:0] a;
  reg  [7:0] b;
  reg  [3:0] op;
  wire [7:0] y;
  wire       carry;
  wire       zero;

  reg  [7:0] want_y;
  reg        want_c;
  integer    sa;        // a as a signed integer
  integer    sb;        // b as a signed integer
  integer    sh;        // shift amount
  integer    errors;
  integer    t;
  integer    k;

  alu8 dut (
    .a     (a),
    .b     (b),
    .op    (op),
    .y     (y),
    .carry (carry),
    .zero  (zero)
  );

  initial begin
    $dumpfile("tb_alu8.vcd");
    $dumpvars(0, tb_alu8);
  end

  // Compute the expected result for the current a, b and op.
  task model;
    begin
      sa = a[7] ? a - 256 : a;   // two's complement value
      sb = b[7] ? b - 256 : b;
      sh = b % 8;
      want_c = 1'b0;
      case (op)
        4'd0: begin want_y = (a + b) % 256; want_c = (a + b) > 255; end
        4'd1: begin want_y = (a - b + 256) % 256; want_c = (a < b); end
        4'd2: want_y = a & b;
        4'd3: want_y = a | b;
        4'd4: want_y = a ^ b;
        4'd5: want_y = ~(a | b);
        4'd6: want_y = (a * (1 << sh)) % 256;
        4'd7: want_y = a / (1 << sh);
        // Arithmetic shift: logical shift, then put copies of the sign
        // bit into the top sh bits.
        4'd8: want_y = (a >> sh) | (a[7] ? ~(8'hFF >> sh) : 8'h00);
        4'd9: want_y = (sa < sb) ? 8'd1 : 8'd0;
        4'd10: want_y = (a < b) ? 8'd1 : 8'd0;
        default: want_y = 8'd0;
      endcase
    end
  endtask

  task check;
    begin
      #2;
      model;
      if (y !== want_y || carry !== want_c || zero !== (want_y == 8'd0)) begin
        if (errors < 10)
          $display("ERROR: op=%0d a=%h b=%h -> y=%h c=%b z=%b, expected y=%h c=%b",
                   op, a, b, y, carry, zero, want_y, want_c);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;

    // Corner cases for every operation: 0, 1, the largest positive (127),
    // the most negative (128 = -128 signed) and 255 (-1 signed).
    for (k = 0; k < 11; k = k + 1) begin
      op = k;
      a = 8'h00; b = 8'h00; check;
      a = 8'hFF; b = 8'h01; check;   // ADD overflows, SLT: -1 < 1
      a = 8'h7F; b = 8'h80; check;   // SLT: 127 < -128 is false
      a = 8'h80; b = 8'h07; check;   // SRA of a negative value
      a = 8'h03; b = 8'h05; check;   // SUB needs a borrow
    end

    // Random tests.
    for (t = 0; t < 3000; t = t + 1) begin
      a  = $random;
      b  = $random;
      op = $unsigned($random) % 11;
      check;
    end

    if (errors == 0) begin
      $display("PASS: tb_alu8");
      $finish;
    end else begin
      $display("FAIL: tb_alu8 (%0d errors)", errors);
      $fatal(1, "tb_alu8 failed");
    end
  end

endmodule
