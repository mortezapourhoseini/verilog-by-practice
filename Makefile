# Makefile for verilog-by-practice
#
#   make                  run all examples and solutions (same as: make test)
#   make examples         run only the examples
#   make solutions        run only the exercise solutions
#   make stubs            check that unsolved exercise stubs fail
#   make run DIR=<dir>    run the testbench in one directory
#   make wave DIR=<dir>   open the waveform of that directory in GTKWave
#   make lint             optional Verilator and Yosys checks
#   make clean            remove build outputs and waveforms

.PHONY: all test examples solutions stubs run wave lint clean

all: test

test:
	@./scripts/run_all.sh all

examples:
	@./scripts/run_all.sh examples

solutions:
	@./scripts/run_all.sh solutions

stubs:
	@./scripts/run_all.sh stubs

run:
	@test -n "$(DIR)" || (echo "Usage: make run DIR=examples/00-setup/mux2"; exit 2)
	@./scripts/run_one.sh $(DIR)

wave:
	@test -n "$(DIR)" || (echo "Usage: make wave DIR=examples/00-setup/mux2"; exit 2)
	gtkwave $(DIR)/tb_*.vcd &

lint:
	@./scripts/lint_all.sh

clean:
	rm -rf build
	find . -name '*.vcd' -delete
	find . -name '*.vvp' -delete
	find . -name '*_out.txt' -delete
