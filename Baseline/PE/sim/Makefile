DIR ?= copy

run:
	@cd $(DIR) && vcs -sverilog -f $(DIR).f -full64 -R -debug_access+all

clean:
	@echo "Cleaning current directory and all subdirectories..."
	# Remove directories named csrc, simv, or simv.daidir recursively
	@find . -type d \( -name csrc -o -name simv -o -name simv.daidir \) -exec rm -rf {} +
	# Remove files matching patterns recursively
	@find . -type f \( -name "ucli.key" -o -name "run.saif" -o -name "*.fsdb" -o -name "*.vcd" -o -name "*.vdd" \) -exec rm -f {} +