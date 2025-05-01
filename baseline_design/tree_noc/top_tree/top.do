quit -sim
vlib work
vmap work work

vlog -work work ../PE/SystemVerilogCSP.sv
vlog -work work ../router_tree/input_buffer.sv
vlog -work work ../router_tree/output_buffer.sv
vlog -work work ../router_tree/copy_tree.sv
vlog -work work ../router_tree/arbiter_tree.sv
vlog -work work ../router_tree/merge_tree.sv
vlog -work work ../router_tree/arbiter_merge.sv
vlog -work work ../router_tree/input_ctrl_gate.sv
vlog -work work ../router_tree/delay_element.sv
vlog -work work ../router_tree/click_controller.sv
vlog -work work ../router_tree/output_ctrl.sv
vlog -work work ../router_tree/router.sv
vlog -work work ../router_tree/tree.sv

vlog -work work ../PE/PE.sv
vlog -work work ../PE/depacketizer.sv
vlog -work work ../PE/split.sv
vlog -work work ../PE/special_split.sv
vlog -work work ../PE/priority_mux.sv
vlog -work work ../PE/copy.sv
vlog -work work ../PE/copy4.sv
vlog -work work ../PE/conditional_copy.sv
vlog -work work ../PE/mac.sv
vlog -work work ../PE/spike_residue.sv
vlog -work work ../PE/two_input_adder.sv
vlog -work work ../PE/merge.sv
vlog -work work ../PE/packetizer.sv
vlog -work work ../PE/buffer.sv

vlog -work work top_tb.sv

vsim -novopt work.top_tb
run -all
