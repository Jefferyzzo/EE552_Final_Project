run:
	vcs -sverilog -f $(file) -full64 -R -debug_access+all

clean:
	rm -rf csrc simv simv.daidir ucli.key run.saif *.fsdb *.vcd *.vdd

%:
	make run file=$@
