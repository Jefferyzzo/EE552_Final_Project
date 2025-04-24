run:
	@vcs -sverilog -f top.f -full64 -debug_access+all -R 2>&1 | tee vcs_run.log

clean:
	@echo "Cleaning current directory and all subdirectories..."
	# Remove directories named csrc, simv, or simv.daidir recursively
	@find . -type d \( -name csrc -o -name simv -o -name simv.daidir \) -exec rm -rf {} +
	# Remove files matching patterns recursively
	@find . -type f \( -name "ucli.key" -o -name "simv" -o -name "run.saif" -o -name "*.fsdb" -o -name "*.vcd" -o -name "*.vdd" \) -exec rm -rf {} +