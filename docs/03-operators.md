# 03 - Operators

**Reading time:** about 30 minutes.

## Goals

After this chapter you can:

- use bitwise, logical, reduction, shift, relational and arithmetic operators,
- build values with concatenation and replication,
- predict the **width** of an expression and avoid lost carries,
- predict when an expression is **signed** and when it is not,
- add parentheses where precedence would surprise you.

## 1. The operators at a glance

| Group | Operators | Result width |
|---|---|---|
| Bitwise | `~` `&` `\|` `^` `~^` | width of the operands (see section 4) |
| Logical | `!` `&&` `\|\|` | 1 bit |
| Reduction | `&` `~&` `\|` `~\|` `^` `~^` (one operand) | 1 bit |
| Shift | `<<` `>>` `<<<` `>>>` | width of the left operand |
| Arithmetic | `+` `-` `*` `/` `%` `**` | width of the operands (see section 4) |
| Relational | `<` `<=` `>` `>=` | 1 bit |
| Equality | `==` `!=` `===` `!==` | 1 bit |
| Conditional | `c ? x : y` | width of `x` and `y` |
| Concatenation | `{a, b}` `{n{a}}` | sum of the widths |

## 2. Bitwise, logical and reduction operators

The same symbol can mean different things. This is a common source of bugs.

**Bitwise** operators work on each bit position:

```verilog
4'b1100 & 4'b1010   // 4'b1000
4'b1100 | 4'b1010   // 4'b1110
4'b1100 ^ 4'b1010   // 4'b0110
~4'b1100            // 4'b0011
```

**Logical** operators treat the whole vector as one truth value
(non-zero = true) and return 1 bit:

```verilog
4'b0101 && 4'b1010  // 1  (both are non-zero)
4'b0101 &  4'b1010  // 4'b0000  (bitwise: no common bit)
!4'b0101            // 0
~4'b0101            // 4'b1010
```

Use logical operators for **conditions** (`if (valid && ready)`),
and bitwise operators for **data** (`masked = data & mask`).
For 1-bit signals both give the same result, so the habit matters only
when a signal later becomes a vector.

**Reduction** operators have one operand and combine all its bits into one bit:

```verilog
&data   // 1 if all bits are 1
|data   // 1 if any bit is 1  (same as data != 0)
^data   // XOR of all bits: 1 if the number of ones is odd (parity)
~|data  // 1 if all bits are 0  (same as data == 0)
```

The ALU example uses `assign zero = ~|y;` for its zero flag.

## 3. Shifts

```verilog
8'b1001_0110 << 2    // 8'b0101_1000  (zeros come in from the right)
8'b1001_0110 >> 2    // 8'b0010_0101  (zeros come in from the left)
```

The arithmetic right shift `>>>` copies the sign bit into the empty positions,
**but only if the left operand is signed**. On an unsigned value it is the
same as `>>`:

```verilog
reg        [7:0] u = 8'b1000_0000;
reg signed [7:0] s = 8'b1000_0000;   // -128

u >>> 1          // 8'b0100_0000  (unsigned: like >>)
s >>> 1          // 8'b1100_0000  (-64)
$signed(u) >>> 1 // 8'b1100_0000  ($signed makes it signed)
```

`<<<` is the same as `<<`. A shift by a constant is just wiring in hardware.
A shift by a variable amount becomes a *barrel shifter* (a set of multiplexers).

## 4. Expression width: the most important rule

Verilog does not tell you when it throws bits away. You need to know how it
decides the width of an expression.

**Rule:** for `+`, `-`, `*`, `&`, `|`, `^`, `~` and `? :`, all operands are
first extended to the width of the **largest operand or the assignment
target**, whichever is bigger. Then the operation happens at that width.
The result is then cut to the width of the target.

Look at three cases with `a = 4'd15` and `b = 4'd1`:

```verilog
reg [3:0] r4;
reg [4:0] r5;

r4 = a + b;          // width 4: 15 + 1 = 16 = 5'b10000 -> cut to 4'b0000
r5 = a + b;          // width 5: operands extended to 5 bits, 16 fits -> 5'd16
{cout, r4} = a + b;  // width 5: the left side is 5 bits -> cout = 1, r4 = 0
```

The third line is the standard way to get the carry of an adder.

### The averaging bug

```verilog
reg [3:0] avg;
avg = (a + b) >> 1;            // wrong: width 4, so 15 + 1 = 0, and 0 >> 1 = 0
avg = ({1'b0, a} + b) >> 1;    // right: one operand is 5 bits, so width 5: 16 >> 1 = 8
```

