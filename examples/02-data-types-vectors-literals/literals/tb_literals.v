// tb_literals.v - checks of Verilog value rules (no design under test).
//
// Each check shows one rule from chapter 02. If a check fails, the rule
// in the text is wrong, so this file also tests the documentation.
// Read the comments and the expected values, then run it.
`timescale 1ns/1ps

module tb_literals;

  reg  [7:0]  r8;
  reg  [3:0]  r4;
  reg  [31:0] r32;
  reg  signed [7:0] s8;
  integer     i;
  reg  [8*5:1] text;   // 5 characters, 8 bits each

  integer errors;

  // expect: compare a value with the expected value, using === so that
  // x and z must match exactly.
  task expect8;
    input [7:0]   got;
    input [7:0]   want;
    input [8*40:1] what;
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
    $dumpfile("tb_literals.vcd");
    $dumpvars(0, tb_literals);
  end

  initial begin
    errors = 0;

    // 1. Sized literals: <size>'<base><digits>
    r8 = 8'b1010_0101;  expect8(r8, 8'hA5, "8'b1010_0101");
    r8 = 8'd165;        expect8(r8, 8'hA5, "8'd165");
    r8 = 8'o245;        expect8(r8, 8'hA5, "8'o245");

    // 2. A smaller value is extended with zeros on the left.
    r8 = 4'hF;          expect8(r8, 8'b0000_1111, "4'hF into 8 bits");

    // 3. A larger value is truncated: the high bits are lost.
    r32 = 32'h1234_5678;
    r8  = r32;          expect8(r8, 8'h78, "32'h12345678 into 8 bits");

    // 4. x and z in literals. If the leftmost digit is x or z,
    //    the literal is filled with x or z up to its size.
    r8 = 8'bx;          expect8(r8, 8'bxxxx_xxxx, "8'bx");
    r8 = 8'bz1;         expect8(r8, 8'bzzzz_zzz1, "8'bz1");
    r8 = 8'b1x;         expect8(r8, 8'b0000_001x, "8'b1x (left digit 1)");
    // ...but a 4-bit x assigned to 8 bits gets zero-extended.
    r8 = 4'bx;          expect8(r8, 8'b0000_xxxx, "4'bx into 8 bits");

    // 5. A negative literal is stored in two's complement.
    r8 = -8'd5;         expect8(r8, 8'hFB, "-8'd5");

    // 6. integer is a 32-bit signed variable.
    i = -1;
    r8 = i[31:24];      expect8(r8, 8'hFF, "integer -1, top byte");

    // 7. signed vectors: the MSB is the sign bit.
    s8 = -8'sd100;
    r8 = s8;            expect8(r8, 8'h9C, "-100 as signed 8-bit");
    r8 = (s8 < 0) ? 8'd1 : 8'd0;
                        expect8(r8, 8'd1, "signed -100 < 0");

    // 8. Bit select, part select and indexed part select.
    r32 = 32'hCAFE_F00D;
    r8 = r32[31:24];    expect8(r8, 8'hCA, "r32[31:24]");
    r8 = r32[8 +: 8];   expect8(r8, 8'hF0, "r32[8 +: 8] = r32[15:8]");
    r8 = r32[23 -: 8];  expect8(r8, 8'hFE, "r32[23 -: 8] = r32[23:16]");
    r8 = r32[0];        expect8(r8, 8'd1, "r32[0]");

    // 9. Strings are vectors of 8-bit ASCII codes. The last character
    //    is in the lowest 8 bits.
    text = "hello";
    r8 = text[8:1];     expect8(r8, "o", "last char of \"hello\"");
    r8 = text[40:33];   expect8(r8, "h", "first char of \"hello\"");

    // 10. x in logic. 0 AND x = 0, 1 OR x = 1, but 1 AND x = x.
    r4 = {1'bx & 1'b0, 1'bx | 1'b1, 1'bx & 1'b1, ~1'bz};
    r8 = r4;            expect8(r8, 8'b0000_01xx, "x in & and |");

    // 11. == with x gives x. === compares x and z exactly.
    r4 = 4'b10x1;
    r8 = (r4 == 4'b10x1);   expect8(r8, 8'b0000_000x, "4'b10x1 == 4'b10x1");
    r8 = (r4 === 4'b10x1);  expect8(r8, 8'd1, "4'b10x1 === 4'b10x1");

    // 12. An if with an x condition takes the else branch.
    if (1'bx) r8 = 8'd1; else r8 = 8'd2;
                            expect8(r8, 8'd2, "if (x) goes to else");

    // 13. A reg starts as x in simulation, until something writes it.
    //     (Real hardware starts with an unknown 0 or 1.)

    if (errors == 0) begin
      $display("PASS: tb_literals");
      $finish;
    end else begin
      $display("FAIL: tb_literals (%0d errors)", errors);
      $fatal(1, "tb_literals failed");
    end
  end

endmodule
