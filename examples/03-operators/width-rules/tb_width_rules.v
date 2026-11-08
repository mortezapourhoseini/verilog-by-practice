// tb_width_rules.v - checks of operator, width and sign rules (no DUT).
//
// Each check matches one rule in chapter 03. Read the comment, guess the
// result, then look at the expected value.
`timescale 1ns/1ps

module tb_width_rules;

  reg  [3:0] a4;
  reg  [3:0] b4;
  reg  [3:0] r4;
  reg  [4:0] r5;
  reg  [7:0] u8;
  reg  [7:0] r8;
  reg  signed [7:0] s8;
  reg  signed [15:0] s16;
  reg  [15:0] u16;
  integer    i;
  integer    errors;

  task expect8;
    input [7:0]    got;
    input [7:0]    want;
    input [8*44:1] what;
    begin
      if (got !== want) begin
        $display("ERROR: %0s: got %b, expected %b", what, got, want);
        errors = errors + 1;
      end else begin
        $display("ok    %0s = %b", what, got);
      end
    end
  endtask

  initial begin
    $dumpfile("tb_width_rules.vcd");
    $dumpvars(0, tb_width_rules);
  end

  initial begin
    errors = 0;
    a4 = 4'd15;
    b4 = 4'd1;

    // 1. The result width is the width of the target: 15 + 1 = 0 in 4 bits.
    r4 = a4 + b4;                 expect8(r4, 8'd0,  "4-bit target: 15 + 1");
    // 2. A wider target keeps the carry: operands are extended first.
    r5 = a4 + b4;                 expect8(r5, 8'd16, "5-bit target: 15 + 1");
    // 3. The average bug. All operands are 4 bits, so 15 + 1 overflows
    //    before the shift...
    r4 = (a4 + b4) >> 1;          expect8(r4, 8'd0,  "4-bit (15 + 1) >> 1");
    //    ...unless one operand is 5 bits. Then the whole expression is 5 bits.
    r4 = ({1'b0, a4} + b4) >> 1;  expect8(r4, 8'd8,  "({0,15} + 1) >> 1");
    // 4. Unsigned subtraction wraps around.
    u8 = 8'd3 - 8'd5;             expect8(u8, 8'd254, "8'd3 - 8'd5");

    // 5. Bitwise versus logical operators.
    r8 = 4'b0101 &  4'b1010;      expect8(r8, 8'd0,  "4'b0101 &  4'b1010");
    r8 = 4'b0101 && 4'b1010;      expect8(r8, 8'd1,  "4'b0101 && 4'b1010");
    // Surprise: ~ is applied AFTER the operand is extended to the
    // target width (8 bits). So the four new zero bits become ones.
    r8 = ~4'b0101;                expect8(r8, 8'b1111_1010, "~4'b0101 into 8 bits");
    r8 = !4'b0101;                expect8(r8, 8'd0,  "!4'b0101 (1 bit)");

    // 6. Reduction operators make 1 bit from a vector.
    r8 = &4'b1111;                expect8(r8, 8'd1,  "&4'b1111 (AND of all)");
    r8 = |4'b0000;                expect8(r8, 8'd0,  "|4'b0000 (OR of all)");
    r8 = ^4'b0111;                expect8(r8, 8'd1,  "^4'b0111 (parity)");

    // 7. Replication.
    r8 = {3{2'b10}};              expect8(r8, 8'b0010_1010, "{3{2'b10}}");

    // 8. Shifts. >> fills with 0. >>> fills with the sign bit, but only
    //    when the operand is signed.
    u8 = 8'b1000_0000;
    s8 = 8'b1000_0000;
    r8 = u8 >> 1;                 expect8(r8, 8'b0100_0000, "unsigned >> 1");
    r8 = u8 >>> 1;                expect8(r8, 8'b0100_0000, "unsigned >>> 1");
    r8 = s8 >>> 1;                expect8(r8, 8'b1100_0000, "signed >>> 1");
    r8 = $signed(u8) >>> 1;       expect8(r8, 8'b1100_0000, "$signed(u8) >>> 1");
    r8 = 8'hFF << 8;              expect8(r8, 8'd0,  "8'hFF << 8");

    // 9. Signed and unsigned comparisons.
    u8 = 8'hFF;                   // 255 unsigned
    s8 = -8'sd1;                  // -1 signed, same bits
    r8 = (u8 < 0);                expect8(r8, 8'd0,  "unsigned 255 < 0");
    r8 = (s8 < 0);                expect8(r8, 8'd1,  "signed -1 < 0");
    // Mixing: if ANY operand is unsigned, the comparison is unsigned.
    // -1 becomes 255, and 255 < 1 is false.
    r8 = (s8 < 8'd1);             expect8(r8, 8'd0,  "signed -1 < unsigned 1");
    r8 = (s8 < 8'sd1);            expect8(r8, 8'd1,  "signed -1 < signed 1");

    // 10. Precedence: == binds tighter than &.
    //     a & b == c means a & (b == c).
    a4 = 4'b0010;
    b4 = 4'b0010;
    r4 = 4'b0010;
    r8 = (a4 & b4) == r4;         expect8(r8, 8'd1,  "(a & b) == c");
    r8 = a4 & b4 == r4;           expect8(r8, 8'd0,  "a & b == c  (no parens)");

    // 11. Integer division truncates toward zero. % keeps the sign of
    //     the left operand.
    i = -7 / 2;  r8 = i;          expect8(r8, -8'sd3, "-7 / 2");
    i = -7 % 2;  r8 = i;          expect8(r8, -8'sd1, "-7 % 2");

    // 12. Sign extension follows the signedness of the right side.
    s8  = -8'sd3;                 // 8'hFD
    s16 = s8;                     // signed -> sign-extended
    u16 = s8;                     // still sign-extended: the RIGHT side is signed
    if (s16 !== 16'hFFFD || u16 !== 16'hFFFD) begin
      $display("ERROR: sign extension: s16=%h u16=%h", s16, u16);
      errors = errors + 1;
    end else $display("ok    -3 into 16 bits = %h", s16);
    // One unsigned operand makes the whole expression unsigned:
    // s8 is zero-extended, so the result is 00FD + 1 = 00FE, not FFFE.
    s16 = s8 + 8'd1;
    if (s16 !== 16'h00FE) begin
      $display("ERROR: s8 + 8'd1 = %h, expected 00fe", s16);
      errors = errors + 1;
    end else $display("ok    signed -3 + unsigned 1 = %h (bug!)", s16);
    s16 = s8 + 8'sd1;
    if (s16 !== 16'hFFFE) begin
      $display("ERROR: s8 + 8'sd1 = %h, expected fffe", s16);
      errors = errors + 1;
    end else $display("ok    signed -3 + signed 1 = %h", s16);

    // 13. The conditional operator makes a multiplexer.
    r8 = (a4 > 4'd1) ? 8'd10 : 8'd20;  expect8(r8, 8'd10, "(2 > 1) ? 10 : 20");

    if (errors == 0) begin
      $display("PASS: tb_width_rules");
      $finish;
    end else begin
      $display("FAIL: tb_width_rules (%0d errors)", errors);
      $fatal(1, "tb_width_rules failed");
    end
  end

endmodule
