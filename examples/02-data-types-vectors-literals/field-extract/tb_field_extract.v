// tb_field_extract.v - self-checking testbench for field_extract.
`timescale 1ns/1ps

module tb_field_extract;

  reg  [31:0] word;
  reg  [1:0]  byte_sel;
  wire [7:0]  byte_out;
  wire [31:0] swapped;
  wire        msb;
  wire [3:0]  top_nibble;

  reg  [7:0]  exp_byte;
  integer     errors;
  integer     t;
  integer     k;

  field_extract dut (
    .word       (word),
    .byte_sel   (byte_sel),
    .byte_out   (byte_out),
    .swapped    (swapped),
    .msb        (msb),
    .top_nibble (top_nibble)
  );

  initial begin
    $dumpfile("tb_field_extract.vcd");
    $dumpvars(0, tb_field_extract);
  end

  // check_byte: compare byte_out with the byte computed by shifting.
  // (A task is a reusable piece of testbench code. Chapter 09 explains it.)
  task check_byte;
    begin
      exp_byte = word >> (byte_sel * 8);   // the low 8 bits are kept
      if (byte_out !== exp_byte) begin
        $display("ERROR: word=%h sel=%0d -> byte_out=%h, expected %h",
                 word, byte_sel, byte_out, exp_byte);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;

    // A fixed, easy-to-read value first.
    word = 32'hDEAD_BEEF;   // underscores make long literals readable
    for (k = 0; k < 4; k = k + 1) begin
      byte_sel = k;
      #5 check_byte;
    end
    if (swapped !== 32'hEFBE_ADDE) begin
      $display("ERROR: swapped=%h, expected efbeadde", swapped);
      errors = errors + 1;
    end
    if (msb !== 1'b1 || top_nibble !== 4'hD) begin
      $display("ERROR: msb=%b top_nibble=%h, expected 1 and d", msb, top_nibble);
      errors = errors + 1;
    end

    // Then some random words. $random returns a 32-bit signed value.
    for (t = 0; t < 200; t = t + 1) begin
      word     = $random;
      byte_sel = $random;
      #5 check_byte;
      if (swapped[31:24] !== word[7:0] || swapped[7:0] !== word[31:24]) begin
        $display("ERROR: swap failed for %h -> %h", word, swapped);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_field_extract");
      $finish;
    end else begin
      $display("FAIL: tb_field_extract (%0d errors)", errors);
      $fatal(1, "tb_field_extract failed");
    end
  end

endmodule
