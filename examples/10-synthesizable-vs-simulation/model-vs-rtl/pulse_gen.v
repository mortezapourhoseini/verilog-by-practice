// pulse_gen.v - the same behaviour written twice.
//
// pulse_model: a BEHAVIOURAL model. It uses delays (#1), "forever",
//              "repeat" and several event controls in one block. It is
//              easy to write and read, but it cannot be synthesized.
// pulse_rtl:   synthesizable RTL. A counter and a register, updated only
//              at the clock edge.
//
// Both give a one-cycle pulse every PERIOD clock cycles after reset.
`timescale 1ns/1ps

module pulse_model #(
  parameter PERIOD = 8
) (
  input  wire clk,
  input  wire rst,
  output reg  pulse
);

  initial begin
    pulse = 1'b0;
    @(negedge rst);                       // wait until reset is released
    @(posedge clk);
    forever begin
      repeat (PERIOD - 1) @(posedge clk); // wait PERIOD - 1 edges
      #1 pulse = 1'b1;                    // a delay: simulation only
      @(posedge clk);
      #1 pulse = 1'b0;
    end
  end

endmodule


module pulse_rtl #(
  parameter PERIOD = 8
) (
  input  wire clk,
  input  wire rst,
  output reg  pulse
);

  reg [7:0] cnt;

  always @(posedge clk) begin
    if (rst) begin
      cnt   <= 8'd0;
      pulse <= 1'b0;
    end else if (cnt == PERIOD - 1) begin
      cnt   <= 8'd0;
      pulse <= 1'b1;
    end else begin
      cnt   <= cnt + 8'd1;
      pulse <= 1'b0;
    end
  end

endmodule
