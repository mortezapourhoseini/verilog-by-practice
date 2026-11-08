// dot4.v - 4-element dot product (exercise 13.2: pipeline it).
`timescale 1ns/1ps

module dot4 (
  input  wire        clk,
  input  wire        rst,
  input  wire        valid_in,
  input  wire [31:0] a,
  input  wire [31:0] b,
  output reg  [17:0] y,
  output reg         valid_out
);

  reg v1, v2;

  // TODO: three pipeline stages for the data.
  // The stub computes everything in ONE stage, so y comes 2 cycles too early.
  always @(posedge clk) begin
    y <= a[7:0]   * b[7:0]   + a[15:8]  * b[15:8]
       + a[23:16] * b[23:16] + a[31:24] * b[31:24];
  end

  // The valid pipeline is already correct: 3 stages.
  always @(posedge clk) begin
    if (rst) begin
      v1 <= 1'b0; v2 <= 1'b0; valid_out <= 1'b0;
    end else begin
      v1 <= valid_in; v2 <= v1; valid_out <= v2;
    end
  end

endmodule
