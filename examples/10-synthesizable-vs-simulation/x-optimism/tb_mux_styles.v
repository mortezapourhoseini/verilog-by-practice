// tb_mux_styles.v - the same select value x, three different simulation results.
// PASSES when each style behaves as described in chapter 10.
`timescale 1ns/1ps

module tb_mux_styles;

  reg        sel;
  reg  [7:0] a;
  reg  [7:0] b;
  wire [7:0] y_if;
  wire [7:0] y_ternary;
  wire [7:0] y_case;

  integer errors;

  mux_if      u_if      (.sel(sel), .a(a), .b(b), .y(y_if));
  mux_ternary u_ternary (.sel(sel), .a(a), .b(b), .y(y_ternary));
  mux_case    u_case    (.sel(sel), .a(a), .b(b), .y(y_case));

  initial begin
    $dumpfile("tb_mux_styles.vcd");
    $dumpvars(0, tb_mux_styles);
  end

  task expect8;
    input [7:0]    got;
    input [7:0]    want;
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
    errors = 0;
    a = 8'b1111_0000;
    b = 8'b1111_1111;

    // Known select: all three agree.
    sel = 1'b1; #1;
    expect8(y_if,      a, "sel=1, if/else");
    expect8(y_ternary, a, "sel=1, ? :");
    expect8(y_case,    a, "sel=1, case");

    // Unknown select, for example a register without reset.
    sel = 1'bx; #1;
    expect8(y_if,      8'b1111_1111, "sel=x, if/else (x hidden!)");
    expect8(y_ternary, 8'b1111_xxxx, "sel=x, ? : (bits merged)");
    expect8(y_case,    8'bxxxx_xxxx, "sel=x, case with x default");

    if (errors == 0) begin
      $display("PASS: tb_mux_styles");
      $finish;
    end else begin
      $display("FAIL: tb_mux_styles (%0d errors)", errors);
      $fatal(1, "tb_mux_styles failed");
    end
  end

endmodule
