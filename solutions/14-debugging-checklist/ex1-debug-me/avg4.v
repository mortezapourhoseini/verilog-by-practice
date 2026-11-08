// avg4.v - moving average of the last 4 valid samples (solution 14.1).
//
// The three bugs:
//   1. sum was 8 bits: 4 x 255 = 1020 needs 10 bits. Four samples of 200
//      (sum 800) gave a wrong average. Found with the directed test.
//   2. blocking "=" in the clocked block: s1 and s2 got the NEW s0, so all
//      three were equal to din. It also raced with the output block that
//      reads sum. Found by looking at s0, s1, s2 in the waveform.
//   3. the history shifted on every clock edge, also when valid was 0.
//      Found with the "gap" part of the test.
`timescale 1ns/1ps

module avg4 (
  input  wire       clk,
  input  wire       rst,
  input  wire       valid,
  input  wire [7:0] din,
  output reg  [7:0] avg,
  output reg        out_valid
);

  reg [7:0] s0, s1, s2;
  reg [9:0] sum;                        // fix 1: 10 bits

  always @(*) sum = din + s0 + s1 + s2;

  always @(posedge clk) begin
    if (rst) begin
      s0 <= 8'd0;                       // fix 2: non-blocking
      s1 <= 8'd0;
      s2 <= 8'd0;
    end else if (valid) begin           // fix 3: shift only valid samples
      s0 <= din;
      s1 <= s0;
      s2 <= s1;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      avg       <= 8'd0;
      out_valid <= 1'b0;
    end else begin
      out_valid <= valid;
      if (valid)
        avg <= sum >> 2;                // 10 bits >> 2 = 8 bits
    end
  end

endmodule
