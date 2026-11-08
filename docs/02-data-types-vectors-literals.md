# 02 - Data types, vectors and literals

**Reading time:** about 30 minutes.

## Goals

After this chapter you can:

- explain the four values `0`, `1`, `x` and `z`,
- choose between `wire`, `reg` and `integer` without guessing,
- declare vectors and take bits and parts of them, also with `+:` and `-:`,
- write literals with the right size and base,
- predict what happens when widths do not match.

## 1. Four values, not two

A signal in Verilog simulation has one of **four** values:

| Value | Meaning | Where it comes from |
|---|---|---|
| `0` | logic low | |
| `1` | logic high | |
| `x` | unknown | a `reg` that was never written, two drivers that disagree, logic on an `x` input |
| `z` | high impedance (not driven) | a tri-state driver that is off, an unconnected input |

Real hardware has only 0 and 1 (and analog values between). `x` and `z` exist
so that the **simulator can tell you** that something is not defined.
An `x` in the waveform is a gift: it points to a bug, such as a missing reset
or an unconnected input. Do not hide it.

`x` spreads through logic, but only when it matters:

```text
0 & x = 0     (0 AND anything is 0)
1 & x = x
1 | x = 1     (1 OR anything is 1)
0 | x = x
~x    = x
~z    = x     (a gate input that floats gives an unknown output)
```

## 2. Nets and variables

Verilog has two families of data types.

**Nets** (`wire`) are connections. A net has no memory. Its value is always
computed from its **drivers**: an `assign`, the output of an instance, or a
port. A net with no driver is `z`. A net may have several drivers (see the
tri-state example).

**Variables** (`reg`, `integer`, `time`, `real`) **hold** the last value
written to them. They are written only inside procedural blocks
(`initial` and `always`).

The rule for choosing is simple. It depends only on **how** you assign the signal:

| You assign it with... | Declare it as |
|---|---|
| `assign`, or it is the output of an instance | `wire` |
| `=` or `<=` inside `always` or `initial` | `reg` (or `integer`) |
| nothing: it is an input port | `wire` (always) |

Whether the hardware becomes a flip-flop or plain gates does **not** depend on
`wire` or `reg`. It depends on the `always` block (chapters 04 and 05).
Both of these are pure combinational logic:

```verilog
wire y1;
assign y1 = a & b;

reg y2;
always @(*) y2 = a & b;   // reg, but no flip-flop
```

### Short form: a wire with its assignment

```verilog
wire [4:0] r5 = pix[15:11];   // same as: wire [4:0] r5; assign r5 = pix[15:11];
```

This is called a *net declaration assignment*. It is a continuous
assignment, not an initial value. (For a `reg`, `reg x = 0;` is an
initial value, and it is for simulation only. See chapter 10.)

### The other variable types

| Type | Size | Use it for |
|---|---|---|
| `reg [N-1:0]` | N bits, unsigned | design signals assigned in `always` |
| `integer` | 32 bits, **signed** | loop counters, error counters in testbenches |
| `time` | 64 bits, unsigned | storing `$time` |
| `real` | 64-bit floating point | testbench calculations only (not synthesizable) |

In design code, use `reg` with an explicit width. `integer` is fine for `for`
loop counters (chapter 07) because synthesis removes them.

## 3. Vectors

A **vector** is a signal with more than one bit:

```verilog
wire [7:0]  data;   // 8 bits, data[7] is the MSB, data[0] is the LSB
reg  [15:0] count;
wire        flag;   // a scalar: 1 bit
```

Always declare vectors as `[MSB:LSB]` with LSB = 0. You can declare
`[0:7]` (MSB is bit 0), but mixing both orders creates confusing bugs.

### Selecting bits

```verilog
wire [31:0] word;

word[31]        // bit select: one bit
word[15:8]      // part select: bits 15 down to 8 (constant bounds)
word[i]         // bit select with a variable index: a multiplexer in hardware
word[8*k +: 8]  // indexed part select: 8 bits starting at bit 8*k, going UP
word[23 -: 8]   // indexed part select: 8 bits starting at bit 23, going DOWN (23:16)
```

