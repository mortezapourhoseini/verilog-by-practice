// tb_traffic_fsm.sv - a testbench with useful SystemVerilog features.
//
//   int, logic, ++ and +=       shorter declarations and operators
//   task automatic with ref     arguments that the task can change
//   $urandom_range(max, min)    random numbers in a range
//   assert ... else $error      immediate assertions
//   always @(posedge clk)       a checker that runs on every edge
`timescale 1ns/1ps

module tb_traffic_fsm;

  logic clk = 1'b0;                // initialization in the declaration
  logic rst;
  logic car_waiting;
  logic main_green;
  logic side_green;

  int errors = 0;
  int side_turns = 0;
  int cycles = 0;

  traffic_fsm dut (.*);            // .* connects ports to signals of the same name

  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_traffic_fsm.vcd");
    $dumpvars(0, tb_traffic_fsm);
  end

  // Safety property, checked at every rising edge.
  always @(posedge clk) begin
    if (!rst) begin
      cycles++;
      assert (!(main_green && side_green))
        else begin
          $error("both roads are green at %0t", $time);
          errors++;
        end
    end
  end

  // Count how often the side road got green (rising edge of side_green).
  always @(posedge side_green) side_turns += 1;

  task automatic wait_cycles(input int n);
    repeat (n) @(negedge clk);
  endtask

  initial begin
    rst = 1'b1;
    car_waiting = 1'b0;
    wait_cycles(2);
    rst = 1'b0;

    // No car: the main road stays green.
    wait_cycles(20);
    assert (main_green) else begin $error("main road should stay green"); errors++; end
    assert (side_turns == 0) else begin $error("side road got green without a car"); errors++; end

    // Random cars.
    repeat (40) begin
      car_waiting = 1'b1;
      wait_cycles($urandom_range(12, 1));
      car_waiting = 1'b0;
      wait_cycles($urandom_range(6, 0));
    end

    $display("%0d cycles, side road got green %0d times", cycles, side_turns);
    if (side_turns == 0) begin
      $display("ERROR: the side road never got green");
      errors++;
    end

    if (errors == 0) begin
      $display("PASS: tb_traffic_fsm");
      $finish;
    end else begin
      $display("FAIL: tb_traffic_fsm (%0d errors)", errors);
      $fatal(1, "tb_traffic_fsm failed");
    end
  end

endmodule
