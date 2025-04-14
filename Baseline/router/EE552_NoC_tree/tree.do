quit -sim
vlib work
vmap work work

vlog -work work SystemVerilogCSP.sv
vlog -work work data_bucket.sv
vlog -work work data_generator.sv
vlog -work work arbiter.sv
vlog -work work merge.sv
vlog -work work arbiter_merge.sv
vlog -work work input_ctrl.sv
vlog -work work output_ctrl.sv

vlog -work work router.sv
vlog -work work tree.sv
vlog -work work tree_tb.sv



vsim -novopt work.tree_tb


run -all
