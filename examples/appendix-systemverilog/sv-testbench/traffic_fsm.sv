// traffic_fsm.sv - a tiny FSM written with SystemVerilog design features.
//
//   logic           one type for "wire or reg"
//   typedef enum    named states, the simulator knows their names
//   always_ff       a clocked block (the tool checks that it really is one)
//   always_comb     a combinational block (no sensitivity list needed)
//
// Compile with SystemVerilog mode: iverilog -g2012 ...
`timescale 1ns/1ps

module traffic_fsm (
  input  logic clk,
  input  logic rst,
  input  logic car_waiting,      // a car waits on the side road
  output logic main_green,
  output logic side_green
);

  typedef enum logic [1:0] {
    MAIN_GO   = 2'd0,
    MAIN_STOP = 2'd1,
    SIDE_GO   = 2'd2,
    SIDE_STOP = 2'd3
  } state_t;

  state_t state, next;
  logic [2:0] timer;

  always_ff @(posedge clk) begin
    if (rst) begin
      state <= MAIN_GO;
      timer <= '0;                 // '0 fills all bits with 0, any width
    end else begin
      state <= next;
      timer <= (next != state) ? '0 : timer + 1'b1;
    end
  end

  always_comb begin
    next = state;
    unique case (state)            // unique: exactly one item must match
      MAIN_GO:   if (car_waiting && timer >= 3'd3) next = MAIN_STOP;
      MAIN_STOP: if (timer == 3'd1)                next = SIDE_GO;
      SIDE_GO:   if (timer == 3'd3)                next = SIDE_STOP;
      SIDE_STOP: if (timer == 3'd1)                next = MAIN_GO;
    endcase
  end

  assign main_green = (state == MAIN_GO);
  assign side_green = (state == SIDE_GO);

endmodule
