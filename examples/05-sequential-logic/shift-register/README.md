# Example: 8-bit shift register

Serial in, parallel out (SIPO) and parallel in, serial out (PISO) in one module.
This is the core of a UART or SPI interface.

## Run

```bash
make run DIR=examples/05-sequential-logic/shift-register
```

## Shifting 1011_0010 in, MSB first

```text
edge   serial_in   q
 1        1        0000_0001
 2        0        0000_0010
 3        1        0000_0101
 4        1        0000_1011
 5        0        0001_0110
 6        0        0010_1100
 7        1        0101_1001
 8        0        1011_0010
```

The whole shift is one line: `q <= {q[6:0], serial_in};`.
