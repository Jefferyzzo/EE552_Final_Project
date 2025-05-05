DIR ?= top

all: run extract check  
run:
	@echo "[RUN] Simulating design..."
	@vcs -sverilog -f $(DIR).f -full64 -R -debug_access+all | tee sim.log
	@find . -type d \( -name csrc -o -name simv -o -name simv.daidir \) -exec rm -rf {} +
	@find . -type f \( -name "ucli.key" -o -name "simv" -o -name "run.saif" -o -name "*.fsdb" -o -name "*.vcd" -o -name "*.vdd" \) -exec rm -f {} +

extract:
	@echo "Extract outspike and residue "
	@grep "DB" sim.log | awk '{ if (substr($$7, length($$7), 1) == "0") print substr($$7, 15) }' > timestep1.txt
	@awk '{ y = substr($$0, 1, 6); x = substr($$0, 7, 6);  print x "_" y "_" $$0; }' timestep1.txt | sort -t_ -k2,2 -k1,1 | awk -F_ '{ print $$3 }' > test1.txt	
	@awk '{ bin = substr($$0, 13, 13); cmd = "echo \"ibase=2;" bin "\" | bc"; cmd | getline dec; close(cmd); print dec }' test1.txt > timestep1_residue.txt
	@awk '{ bin = substr($$0, 30, 1); cmd = "echo \"ibase=2;" bin "\" | bc"; cmd | getline dec; close(cmd); print dec }' test1.txt > timestep1_outspike.txt
	@grep "DB" sim.log | awk '{ if (substr($$7, length($$7), 1) == "1") print substr($$7, 15) }' > timestep2.txt
	@awk '{ y = substr($$0, 1, 6); x = substr($$0, 7, 6);  print x "_" y "_" $$0; }' timestep2.txt | sort -t_ -k2,2 -k1,1 | awk -F_ '{ print $$3 }' > test2.txt	
	@awk '{ bin = substr($$0, 13, 13); cmd = "echo \"ibase=2;" bin "\" | bc"; cmd | getline dec; close(cmd); print dec }' test2.txt > timestep2_residue.txt
	@awk '{ bin = substr($$0, 30, 1); cmd = "echo \"ibase=2;" bin "\" | bc"; cmd | getline dec; close(cmd); print dec }' test2.txt > timestep2_outspike.txt
	@rm -rf test1.txt test2.txt timestep1.txt timestep2.txt

check:
	@echo "compare simulation results to golden results"
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' scnn_script/L1_out_spike_t1.txt > .file1_clean
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' timestep1_outspike.txt > .file2_clean
	@cmp -s .file1_clean .file2_clean && echo "timestep1 outspike match"
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' scnn_script/L1_out_spike_t2.txt > .file1_clean
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' timestep2_outspike.txt > .file2_clean
	@cmp -s .file1_clean .file2_clean && echo "timestep2 outspike match"
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' scnn_script/L1_residue_t1.txt > .file1_clean
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' timestep1_residue.txt > .file2_clean
	@cmp -s .file1_clean .file2_clean && echo "timestep1 residue match"
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' scnn_script/L1_residue_t2.txt > .file1_clean
	@awk 'BEGIN{in_comment=0} \
		/^\s*\/\*/ { in_comment=1; next } \
		/\*\// { in_comment=0; next } \
		in_comment==0 && $$0 !~ /^\s*\/\// { print }' timestep2_residue.txt > .file2_clean
	@cmp -s .file1_clean .file2_clean && echo "timestep2 residue match"
	@rm -f .file1_clean .file2_clean


clean:
	@echo "[CLEAN] Cleaning current directory and all subdirectories..."
	@find . -type d \( -name csrc -o -name simv -o -name simv.daidir \) -exec rm -rf {} +
	@find . -type f \( -name "ucli.key" -o -name "simv" -o -name "run.saif" -o -name "*.fsdb" -o -name "*.vcd" -o -name "*.vdd" \) -exec rm -f {} +
	@rm -rf sim.log timestep*.txt

