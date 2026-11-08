// tb_bus_driver.v - two drivers share one wire. Shows z and x on a net.
`timescale 1ns/1ps

module tb_bus_driver;

  reg        en_a;
  reg        en_b;
  reg  [7:0] data_a;
  reg  [7:0] data_b;
  wire [7:0] bus;     // a wire can have several drivers. A reg cannot.

  integer errors;

  bus_driver drv_a (.en(en_a), .data(data_a), .bus(bus));
  bus_driver drv_b (.en(en_b), .data(data_b), .bus(bus));

  initial begin
    $dumpfile("tb_bus_driver.vcd");
    $dumpvars(0, tb_bus_driver);
  end

  task check;
    input [7:0]    want;
    input [8*30:1] what;
    begin
      #5;
      if (bus !== want) begin
        $display("ERROR: %0s: bus=%b, expected %b", what, bus, want);
        errors = errors + 1;
      end else begin
        $display("ok    %0s: bus=%b", what, bus);
      end
    end
  endtask

  initial begin
    errors = 0;
    data_a = 8'b1111_0000;
    data_b = 8'b1010_1010;

    en_a = 0; en_b = 0;  check(8'bzzzz_zzzz, "nobody drives");
    en_a = 1; en_b = 0;  check(8'b1111_0000, "only A drives");
    en_a = 0; en_b = 1;  check(8'b1010_1010, "only B drives");

    // Both drive: where the bits agree, the bus has that value.
    // Where they disagree (0 against 1), the result is x.
    en_a = 1; en_b = 1;  check(8'b1x1x_x0x0, "both drive (conflict)");

    if (errors == 0) begin
      $display("PASS: tb_bus_driver");
      $finish;
    end else begin
      $display("FAIL: tb_bus_driver (%0d errors)", errors);
      $fatal(1, "tb_bus_driver failed");
    end
  end

endmodule
