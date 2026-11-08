// tb_traffic_light.v - checks safety, order and duration of each phase.
`timescale 1ns/1ps

module tb_traffic_light;

  reg        clk;
  reg        rst;
  wire [2:0] ns_light;
  wire [2:0] ew_light;

  reg  [5:0] phase;       // {ns_light, ew_light}
  reg  [5:0] last_phase;
  integer    length;      // cycles in the current phase
  integer    changes;
  integer    errors;

  traffic_light dut (
    .clk      (clk),
    .rst      (rst),
    .ns_light (ns_light),
    .ew_light (ew_light)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_traffic_light.vcd");
    $dumpvars(0, tb_traffic_light);
  end

  // The phase that must follow each phase, and how long it lasts.
  function [5:0] next_phase;
    input [5:0] p;
    begin
      case (p)
        6'b001_100: next_phase = 6'b010_100;   // NS green  -> NS yellow
        6'b010_100: next_phase = 6'b100_001;   // NS yellow -> EW green
        6'b100_001: next_phase = 6'b100_010;   // EW green  -> EW yellow
        6'b100_010: next_phase = 6'b001_100;   // EW yellow -> NS green
        default:    next_phase = 6'bxxx_xxx;
      endcase
    end
  endfunction

  function integer duration;
    input [5:0] p;
    begin
      duration = (p == 6'b001_100 || p == 6'b100_001) ? 5 : 2;
    end
  endfunction

  always @(posedge clk) begin
    if (!rst) begin
      phase = {ns_light, ew_light};

      // Safety: at least one road must be red at all times.
      if (ns_light != 3'b100 && ew_light != 3'b100) begin
        $display("ERROR at %0t: both roads may drive! ns=%b ew=%b", $time, ns_light, ew_light);
        errors = errors + 1;
      end

      if (phase == last_phase) begin
        length = length + 1;
      end else begin
        if (last_phase !== 6'bxxx_xxx) begin
          if (length != duration(last_phase)) begin
            $display("ERROR: phase %b lasted %0d cycles, expected %0d",
                     last_phase, length, duration(last_phase));
            errors = errors + 1;
          end
          if (phase !== next_phase(last_phase)) begin
            $display("ERROR: phase %b came after %b", phase, last_phase);
            errors = errors + 1;
          end
          changes = changes + 1;
        end
        last_phase = phase;
        length = 1;
      end
    end
  end

  initial begin
    errors = 0; changes = 0; length = 0;
    last_phase = 6'bxxx_xxx;
    rst = 1'b1;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Three full cycles of 5 + 2 + 5 + 2 = 14 clock cycles each.
    repeat (3 * 14 + 3) @(negedge clk);

    $display("saw %0d phase changes", changes);
    if (changes < 12) begin
      $display("ERROR: expected at least 12 phase changes");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_traffic_light");
      $finish;
    end else begin
      $display("FAIL: tb_traffic_light (%0d errors)", errors);
      $fatal(1, "tb_traffic_light failed");
    end
  end

endmodule
