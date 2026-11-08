// adder_tree.v - sum of eight 8-bit values, without and with pipelining.
//
// adder_tree_comb: one register at the output. Between the input registers
//                  and that register there are 3 levels of adders: a long path.
// adder_tree_pipe: a register after every level. Each clock period holds
//                  only one adder level, so the clock can be faster.
//                  Latency: 3 cycles. Throughput: still one sum per cycle.
//
// The eight inputs are packed into one 64-bit port: value k is
// din[8*k +: 8] (Verilog-2001 has no array ports).
`timescale 1ns/1ps

module adder_tree_comb (
  input  wire        clk,
  input  wire [63:0] din,
  output reg  [10:0] sum      // 8 x 255 = 2040 needs 11 bits
);
  always @(posedge clk)
    sum <= din[ 7: 0] + din[15: 8] + din[23:16] + din[31:24]
         + din[39:32] + din[47:40] + din[55:48] + din[63:56];
endmodule


module adder_tree_pipe (
  input  wire        clk,
  input  wire        rst,
  input  wire        valid_in,
  input  wire [63:0] din,
  output reg  [10:0] sum,
  output reg         valid_out
);

  // Level 1: four sums of two values (9 bits each)
  reg [8:0]  s1 [0:3];
  // Level 2: two sums of two level-1 sums (10 bits each)
  reg [9:0]  s2 [0:1];
  // valid travels with the data: one register per level
  reg        v1, v2;

  integer k;

  always @(posedge clk) begin
    for (k = 0; k < 4; k = k + 1)
      s1[k] <= din[16*k +: 8] + din[16*k + 8 +: 8];

    s2[0] <= s1[0] + s1[1];
    s2[1] <= s1[2] + s1[3];

    sum <= s2[0] + s2[1];
  end

  always @(posedge clk) begin
    if (rst) begin
      v1 <= 1'b0; v2 <= 1'b0; valid_out <= 1'b0;
    end else begin
      v1 <= valid_in;
      v2 <= v1;
      valid_out <= v2;
    end
  end

endmodule
