// multipliers.v - two ways to multiply 8 x 8 bits.
//
// mult8:     combinational, with the * operator, signed or unsigned.
//            FPGA tools map this to a DSP block (a hard multiplier).
// mult_seq8: sequential shift-and-add, unsigned. One partial product per
//            clock cycle: small hardware, 8 cycles per result.
`timescale 1ns/1ps

module mult8 (
  input  wire [7:0]  a,
  input  wire [7:0]  b,
  input  wire        is_signed,   // 1: a and b are two's complement
  output wire [15:0] p
);

  // Unsigned: plain *. The 16-bit target keeps the full product.
  wire [15:0] p_u = a * b;

  // Signed: BOTH operands must be signed, or the whole expression is
  // unsigned (chapter 03). $signed() reads the same bits as signed.
  wire signed [15:0] p_s = $signed(a) * $signed(b);

  assign p = is_signed ? p_s : p_u;

endmodule


module mult_seq8 (
  input  wire        clk,
  input  wire        rst,
  input  wire        start,
  input  wire [7:0]  a,
  input  wire [7:0]  b,
  output reg  [15:0] product,
  output reg         done,
  output reg         busy
);

  reg [15:0] mcand;    // a, shifted left by one place per cycle
  reg [7:0]  mplier;   // b, shifted right: bit 0 decides "add or not"
  reg [15:0] acc;
  reg [2:0]  cnt;

  wire [15:0] partial = mplier[0] ? mcand : 16'd0;

  always @(posedge clk) begin
    done <= 1'b0;
    if (rst) begin
      busy <= 1'b0;
      acc  <= 16'd0;
      cnt  <= 3'd0;
      product <= 16'd0;
    end else if (!busy) begin
      if (start) begin
        mcand  <= {8'd0, a};
        mplier <= b;
        acc    <= 16'd0;
        cnt    <= 3'd0;
        busy   <= 1'b1;
      end
    end else begin
      // One step of long multiplication in binary.
      acc    <= acc + partial;
      mcand  <= mcand << 1;
      mplier <= mplier >> 1;
      cnt    <= cnt + 3'd1;
      if (cnt == 3'd7) begin
        product <= acc + partial;   // include the last partial product
        done    <= 1'b1;
        busy    <= 1'b0;
      end
    end
  end

endmodule
