// tb_rom_squares.v - reads every address and checks the latency of one cycle.
`timescale 1ns/1ps

module tb_rom_squares;

  reg        clk;
  reg  [3:0] addr;
  wire [7:0] data;

  integer errors;
  integer k;

  rom_squares dut (
    .clk  (clk),
    .addr (addr),
    .data (data)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_rom_squares.vcd");
    $dumpvars(0, tb_rom_squares);
  end

  initial begin
    errors = 0;

    // The testbench can look into the memory directly. If $readmemh
    // could not find the file, the words stay x.
    #1;
    if (dut.mem[0] === 8'bx) begin
      $display("ERROR: the ROM is empty. Is squares.hex in the current folder?");
      errors = errors + 1;
    end

    for (k = 0; k < 16; k = k + 1) begin
      @(negedge clk);
      addr = k;
      @(negedge clk);      // one rising edge later, data is valid
      if (data !== (k * k) % 256) begin
        $display("ERROR: addr=%0d -> data=%0d, expected %0d", k, data, k * k);
        errors = errors + 1;
      end
    end
    $display("rom[15] = %0d", data);

    if (errors == 0) begin
      $display("PASS: tb_rom_squares");
      $finish;
    end else begin
      $display("FAIL: tb_rom_squares (%0d errors)", errors);
      $fatal(1, "tb_rom_squares failed");
    end
  end

endmodule
