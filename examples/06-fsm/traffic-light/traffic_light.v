// traffic_light.v - Moore FSM with a timer for a two-road crossing.
//
//   NS_GREEN (GREEN_TIME cycles) -> NS_YELLOW (YELLOW_TIME cycles)
//   -> EW_GREEN (GREEN_TIME)     -> EW_YELLOW (YELLOW_TIME) -> NS_GREEN ...
//
// The light for each road is {red, yellow, green}.
// Written in the three-block style: state register, next-state logic,
// output logic.
`timescale 1ns/1ps

module traffic_light (
  input  wire       clk,
  input  wire       rst,
  output reg  [2:0] ns_light,   // north-south {red, yellow, green}
  output reg  [2:0] ew_light    // east-west   {red, yellow, green}
);

  // Short times, so the simulation is short. Real values would be
  // seconds, made with a tick counter (chapter 05).
  localparam GREEN_TIME  = 5;
  localparam YELLOW_TIME = 2;

  localparam NS_GREEN  = 2'd0;
  localparam NS_YELLOW = 2'd1;
  localparam EW_GREEN  = 2'd2;
  localparam EW_YELLOW = 2'd3;

  localparam RED    = 3'b100;
  localparam YELLOW = 3'b010;
  localparam GREEN  = 3'b001;

  reg [1:0] state;
  reg [1:0] next;
  reg [2:0] timer;       // cycles left in the current state, minus one
  wire      time_up = (timer == 3'd0);

  // Block 1: registers (state and timer).
  always @(posedge clk) begin
    if (rst) begin
      state <= NS_GREEN;
      timer <= GREEN_TIME - 1;
    end else begin
      state <= next;
      if (time_up) begin
        // Load the time of the state we are going to.
        if (next == NS_GREEN || next == EW_GREEN)
          timer <= GREEN_TIME - 1;
        else
          timer <= YELLOW_TIME - 1;
      end else begin
        timer <= timer - 3'd1;
      end
    end
  end

  // Block 2: next-state logic.
  always @(*) begin
    next = state;            // default: stay
    if (time_up) begin
      case (state)
        NS_GREEN:  next = NS_YELLOW;
        NS_YELLOW: next = EW_GREEN;
        EW_GREEN:  next = EW_YELLOW;
        EW_YELLOW: next = NS_GREEN;
        default:   next = NS_GREEN;
      endcase
    end
  end

  // Block 3: output logic (Moore: from the state only).
  always @(*) begin
    ns_light = RED;          // defaults: both red (the safe value)
    ew_light = RED;
    case (state)
      NS_GREEN:  ns_light = GREEN;
      NS_YELLOW: ns_light = YELLOW;
      EW_GREEN:  ew_light = GREEN;
      EW_YELLOW: ew_light = YELLOW;
      default: ;
    endcase
  end

endmodule