The indexed part select (`+:` and `-:`) is new in Verilog-2001. It solves
a real problem: `word[8*k+7 : 8*k]` is **illegal**, because the bounds of a
normal part select must be constants. With `+:`, the start can change, and
only the width must be a constant.

### Example: byte select and byte swap

Files: [`examples/02-data-types-vectors-literals/field-extract/`](../examples/02-data-types-vectors-literals/field-extract/)

```verilog
module field_extract (
  input  wire [31:0] word,
  input  wire [1:0]  byte_sel,
  output wire [7:0]  byte_out,
  output wire [31:0] swapped,
  output wire        msb,
  output wire [3:0]  top_nibble
);
  assign byte_out   = word[byte_sel*8 +: 8];
  assign swapped    = {word[7:0], word[15:8], word[23:16], word[31:24]};
  assign msb        = word[31];
  assign top_nibble = word[31:28];
endmodule
```

```text
word     = DE AD BE EF
byte_sel = 0 -> EF   1 -> BE   2 -> AD   3 -> DE
swapped  = EF BE AD DE
```

The concatenation `{a, b, c}` puts `a` in the most significant position.
Concatenation is also allowed on the **left** side of an assignment:

```verilog
assign {cout, sum} = a + b + cin;   // the top bit goes to cout
```

## 4. Literals

A literal is a constant number. The full form is:

```text
<size>'<base><digits>      size in bits, base: b, o, d, h
```

```verilog
8'b1010_0101   // binary. Underscores are ignored: use them for readability.
8'hA5          // hex, same value
8'd165         // decimal, same value
8'o245         // octal, same value
4'b10x1        // x and z digits are allowed in b, o and h
16'hBEEF
-8'd5          // the two's complement of 5 in 8 bits: 8'hFB
8'sd100        // a SIGNED literal (the s makes it signed)
"hello"        // a string: 5 characters x 8 bits = 40 bits
```

### Unsized literals are 32 bits

`5`, `'hFF` and `'b1` have no size. Verilog treats them as **at least 32 bits**.
`5` is also signed. That is usually fine on the right side of an expression,
but not inside a concatenation: `{a, 1}` is an error, because every operand of
`{ }` must have a known size. Write `{a, 1'b1}`.

### Filling with x and z

If the leftmost digit of a literal is `x` or `z`, it fills the remaining bits
of **that literal**:

```verilog
8'bx    // xxxxxxxx
8'bz1   // zzzzzzz1
8'b1x   // 0000001x   (the left digit is 1, so the fill is 0)
```

## 5. Width rules: extension and truncation

When you assign a value to a signal of a different width:

- **Wider target:** the value is extended on the left. An unsigned value gets
  zeros. A signed value (if the whole right side is signed) gets copies of its sign bit.
- **Narrower target:** the high bits are cut off (truncated). No error, often no warning.

```verilog
reg [7:0] r8;
reg [3:0] r4;

r8 = 4'hF;          // r8 = 8'h0F (zero-extended)
r8 = 32'h12345678;  // r8 = 8'h78 (truncated)
r8 = 4'bx;          // r8 = 8'b0000xxxx (the literal is 4 bits, then zero-extended)
```

The literals example tests every rule in this chapter. Run it and read the output:

Files: [`examples/02-data-types-vectors-literals/literals/`](../examples/02-data-types-vectors-literals/literals/)

```bash
make run DIR=examples/02-data-types-vectors-literals/literals
```

## 6. Signed values

By default, every vector is **unsigned**. To treat the bits as a two's
complement number, add `signed`:

```verilog
reg  signed [7:0]  s8;     // range -128 .. 127
wire signed [15:0] acc;
input wire signed [7:0] sample;
```

`signed` changes how operators like `<`, `>>>` and `*` work, and how
values are extended. The bits stored are the same. Chapter 03 explains the
details. One warning now: if any operand of an expression is unsigned, the
whole expression is unsigned. Chapter 12 shows how this breaks multipliers.

## 7. Strings

A string is a vector of 8-bit ASCII codes. The **last** character is in the
lowest 8 bits:

```verilog
reg [8*5:1] text;     // room for 5 characters
text = "hello";       // text[8:1] = "o", text[40:33] = "h"
$display("%s", text); // prints hello
```

