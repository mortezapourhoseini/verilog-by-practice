# Verilog-2001 cheat sheet

## Module

```verilog
`timescale 1ns/1ps
`default_nettype none

module name #(
  parameter WIDTH = 8
) (
  input  wire             clk,
  input  wire             rst,
  input  wire [WIDTH-1:0] a,
  output wire [WIDTH-1:0] y,      // driven by assign
  output reg              flag    // driven by always
);
  localparam MAX = (1 << WIDTH) - 1;
  ...
endmodule

`default_nettype wire
```

Instance (always by name): `name #(.WIDTH(16)) u1 (.clk(clk), .rst(rst), .a(x), .y(y), .flag());`

## Types and literals

| Declaration | Meaning |
|---|---|
| `wire [7:0] w;` | net, driven by `assign` or an instance |
| `reg [7:0] r;` | variable, written in `always` / `initial` (not always a flip-flop) |
| `reg signed [15:0] s;` | two's complement |
| `integer i;` | 32-bit signed variable |
| `reg [7:0] mem [0:255];` | memory: 256 words of 8 bits |
| `wire [7:0] arr [0:3];` | array of nets |

Literals: `8'b1010_0101`, `8'hA5`, `8'd165`, `-8'sd5`, `4'bx`, `8'bz`, `"text"`.
Unsized (`5`, `'hF`) = at least 32 bits. Values: `0 1 x z`.

Selects: `v[3]`, `v[7:4]`, `v[i]`, `v[8*k +: 8]`, `v[15 -: 8]`, `mem[a][3:0]`.

## Operators (high to low precedence)

| | |
|---|---|
| `! ~ & ~& \| ~\| ^ ~^` (unary) | not, reduction |
| `**` `* / %` `+ -` | arithmetic |
| `<< >> <<< >>>` | shifts (`>>>` keeps sign only if signed) |
| `< <= > >=` | relational |
| `== != === !==` | equality (`===` compares x and z) |
| `& ^ \|` | bitwise |
| `&& \|\|` | logical |
| `c ? a : b` | conditional |
| `{a, b}` `{4{a}}` | concatenation, replication |

Width rule: operands are extended to the widest operand **or the target**
before the operation. `{cout, sum} = a + b;` keeps the carry.
Signed only if **all** operands are signed: `$signed(x)`, `$unsigned(x)`.

## Combinational logic

```verilog
assign y = sel ? b : a;

always @(*) begin
  y = 8'd0;                     // default first: no latch
  case (op)
    2'd0:    y = a + b;
    2'd1:    y = a - b;
    default: y = 8'd0;
  endcase
end
```

`casez` with `?` for don't-care bits. Avoid `casex`. Loops are unrolled.

## Sequential logic

```verilog
always @(posedge clk) begin                 // synchronous reset
  if (rst)     q <= 0;
  else if (en) q <= d;
end

always @(posedge clk or negedge rst_n)      // asynchronous reset
  if (!rst_n) q <= 0;
  else        q <= d;
```

Rules: `<=` in clocked blocks, `=` in `always @(*)`, never mixed, each
variable written in one block only.

## FSM (three blocks)

```verilog
localparam IDLE = 2'd0, RUN = 2'd1;
reg [1:0] state, next;
always @(posedge clk) state <= rst ? IDLE : next;
always @(*) begin
  next = state;
  case (state)
    IDLE: if (start) next = RUN;
    RUN:  if (done)  next = IDLE;
    default: next = IDLE;
  endcase
end
assign busy = (state == RUN);
```

## Parameters, generate, functions

```verilog
genvar i;
generate
  for (i = 0; i < N; i = i + 1) begin : stage
    full_adder fa (.a(a[i]), .b(b[i]), .cin(c[i]), .sum(s[i]), .cout(c[i+1]));
  end
  if (DEPTH == 0) begin : bypass
    assign out = in;
  end
endgenerate

function [7:0] max8;
  input [7:0] x, y;
  max8 = (x > y) ? x : y;
endfunction
```

## Memories

```verilog
reg [7:0] mem [0:15];
initial $readmemh("data.hex", mem);
always @(posedge clk) begin
  if (we) mem[addr] <= din;
  dout <= mem[addr];               // synchronous read -> block RAM
end
```

## Testbench

```verilog
initial begin clk = 0; forever #5 clk = ~clk; end
initial begin $dumpfile("tb.vcd"); $dumpvars(0, tb); end
initial begin #100000 $display("FAIL: tb (timeout)"); $fatal(1); end

initial begin
  rst = 1; repeat (2) @(negedge clk); rst = 0;
  @(negedge clk) din = 8'd5;       // drive at negedge
  ...
  if (y !== expected) errors = errors + 1;
  if (errors == 0) begin $display("PASS: tb"); $finish; end
  else begin $display("FAIL: tb"); $fatal(1, "failed"); end
end
```

| Task | Use |
|---|---|
| `$display` `$write` `$strobe` `$monitor` | print now / no newline / end of step / on change |
| `%b %h %d %0d %s %t` | binary, hex, decimal, no padding, string, time |
| `$timeformat(-9, 1, " ns", 10)` | how `%t` prints |
| `$time` `$finish` `$stop` `$fatal(1, "msg")` | time, end, pause, end with error status |
| `$random(seed)` `$value$plusargs("seed=%d", s)` | random, command-line options |
| `$fopen $fclose $fdisplay $fgets $sscanf $fscanf $feof` | file I/O |
| `$readmemh` `$readmemb` | load a memory |

## Commands

```bash
iverilog -g2001 -Wall -o sim.vvp design.v tb_design.v
vvp sim.vvp                 # run
gtkwave tb_design.vcd &     # waveforms
verilator --lint-only -Wall design.v
yosys -p "read_verilog design.v; synth; stat"
make                        # this repository: run all tests
make run DIR=<folder>       # one test
```

## Top 10 bugs

1. Missing `else` / `default` in `always @(*)`: latch.
2. `=` in a clocked block: collapsed pipeline, races.
3. Hand-written sensitivity list: simulation differs from hardware.
4. Lost carry: target too narrow.
5. One unsigned operand: the whole expression is unsigned.
6. `>>` instead of `>>>` for signed values.
7. Typo creates an implicit wire: use `` `default_nettype none ``.
8. No reset on state registers: `x` forever.
9. Testbench drives inputs at the sampling edge: race.
10. `==` instead of `!==` in checks: `x` passes silently.
