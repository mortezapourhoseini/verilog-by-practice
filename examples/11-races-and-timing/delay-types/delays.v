// delays.v - how simulation delays behave (simulation only).
//
//   y_inertial:  assign #5 y = a;
//                A continuous assignment with a delay is INERTIAL: a pulse
//                shorter than the delay is swallowed, like a slow gate.
//   y_transport: always @(a) y <= #5 a;
//                A non-blocking assignment with an intra-assignment delay
//                schedules every change 5 ns later. Short pulses survive
//                (TRANSPORT delay, like a long wire).
//   y_blocked:   always @(a) #5 y = a;
//                The block SLEEPS for 5 ns and misses changes of a in
//                that time. It samples a only after the sleep.
//
// Synthesis ignores all of these delays.
`timescale 1ns/1ps

module delays (
  input  wire a,
  output wire y_inertial,
  output reg  y_transport,
  output reg  y_blocked
);

  assign #5 y_inertial = a;

  always @(a)
    y_transport <= #5 a;

  always @(a)
    #5 y_blocked = a;

endmodule
