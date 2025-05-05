quit -sim
vlib work
vmap work work

vlog -work work ../PE_tree/SystemVerilogCSP.sv
vlog -work work ../router_tree/input_buffer.sv
vlog -work work ../router_tree/output_buffer.sv
vlog -work work ../router_tree/copy_tree.sv
vlog -work work ../router_tree/arbiter_tree.sv
vlog -work work ../router_tree/merge_tree.sv
vlog -work work ../router_tree/arbiter_merge.sv
vlog -work work ../router_tree/input_ctrl.sv
vlog -work work ../router_tree/output_ctrl.sv
vlog -work work ../router_tree/router.sv
vlog -work work ../router_tree/tree.sv

vlog -work work ../PE_tree/PE.sv
vlog -work work ../PE_tree/depacketizer.sv
vlog -work work ../PE_tree/split.sv
vlog -work work ../PE_tree/special_split.sv
vlog -work work ../PE_tree/priority_mux.sv
vlog -work work ../PE_tree/copy.sv
vlog -work work ../PE_tree/copy4.sv
vlog -work work ../PE_tree/conditional_copy.sv
vlog -work work ../PE_tree/mac.sv
vlog -work work ../PE_tree/spike_residue.sv
vlog -work work ../PE_tree/two_input_adder.sv
vlog -work work ../PE_tree/merge.sv
vlog -work work ../PE_tree/packetizer.sv
vlog -work work ../PE_tree/buffer.sv

vlog -work work top_tb.sv

vsim -novopt work.top_tb
run -all