Strings are used only in testbenches, for messages and file names.

## 8. Tri-state and multiple drivers

A `wire` can have several drivers. The simulator resolves them:
`z` loses against `0` or `1`, and `0` against `1` gives `x`.

Files: [`examples/02-data-types-vectors-literals/tristate-bus/`](../examples/02-data-types-vectors-literals/tristate-bus/)

```verilog
assign bus = en ? data : 8'bz;   // drive the bus only when enabled
```

```text
data_a = 11110000, data_b = 10101010, both enabled:
bus    = 1x1xx0x0      (x where the bits disagree)
```

Inside an FPGA there are no internal tri-state buses. Use a multiplexer.
Tri-state is for I/O pins.

## 9. Printing values

The format codes of `$display` are worth knowing by heart:

| Code | Prints | Example output for `8'd10` |
|---|---|---|
| `%b` | binary | `00001010` |
| `%h` | hex | `0a` |
| `%d` | decimal, padded to the widest value | ` 10` |
| `%0d` | decimal, no padding | `10` |
| `%s` | string | |
| `%t` | time | |

All codes show `x` and `z`, but with different detail. For `8'b0000_10x1`:

```text
%b -> 000010x1     every bit
%h -> 0X           capital X: only SOME bits of this hex digit are x
%d ->   X          the whole number is unknown
```

For debugging, prefer `%b` or `%h`.

## 10. Common mistakes

### Mistake 1: `wire` assigned in an `always` block

Wrong:

```verilog
wire y;
always @(*) y = a & b;
```

```text
error: y is not a valid l-value in top.
     : y is declared here as wire.
```

Why: procedural blocks can only write variables.
Fix: declare `reg y;` or use `assign y = a & b;` with the `wire`.

### Mistake 2: a variable part select with `[ : ]`

Wrong:

```verilog
assign byte_out = word[8*k+7 : 8*k];   // bounds must be constant
```

```text
error: A reference to a wire or reg (`k') is not allowed in a constant expression.
error: Part select expressions must be constant.
```

Fix: use the indexed part select. The width is constant, the start may change:

```verilog
assign byte_out = word[8*k +: 8];
```

### Mistake 3: unsized constants in a concatenation

Wrong:

```verilog
assign y = {a, 0};       // 0 has no size
```

```text
error: Concatenation operand "'sd0" has indefinite width.
```

Fix: always give a size inside `{ }`:

```verilog
assign y = {a, 1'b0};
```

### Mistake 4: silent truncation

Wrong:

```verilog
reg [3:0] sum;
always @(*) sum = a + b;   // a and b are 4 bits. 15 + 1 = 0, the carry is lost.
```

Why: the result of `a + b` is cut to 4 bits. There is no error.
Fix: make the target one bit wider: `reg [4:0] sum;`. Chapter 03 explains the
width rules of expressions.

### Mistake 5: hiding x with `==`

Wrong:

```verilog
if (y == 1'b1) ... else $display("y is 0");   // also taken when y is x!
```

Fix: in testbenches, use `===` and `!==`. They compare `x` and `z` exactly.

## 11. Exercises

1. [`ex1-sign-extend`](../exercises/02-data-types-vectors-literals/ex1-sign-extend/):
   build zero extension and sign extension from 8 to 16 bits.
2. [`ex2-rgb565-to-888`](../exercises/02-data-types-vectors-literals/ex2-rgb565-to-888/):
   unpack a 16-bit RGB565 pixel into three 8-bit colors.
3. (No solution.) In the literals example, add a check for `16'shFF80` assigned to
   an `integer`. Predict the value first. Is it -128 or 65408? Why?

## Summary

- Four values: `0`, `1`, `x` (unknown) and `z` (not driven). `x` points to bugs.
- `wire` for `assign` and instance outputs. `reg` for `always` and `initial`.
  `reg` is not the same as a flip-flop.
- Vectors are `[MSB:0]`. Use `+:` for a variable start position.
- Give every literal a size. Unsized literals are 32 bits.
- Wider targets extend, narrower targets truncate, silently.

Next: [03 - Operators](03-operators.md).
