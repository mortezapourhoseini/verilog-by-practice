// uart_tx.v - UART transmitter: 8 data bits, no parity, 1 stop bit (8N1).
//
// A UART frame on the tx line (idle level is 1):
//
//   idle | start | d0 d1 d2 d3 d4 d5 d6 d7 | stop | idle
//    1   |   0   |   data, LSB first       |  1   |  1
//
// Each bit lasts CLKS_PER_BIT clock cycles. For 115200 baud with a
// 50 MHz clock, CLKS_PER_BIT would be 50_000_000 / 115_200 = 434.
//
// This is an FSM (control) plus a small datapath (counters, shift register).
`timescale 1ns/1ps

module uart_tx #(
  parameter CLKS_PER_BIT = 8      // a parameter can be changed per instance (chapter 07)
) (
  input  wire       clk,
  input  wire       rst,
  input  wire       start,        // 1-cycle pulse: send data
  input  wire [7:0] data,
  output reg        tx,
  output wire       busy
);

  localparam IDLE  = 2'd0;
  localparam START = 2'd1;
  localparam DATA  = 2'd2;
  localparam STOP  = 2'd3;

  reg [1:0]  state;
  reg [15:0] clk_cnt;   // counts clock cycles inside one bit
  reg [2:0]  bit_idx;   // which data bit is being sent
  reg [7:0]  shreg;     // copy of the data, shifted right

  wire bit_done = (clk_cnt == CLKS_PER_BIT - 1);

  assign busy = (state != IDLE);

  // One clocked block for state and datapath. For small FSMs with
  // counters this one-block style is common and easy to read.
  // tx is a register, so it has no glitches.
  always @(posedge clk) begin
    if (rst) begin
      state   <= IDLE;
      tx      <= 1'b1;
      clk_cnt <= 16'd0;
      bit_idx <= 3'd0;
      shreg   <= 8'd0;
    end else begin
      case (state)
        IDLE: begin
          tx      <= 1'b1;
          clk_cnt <= 16'd0;
          if (start) begin
            shreg <= data;        // capture the data now
            state <= START;
            tx    <= 1'b0;        // the start bit begins
          end
        end

        START: begin
          if (bit_done) begin
            clk_cnt <= 16'd0;
            bit_idx <= 3'd0;
            tx      <= shreg[0];  // first data bit
            state   <= DATA;
          end else begin
            clk_cnt <= clk_cnt + 16'd1;
          end
        end

        DATA: begin
          if (bit_done) begin
            clk_cnt <= 16'd0;
            if (bit_idx == 3'd7) begin
              tx    <= 1'b1;      // stop bit
              state <= STOP;
            end else begin
              bit_idx <= bit_idx + 3'd1;
              shreg   <= shreg >> 1;
              tx      <= shreg[1];  // the next bit (after the shift)
            end
          end else begin
            clk_cnt <= clk_cnt + 16'd1;
          end
        end

        STOP: begin
          if (bit_done) begin
            clk_cnt <= 16'd0;
            state   <= IDLE;
          end else begin
            clk_cnt <= clk_cnt + 16'd1;
          end
        end

        default: state <= IDLE;
      endcase
    end
  end

endmodule
