# Exercise 06.2: Mealy detector for 101

## Task

Complete `detect101.v`. It is a **Mealy** FSM with a serial input `din`.
The output `found` is 1 **in the same cycle** as the last bit of the pattern
`101`. Overlapping patterns count: `10101` contains the pattern twice.

```text
clk edge   1  2  3  4  5  6  7
din        1  0  1  0  1  1  0
found      0  0  1  0  1  0  0
```

## Steps

1. Draw the state diagram first. How many states do you need?
   (Hint: in a Mealy machine, the last bit is not stored as a state.)
2. Write the state register and the next-state logic.
3. Write `found` as a function of `state` **and** `din`.

## Questions to think about

- How many states would a Moore version need?
- In which cycle would the Moore output be 1?

## Run

```bash
make run DIR=exercises/06-fsm/ex2-mealy-detector
```
