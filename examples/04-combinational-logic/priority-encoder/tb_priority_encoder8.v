// tb_priority_encoder8.v - exhaustive test of both encoder versions.
`timescale 1ns/1ps

module tb_priority_encoder8;

  reg  [7:0] req;
  wire [2:0] idx_loop;
  wire       valid_loop;
  wire [2:0] idx_casez;
  wire       valid_casez;

  reg  [2:0] want_idx;
  reg        want_valid;
  integer    errors;
  integer    i;
  integer    k;

  priority_encoder8 dut_loop (
    .req   (req),
    .idx   (idx_loop),
    .valid (valid_loop)
  );

  priority_encoder8_casez dut_casez (
    .req   (req),
    .idx   (idx_casez),
    .valid (valid_casez)
  );

  initial begin
    $dumpfile("tb_priority_encoder8.vcd");
    $dumpvars(0, tb_priority_encoder8);
  end

  initial begin
    errors = 0;

    for (i = 0; i < 256; i = i + 1) begin
      req = i[7:0];
      #2;

      // Reference model: search DOWN from bit 7 and stop at the first 1.
      want_idx   = 3'd0;
      want_valid = 1'b0;
      k = 7;
      while (k >= 0 && !want_valid) begin
        if (req[k]) begin
          want_idx   = k;
          want_valid = 1'b1;
        end
        k = k - 1;
      end

      if (idx_loop !== want_idx || valid_loop !== want_valid) begin
        $display("ERROR (loop):  req=%b -> idx=%0d valid=%b, expected %0d %b",
                 req, idx_loop, valid_loop, want_idx, want_valid);
        errors = errors + 1;
      end
      if (idx_casez !== want_idx || valid_casez !== want_valid) begin
        $display("ERROR (casez): req=%b -> idx=%0d valid=%b, expected %0d %b",
                 req, idx_casez, valid_casez, want_idx, want_valid);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_priority_encoder8");
      $finish;
    end else begin
      $display("FAIL: tb_priority_encoder8 (%0d errors)", errors);
      $fatal(1, "tb_priority_encoder8 failed");
    end
  end

endmodule