The target `avg` is 4 bits, so the first line works in 4 bits, and the carry
is lost **before** the shift. Making one operand 5 bits wide makes the whole
expression 5 bits wide.

### Some operands keep their own width

A few operands are *self-determined*: their width does not depend on the
rest of the expression.

- the operand of a reduction operator (`&x`),
- the condition of `? :`,
- the right operand of a shift (the shift amount),
- each item inside `{ }`,
- the operands of relational and equality operators are extended to the
  larger of the two, but the result is always 1 bit.

### A surprise with `~`

```verilog
reg [7:0] r8;
r8 = ~4'b0101;   // 8'b1111_1010, not 8'b0000_1010!
```

The 4-bit literal is first extended to the target width (8 bits) with zeros,
and **then** inverted. The new zero bits become ones. Write `r8 = {4'b0, ~4'b0101};`
if you want only 4 inverted bits.

The [width-rules example](../examples/03-operators/width-rules/) tests all of
this. Run it and compare each line with this section.

## 5. Signed and unsigned expressions

**Rule:** an expression is signed **only if all its operands are signed**.
If even one operand is unsigned, every operand is treated as unsigned.

```verilog
reg signed [7:0] s = -8'sd1;   // bits 1111_1111
reg        [7:0] u = 8'd1;

s < 0         // 1: both signed (0 is a signed integer)
s < u         // 0: u is unsigned, so s is read as 255. 255 < 1 is false.
s < 8'sd1     // 1: both signed
```

Things that are signed: `integer`, `reg signed`, `wire signed`, unsized
decimal numbers (`5`, `-3`), and literals with `s` (`8'sd5`).
Things that are unsigned: everything else, including `8'd5`, `8'hFF`, any
part select (`s[7:0]` is unsigned even if `s` is signed!) and any concatenation.

Two system functions change how bits are read, without changing them:

```verilog
$signed(u)     // read u as a two's complement number
$unsigned(s)   // read s as an unsigned number
```

### Sign extension happens only for signed expressions

```verilog
reg signed [7:0]  s8  = -8'sd3;  // 8'hFD
reg signed [15:0] s16;
reg        [15:0] u16;

s16 = s8;          // 16'hFFFD: signed, so the sign bit is copied
u16 = s8;          // 16'hFFFD: the right side is signed, so it is sign-extended
s16 = s8 + 8'd1;   // 16'h00FE! 8'd1 is unsigned, so s8 is zero-extended first
```

The last line is a classic bug in DSP code. Chapter 12 returns to it.

## 6. Arithmetic operators

```verilog
a + b    a - b    a * b    // fine for synthesis
a / b    a % b             // synthesis: only if b is a constant power of two
a ** b                     // synthesis: only with constants
```

- `+` and `-` become adders. `*` becomes a multiplier (on FPGAs often a DSP block).
- `/` and `%` by a variable create a very large, slow circuit, and some tools
  refuse them. Division by a power of two is just a shift: `a / 8` is `a >> 3`
  for unsigned values.
- In simulation, integer division truncates toward zero: `-7 / 2 = -3`,
  and `-7 % 2 = -1` (the remainder has the sign of the left operand).

## 7. Relational and equality operators

```verilog
a <  b    a <= b    a > b    a >= b    // 1 bit result (or x)
a == b    a != b                         // x if any bit is x or z
a === b   a !== b                        // compares x and z exactly, never x
```

`===` and `!==` are for **testbenches**. Synthesis tools treat them like `==`
or reject them, because real hardware has no `x`.

## 8. Conditional operator

`cond ? x : y` is a multiplexer. It nests well for small cases:

```verilog
assign y = (sel == 2'd0) ? a :
           (sel == 2'd1) ? b :
           (sel == 2'd2) ? c : d;
```

If `cond` is `x`, the simulator combines `x` and `y` bit by bit: bits that
are equal stay, the others become `x`.

## 9. Concatenation and replication

```verilog
{a, b, c}              // join: a is on the left (most significant)
{4{1'b1}}              // 4'b1111
{{8{x[7]}}, x}         // sign-extend 8 bits to 16 bits
{a[3:0], a[7:4]}       // swap nibbles
{cout, sum} = a + b;   // concatenation on the LEFT side splits the result
```

Every item in `{ }` must have a size. `{a, 1}` is an error. Write `{a, 1'b1}`.

## 10. Precedence

From highest to lowest (operators on the same line have the same precedence):

