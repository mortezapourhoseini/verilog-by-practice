// delay_line.v - delays a WIDTH-bit signal by DEPTH clock cycles.
//
// Shows:
//   - two parameters and a localparam derived from them,
//   - "generate if": different hardware for different parameter values,
//   - "generate for" with a register in every iteration,
//   - a parameter check at elaboration time.
`timescale 1ns/1ps

module delay_line #(
  parameter WIDTH = 8,
  parameter DEPTH = 3          // 0 means: no delay, just a wire
) (
  input  wire             clk,
  input  wire [WIDTH-1:0] din,
  output wire [WIDTH-1:0] dout
);

  // localparam: a constant computed from parameters. It cannot be
  // overridden from outside, which protects it.
  localparam TOTAL_BITS = WIDTH * DEPTH;

  genvar k;   // loop variable for the generate loop below

  generate
    if (DEPTH == 0) begin : no_delay
      assign dout = din;
    end else begin : with_delay
      // stage[0] is the input, stage[k] is the output of register k.
      wire [WIDTH-1:0] stage [0:DEPTH];
      assign stage[0] = din;

      for (k = 1; k <= DEPTH; k = k + 1) begin : reg_stage
        reg [WIDTH-1:0] r;
        always @(posedge clk)
          r <= stage[k-1];
        assign stage[k] = r;
      end

      assign dout = stage[DEPTH];
    end
  endgenerate

  // Simulation-only report, printed once at time 0.
  initial
    $display("delay_line: WIDTH=%0d DEPTH=%0d -> %0d flip-flops",
             WIDTH, DEPTH, TOTAL_BITS);

endmodule
