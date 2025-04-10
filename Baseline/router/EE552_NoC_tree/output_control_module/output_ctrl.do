quit -sim

vlog -work work SystemVerilogCSP.sv arbiter.sv output_ctrl.sv output_ctrl_tb.sv
vlog -work work data_generator.sv data_bucket.sv
vlog -work work copy.sv
vlog -work work arbiter.sv
vlog -work work merge.sv
vlog -work work arbiter_merge.sv

vsim -novopt work.output_ctrl_tb



run -all