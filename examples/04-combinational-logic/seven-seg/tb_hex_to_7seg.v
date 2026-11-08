// tb_hex_to_7seg.v - checks the decoder against segment lists.
//
// For a lookup table, the reference must come from an independent source.
// Here we describe each digit by the NAMES of its lit segments (a string
// like "abcdef"), and convert the string to bits in the testbench.
`timescale 1ns/1ps

module tb_hex_to_7seg;

  reg  [3:0] value;
  wire [6:0] seg;

  reg  [8*7:1] names;   // up to 7 characters
  reg  [6:0]   want;
  integer      errors;
  integer      i;
  integer      k;
  reg  [7:0]   ch;

  hex_to_7seg dut (
    .value (value),
    .seg   (seg)
  );

  initial begin
    $dumpfile("tb_hex_to_7seg.vcd");
    $dumpvars(0, tb_hex_to_7seg);
  end

  // Turn a string such as "abg" into a segment vector.
  task names_to_bits;
    begin
      want = 7'd0;
      for (k = 0; k < 7; k = k + 1) begin
        ch = names >> (8 * k);          // one character
        if (ch >= "a" && ch <= "g")
          want[ch - "a"] = 1'b1;
      end
    end
  endtask

  // Draw the digit in the log, so you can see it.
  task draw;
    begin
      $display("  %s ",   seg[0] ? " -- " : "    ");
      $display("  %s%s%s", seg[5] ? "|" : " ", "  ", seg[1] ? "|" : " ");
      $display("  %s ",   seg[6] ? " -- " : "    ");
      $display("  %s%s%s", seg[4] ? "|" : " ", "  ", seg[2] ? "|" : " ");
      $display("  %s ",   seg[3] ? " -- " : "    ");
    end
  endtask

  initial begin
    errors = 0;

    for (i = 0; i < 16; i = i + 1) begin
      value = i;
      case (i)
        0:  names = "abcdef";
        1:  names = "bc";
        2:  names = "abdeg";
        3:  names = "abcdg";
        4:  names = "bcfg";
        5:  names = "acdfg";
        6:  names = "acdefg";
        7:  names = "abc";
        8:  names = "abcdefg";
        9:  names = "abcdfg";
        10: names = "abcefg";
        11: names = "cdefg";
        12: names = "adef";
        13: names = "bcdeg";
        14: names = "adefg";
        default: names = "aefg";
      endcase
      names_to_bits;
      #5;
      if (i == 2) begin
        $display("This is how the digit 2 looks:");
        draw;
      end
      if (seg !== want) begin
        $display("ERROR: value=%h -> seg=%b, expected %b (%0s)", value, seg, want, names);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_hex_to_7seg");
      $finish;
    end else begin
      $display("FAIL: tb_hex_to_7seg (%0d errors)", errors);
      $fatal(1, "tb_hex_to_7seg failed");
    end
  end

endmodule
