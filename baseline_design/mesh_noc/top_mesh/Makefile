# Tools & flags
VCS           := vcs
VCS_FLAGS     := -sverilog -f top.f -full64 -debug_access+all -R

# Logs & directories
SIM_LOG       := vcs_run.log
DB_LOG        := data_bucket_output.log
SCRIPT_DIR    := scnn_script
REF_DIR       := refs

# Raw golden files (may contain comments)
RES1_RAW      := $(SCRIPT_DIR)/L1_residue_t1.txt
RES2_RAW      := $(SCRIPT_DIR)/L1_residue_t2.txt
SPIKE1_RAW    := $(SCRIPT_DIR)/L1_out_spike_t1.txt
SPIKE2_RAW    := $(SCRIPT_DIR)/L1_out_spike_t2.txt

# Filtered golden references (numbers only)
RES1_REF      := $(REF_DIR)/res_ref_t0.txt
RES2_REF      := $(REF_DIR)/res_ref_t1.txt
SPIKE1_REF    := $(REF_DIR)/spk_ref_t0.txt
SPIKE2_REF    := $(REF_DIR)/spk_ref_t1.txt

all: run compare clean

# 1) run simulation
run:
	@$(VCS) $(VCS_FLAGS) 2>&1 | tee $(SIM_LOG)

# 2) strip comments from golden files and compare numeric results
compare: run
	@echo "► Preparing golden references (strip comments)…"
	@echo ""
	@grep -E '^-?[0-9]' $(RES1_RAW)   > $(RES1_REF)
	@grep -E '^-?[0-9]' $(RES2_RAW)   > $(RES2_REF)
	@grep -E '^-?[0-9]' $(SPIKE1_RAW) > $(SPIKE1_REF)
	@grep -E '^-?[0-9]' $(SPIKE2_RAW) > $(SPIKE2_REF)

	@echo "► Comparing Timestep 0 Residue…"
	@grep "Timestep = 0" $(DB_LOG) \
	  | awk -F 'Residue = ' '{print $$2}' \
	  | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$$//' \
	  > $(REF_DIR)/res_t0_got.txt
	@echo "Got values:" 
	@grep -vE '(^//|^/\*|^\s*$$)' $(REF_DIR)/res_t0_got.txt   | paste -d ' ' - -
	@echo "Golden values:"
	@grep -vE '(^//|^/\*|^\s*$$)' $(RES1_REF) | paste -d ' ' - -
	@if diff -q -w $(REF_DIR)/res_t0_got.txt $(RES1_REF); then \
		echo "✅ Timestep 0 Residue match!"; \
	else \
		echo "❌ Timestep 0 Residue mismatch!"; \
		diff -y -w $(RES1_REF) $(REF_DIR)/res_t0_got.txt; \
	fi
	@echo ""

	@echo "► Comparing Timestep 1 Residue…"
	@grep "Timestep = 1" $(DB_LOG) \
	  | awk -F 'Residue = ' '{print $$2}' \
	  | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$$//' \
	  > $(REF_DIR)/res_t1_got.txt
	@echo "Got values:"
	@grep -vE '(^//|^/\*|^\s*$$)' $(REF_DIR)/res_t1_got.txt   | paste -d ' ' - -
	@echo "Golden values:"
	@grep -vE '(^//|^/\*|^\s*$$)' $(RES2_REF) | paste -d ' ' - -
	@if diff -q -w $(REF_DIR)/res_t1_got.txt $(RES2_REF); then \
		echo "✅ Timestep 1 Residue match!"; \
	else \
		echo "❌ Timestep 1 Residue mismatch!"; \
		diff -y -w $(RES2_REF) $(REF_DIR)/res_t1_got.txt; \
	fi
	@echo ""

	@echo "► Comparing Timestep 0 Spike…"
	@grep "Timestep = 0" $(DB_LOG) \
	  | awk -F 'OutSpike = ' '{print $$2}' \
	  | awk -F ',' '{print $$1}' \
	  | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$$//' \
	  > $(REF_DIR)/spk_t0_got.txt
	@echo "Got values:"
	@grep -vE '(^//|^/\*|^\s*$$)' $(REF_DIR)/spk_t0_got.txt   | paste -d ' ' - -
	@echo "Golden values:"
	@grep -vE '(^//|^/\*|^\s*$$)' $(SPIKE1_REF) | paste -d ' ' - -
	@if diff -q -w $(REF_DIR)/spk_t0_got.txt $(SPIKE1_REF); then \
		echo "✅ Timestep 0 Spike match!"; \
	else \
		echo "❌ Timestep 0 Spike mismatch!"; \
		diff -y -w $(SPIKE1_REF) $(REF_DIR)/spk_t0_got.txt; \
	fi
	@echo ""

	@echo "► Comparing Timestep 1 Spike…"
	@grep "Timestep = 1" $(DB_LOG) \
	  | awk -F 'OutSpike = ' '{print $$2}' \
	  | awk -F ',' '{print $$1}' \
	  | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$$//' \
	  > $(REF_DIR)/spk_t1_got.txt
	@echo "Got values:"
	@grep -vE '(^//|^/\*|^\s*$$)' $(REF_DIR)/spk_t1_got.txt   | paste -d ' ' - -
	@echo "Golden values:"
	@grep -vE '(^//|^/\*|^\s*$$)' $(SPIKE1_REF) | paste -d ' ' - -
	@if diff -q -w $(REF_DIR)/spk_t1_got.txt $(SPIKE2_REF); then \
		echo "✅ Timestep 1 Spike match!"; \
	else \
		echo "❌ Timestep 1 Spike mismatch!"; \
		diff -y -w $(SPIKE2_REF) $(REF_DIR)/spk_t1_got.txt; \
	fi
	@echo ""

clean:
	@echo "Cleaning current directory and all subdirectories..."
	# Remove directories named csrc, simv, or simv.daidir recursively
	@find . -type d \( -name csrc -o -name simv -o -name simv.daidir \) -exec rm -rf {} +
	# Remove files matching patterns recursively
	@find . -type f \( -name "ucli.key" -o -name "simv" -o -name "run.saif" -o -name "*.fsdb" -o -name "*.vcd" -o -name "*.vdd" \) -exec rm -f {} +