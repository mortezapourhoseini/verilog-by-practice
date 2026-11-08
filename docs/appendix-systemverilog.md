# Appendix - SystemVerilog features for testbenches (short)

**Reading time:** about 20 minutes.

SystemVerilog (IEEE 1800) is a superset of Verilog. It adds design features
and a large set of verification features. This repository uses plain
Verilog-2001 in the main chapters, because every tool supports it and it
teaches the basics without extra rules. This appendix shows the features
that are most useful when you start writing testbenches in SystemVerilog.

Icarus Verilog supports a part of SystemVerilog with `-g2012`. Verilator and
all commercial simulators support much more. Files with SystemVerilog code
usually end in `.sv`.

Files: [`examples/appendix-systemverilog/sv-testbench/`](../examples/appendix-systemverilog/sv-testbench/)

```bash
iverilog -g2012 -Wall -o sim.vvp traffic_fsm.sv tb_traffic_fsm.sv
vvp sim.vvp
```

## 1. `logic`: no more wire or reg

```verilog
logic [7:0] data;      // can be driven by assign OR by an always block
```

`logic` removes the `wire`/`reg` question of chapter 02. It still allows
only **one** driver. For nets with several drivers (tri-state), keep `wire`.

## 2. Two-state types

```verilog
int     count;    // 32-bit signed, only 0 and 1 (no x or z), starts as 0
bit     flag;     // 1 bit, two-state
byte    b;        // 8-bit signed
```

Two-state types are fast and handy for loop counters and statistics in
testbenches. Do **not** use them for DUT signals: they turn `x` into `0` and
hide bugs.

## 3. Intent-checking always blocks

```verilog
always_ff @(posedge clk) q <= d;        // must be a clocked block
always_comb y = a & b;                  // combinational, sensitivity automatic
always_latch if (en) q = d;             // a latch, written on purpose
```

The tool checks that the block matches its name. For example, a latch in
`always_comb` gives a warning or an error. This catches the bugs of chapter 04.

## 4. Enumerations

```verilog
typedef enum logic [1:0] {IDLE, RUN, DONE} state_t;
state_t state, next;
```

States get names, which also appear in waveforms of many simulators.
`unique case` and `priority case` tell the tool (and the reader) that exactly
one, or at least one, item must match.

## 5. Shorter code

```verilog
cnt++;   x += 4;                          // C-style operators
timer <= '0;                              // fill with 0 at any width ('1 = all ones)
traffic_fsm dut (.*);                     // connect ports to signals of the same name
logic clk = 1'b0;                         // declaration with initial value
task automatic wait_cycles(input int n);  // ANSI-style task header
  repeat (n) @(negedge clk);
endtask
```

## 6. Immediate assertions

```verilog
assert (!(main_green && side_green))
  else $error("both roads are green at %0t", $time);
```

An immediate assertion checks a condition **now**, like an `if`, and reports
with a standard severity: `$info`, `$warning`, `$error` or `$fatal`.
Put them in `always @(posedge clk)` blocks to check rules on every cycle.

**Concurrent assertions** (SVA) describe rules over time:

```verilog
// "every request is granted within 1 to 3 cycles"
assert property (@(posedge clk) req |-> ##[1:3] gnt);
```

They are very powerful, but Icarus does not support them. Verilator and
commercial simulators do. They are worth learning next.

## 7. Randomization

```verilog
x = $urandom;                 // 32-bit unsigned random
n = $urandom_range(12, 1);    // between 1 and 12 (max first, then min)
```

`$urandom` is unsigned, so `$urandom % 10` is never negative (compare with
`$random` in chapter 09).

Full constrained randomization uses **classes**:

```verilog
class packet;
  rand bit [7:0] len;
  constraint c_len { len inside {[1:64]}; }
endclass
```

`randomize()` then picks values that satisfy all constraints. Icarus does not
support class randomization. Use Verilator or a commercial simulator for it.

## 8. Functional coverage

```verilog
covergroup cg @(posedge clk);
  coverpoint state;                         // which states were visited?
  coverpoint len { bins small = {[1:8]}; bins big = {[9:64]}; }
endgroup
```

The simulator counts automatically what the hand-written counters of
chapter 09 count by hand. (Not supported in Icarus.)

## 9. Interfaces

An `interface` bundles the signals of a bus (for example valid, ready, data)
into one port. Testbenches and designs then connect one object instead of
ten wires. This becomes important for larger designs and for reusable
verification components (UVM).

## 10. Where to go next

| Topic | Why |
|---|---|
| SystemVerilog assertions (SVA) | describe protocols precisely, find bugs automatically |
| Classes and constrained random | large, reusable random testbenches |
| Coverage | know when you have tested enough |
| cocotb | testbenches in Python, with Icarus or Verilator as the simulator |
| Verilator | fast simulation, strict lint, SystemVerilog support |
| UVM | the industry standard methodology for verification |

## Summary

- `logic` replaces `wire` and `reg` (single driver). `int` and `bit` are
  two-state: good for testbench counters, bad for DUT signals.
- `always_ff`, `always_comb` and `always_latch` state your intent and let tools check it.
- `typedef enum` names states. `++`, `+=`, `'0` and `.*` shorten code.
- Immediate assertions check conditions with standard severities.
- `$urandom` and `$urandom_range` give unsigned random values.
- Concurrent assertions, classes, randomization and coverage are the next
  steps, with Verilator or a commercial simulator.

Back to the [README](../README.md).
