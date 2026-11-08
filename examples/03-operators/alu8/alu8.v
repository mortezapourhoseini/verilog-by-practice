// alu8.v - small 8-bit ALU. Uses most Verilog operators.
//
// The case statement is explained in chapter 04. Here, read it as
// "choose one line by the value of op".
`timescale 1ns/1ps

module alu8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [3:0] op,
  output reg  [7:0] y,
  output reg        carry,   // carry out (ADD) or borrow (SUB)
  output wire       zero     // 1 when y is 0
);

  // Operation codes. localparam is a named constant (chapter 07).
  localparam OP_ADD  = 4'd0;
  localparam OP_SUB  = 4'd1;
  localparam OP_AND  = 4'd2;
  localparam OP_OR   = 4'd3;
  localparam OP_XOR  = 4'd4;
  localparam OP_NOR  = 4'd5;
  localparam OP_SHL  = 4'd6;   // shift left logical
  localparam OP_SHR  = 4'd7;   // shift right logical (fill with 0)
  localparam OP_SRA  = 4'd8;   // shift right arithmetic (fill with sign bit)
  localparam OP_SLT  = 4'd9;   // set if less than, signed
  localparam OP_SLTU = 4'd10;  // set if less than, unsigned

  always @(*) begin
    // Default values first, so every output gets a value in every case.
    y     = 8'd0;
    carry = 1'b0;

    case (op)
      // {carry, y} is 9 bits, so a and b are extended to 9 bits before
      // the addition. The 9th bit is the carry.
      OP_ADD:  {carry, y} = a + b;
      // For subtraction, the 9th bit is 1 when a < b (a borrow).
      OP_SUB:  {carry, y} = a - b;
      OP_AND:  y = a & b;
      OP_OR:   y = a | b;
      OP_XOR:  y = a ^ b;
      OP_NOR:  y = ~(a | b);
      // Only the low 3 bits of b are used as the shift amount (0 to 7).
      OP_SHL:  y = a << b[2:0];
      OP_SHR:  y = a >> b[2:0];
      // >>> fills with the sign bit only if the operand is SIGNED.
      // $signed(a) reads the same bits as a two's complement number.
      OP_SRA:  y = $signed(a) >>> b[2:0];
      // Comparison results are 1 bit. We put them in bit 0 of y.
      OP_SLT:  y = {7'd0, $signed(a) < $signed(b)};
      OP_SLTU: y = {7'd0, a < b};
      default: y = 8'd0;
    endcase
  end

  // Reduction NOR: 1 only when all bits of y are 0.
  assign zero = ~|y;

endmodule
