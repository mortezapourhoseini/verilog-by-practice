// seq_detect_1011.v - detects the bit pattern 1011 on a serial input.
// Overlapping patterns count: 1011011 contains the pattern twice.
//
// Two versions:
//   seq_detect_1011_moore: output depends only on the state.
//                          It is 1 in the cycle AFTER the last bit.
//   seq_detect_1011_mealy: output depends on the state AND the input.
//                          It is 1 in the SAME cycle as the last bit.
`timescale 1ns/1ps

module seq_detect_1011_moore (
  input  wire clk,
  input  wire rst,
  input  wire din,
  output wire found
);

  // One state per "how much of the pattern have we seen".
  localparam S0    = 3'd0;   // nothing useful
  localparam S1    = 3'd1;   // "1"
  localparam S10   = 3'd2;   // "10"
  localparam S101  = 3'd3;   // "101"
  localparam S1011 = 3'd4;   // "1011": pattern found

  reg [2:0] state;
  reg [2:0] next;

  // Block 1: state register.
  always @(posedge clk) begin
    if (rst) state <= S0;
    else     state <= next;
  end

  // Block 2: next-state logic (combinational).
  always @(*) begin
    next = S0;   // default (also catches illegal states)
    case (state)
      S0:    next = din ? S1    : S0;
      S1:    next = din ? S1    : S10;
      S10:   next = din ? S101  : S0;
      S101:  next = din ? S1011 : S10;
      // After 1011, the last "1" can start a new pattern, and
      // "10110" ends with "10". This is how overlap works.
      S1011: next = din ? S1    : S10;
      default: next = S0;
    endcase
  end

  // Block 3: output logic. Moore: from the state only.
  assign found = (state == S1011);

endmodule


module seq_detect_1011_mealy (
  input  wire clk,
  input  wire rst,
  input  wire din,
  output wire found
);

  // A Mealy machine needs one state less: the last bit is not stored,
  // it is looked at directly.
  localparam S0   = 2'd0;
  localparam S1   = 2'd1;
  localparam S10  = 2'd2;
  localparam S101 = 2'd3;

  reg [1:0] state;
  reg [1:0] next;

  always @(posedge clk) begin
    if (rst) state <= S0;
    else     state <= next;
  end

  always @(*) begin
    next = S0;
    case (state)
      S0:   next = din ? S1 : S0;
      S1:   next = din ? S1 : S10;
      S10:  next = din ? S101 : S0;
      S101: next = din ? S1 : S10;   // "1011" -> keep the last "1"
      default: next = S0;
    endcase
  end

  // Mealy: from the state AND the current input.
  assign found = (state == S101) && din;

endmodule
