// avg4.v - moving average of the last 4 valid samples (exercise 14.1).
// This file has THREE bugs. Use the checklist in docs/14-debugging-checklist.md.
`timescale 1ns/1ps

module avg4 (
  input  wire       clk,
  input  wire       rst,
  input  wire       valid,
  input  wire [7:0] din,
  output reg  [7:0] avg,
  output reg        out_valid
);

  // The three previous valid samples (s0 is the newest).
  reg [7:0] s0, s1, s2;
  reg [7:0] sum;

  // Sum of the current sample and the three previous ones.
  always @(*) sum = din + s0 + s1 + s2;

  // Sample history.
  always @(posedge clk) begin
    if (rst) begin
      s0 = 8'd0;
      s1 = 8'd0;
      s2 = 8'd0;
    end else begin
      s0 = din;
      s1 = s0;
      s2 = s1;
    end
  end

  // Registered output, one cycle after the valid input.
  always @(posedge clk) begin
    if (rst) begin
      avg       <= 8'd0;
      out_valid <= 1'b0;
    end else begin
      out_valid <= valid;
      if (valid)
        avg <= sum >> 2;
    end
  end

endmodule
