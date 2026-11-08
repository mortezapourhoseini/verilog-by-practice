// bus_driver.v - a tri-state driver: it drives the bus only when enabled.
//
// When en is 0, the output is z (high impedance): this driver lets go
// of the bus, so another driver can use it.
//
// Note: inside an FPGA, tri-state buses usually do not exist. Synthesis
// turns them into multiplexers, or they are only allowed on I/O pins.
// We use one here to understand z and x.
`timescale 1ns/1ps

module bus_driver (
  input  wire       en,
  input  wire [7:0] data,
  output wire [7:0] bus
);

  assign bus = en ? data : 8'bz;

endmodule