| Precedence | Operators |
|---|---|
| highest | unary `+ - ! ~`, reduction `& ~& \| ~\| ^ ~^` |
| | `**` |
| | `* / %` |
| | `+ -` (binary) |
| | `<< >> <<< >>>` |
| | `< <= > >=` |
| | `== != === !==` |
| | `&` (binary) |
| | `^ ~^` (binary) |
| | `\|` (binary) |
| | `&&` |
| | `\|\|` |
| lowest | `? :` |

Two traps:

```verilog
a & b == c      // means a & (b == c), not (a & b) == c
a + b << 1      // means (a + b) << 1, which is probably what you want
x << 1 + 1      // means x << 2
```

Rule of thumb: when you mix bitwise and comparison operators, **always use parentheses**.

## 11. Example: an 8-bit ALU

Files: [`examples/03-operators/alu8/`](../examples/03-operators/alu8/)

The ALU uses almost every operator in this chapter. The key lines:

```verilog
always @(*) begin
  y     = 8'd0;
  carry = 1'b0;
  case (op)
    OP_ADD:  {carry, y} = a + b;          // 9-bit result: carry for free
    OP_SUB:  {carry, y} = a - b;          // 9th bit = borrow
    OP_AND:  y = a & b;
    OP_NOR:  y = ~(a | b);
    OP_SHL:  y = a << b[2:0];
    OP_SRA:  y = $signed(a) >>> b[2:0];   // keeps the sign
    OP_SLT:  y = {7'd0, $signed(a) < $signed(b)};
    OP_SLTU: y = {7'd0, a < b};
    ...
  endcase
end

assign zero = ~|y;
```

The testbench model does **not** use `>>>` or `$signed`. It converts values
to integers and uses simple arithmetic. When the design and a model written
in a different style agree on thousands of random inputs, both are very likely right.

```bash
make run DIR=examples/03-operators/alu8
```

## 12. Common mistakes

### Mistake 1: `!` instead of `~`

Wrong:

```verilog
assign inverted = !data;   // data is 8 bits. Result: 1 bit (8'd0 or 8'd1)
```

Fix:

```verilog
assign inverted = ~data;   // 8 bits, every bit inverted
```

### Mistake 2: losing the carry

Wrong:

```verilog
wire [7:0] sum;
wire       cout;
assign sum  = a + b;    // the carry is already lost here
assign cout = sum[8];   // sum has no bit 8
```

Why: `sum` is 8 bits, so the 9th bit of `a + b` is thrown away. `sum[8]` is
outside the vector. Icarus only warns, and `cout` is always `x`:

```text
warning: Constant bit select [8] is after vector sum[7:0].
       : Replacing select with a constant 1'bx.
```

Fix: let one assignment produce both parts:

```verilog
assign {cout, sum} = a + b;
```

### Mistake 3: mixing signed and unsigned

Wrong:

```verilog
wire signed [7:0]  x;
wire signed [15:0] y = x + 8'd1;   // 8'd1 is unsigned: x is zero-extended!
```

Fix: keep all operands signed:

```verilog
wire signed [15:0] y = x + 8'sd1;
```

### Mistake 4: `>>>` on an unsigned signal

Wrong:

```verilog
reg [7:0] sample;            // meant to be signed
assign half = sample >>> 1;  // fills with 0: a negative value becomes positive
```

Fix: declare it `reg signed [7:0] sample;`, or write `$signed(sample) >>> 1`.

### Mistake 5: precedence of `&` and `==`

Wrong:

```verilog
if (flags & MASK == 8'h00) ...   // means flags & (MASK == 8'h00)
```

Fix:

```verilog
if ((flags & MASK) == 8'h00) ...
```

## 13. Exercises

1. [`ex1-parity-and-popcount`](../exercises/03-operators/ex1-parity-and-popcount/):
   compute the parity and the number of ones of a byte.
2. [`ex2-saturating-add`](../exercises/03-operators/ex2-saturating-add/):
   unsigned and signed saturating adders.
3. (No solution.) Add an `OP_ROL` (rotate left) to the ALU, using concatenation.
   Extend the testbench model and run it.

## Summary

- Bitwise operators work per bit. Logical operators give 1 bit. Reduction
  operators fold a vector into 1 bit.
- Operands are extended to the width of the largest operand or the target,
  **before** the operation. Use `{cout, sum} = a + b` to keep carries.
- An expression is signed only if **all** operands are signed. Part selects
  and concatenations are always unsigned.
- `>>>` keeps the sign only for signed operands.
- Use parentheses when you mix `&`, `|` and comparisons.

Next: [04 - Combinational logic](04-combinational-logic.md).
