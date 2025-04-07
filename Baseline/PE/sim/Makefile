FILENAME ?= top.f

run:
	vcs -sverilog -f $(FILENAME) -full64 -R -debug_access+all

clean:
	rm -rf csrc simv simv.daidir ucli.key run.saif *.fsdb *.vcd *.vdd
