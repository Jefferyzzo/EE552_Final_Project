quit -sim
vlib work
vmap work work

vlog -work work ../PE_tree_gated/SystemVerilogCSP.sv
vlog -work work ../router_tree_gated/input_buffer.sv
vlog -work work ../router_tree_gated/output_buffer.sv
vlog -work work ../router_tree_gated/copy_tree.sv
vlog -work work ../router_tree_gated/arbiter_tree.sv
vlog -work work ../router_tree_gated/merge_tree.sv
vlog -work work ../router_tree_gated/arbiter_merge.sv
vlog -work work ../router_tree_gated/input_ctrl_gate.sv
vlog -work work ../router_tree_gated/delay_element.sv
vlog -work work ../router_tree_gated/click_controller.sv
vlog -work work ../router_tree_gated/output_ctrl.sv
vlog -work work ../router_tree_gated/router.sv
vlog -work work ../router_tree_gated/tree.sv

vlog -work work ../PE_tree_gated/PE.sv
vlog -work work ../PE_tree_gated/depacketizer.sv
vlog -work work ../PE_tree_gated/split.sv
vlog -work work ../PE_tree_gated/special_split.sv
vlog -work work ../PE_tree_gated/priority_mux.sv
vlog -work work ../PE_tree_gated/copy.sv
vlog -work work ../PE_tree_gated/copy4.sv
vlog -work work ../PE_tree_gated/conditional_copy.sv
vlog -work work ../PE_tree_gated/mac.sv
vlog -work work ../PE_tree_gated/spike_residue.sv
vlog -work work ../PE_tree_gated/two_input_adder.sv
vlog -work work ../PE_tree_gated/merge.sv
vlog -work work ../PE_tree_gated/packetizer.sv
vlog -work work ../PE_tree_gated/buffer.sv

vlog -work work top_tb.sv

vsim -novopt work.top_tb


add wave -position insertpoint  \
sim:/top_tb/dut/node4/child1_parent/data
add wave -position insertpoint  \
sim:/top_tb/dut/node4/child1_child2/data
add wave -position insertpoint  \
sim:/top_tb/dut/node2_1_in/data
add wave -position insertpoint  \
sim:/top_tb/dut/node2/child1_parent/data
add wave -position insertpoint  \
sim:/top_tb/dut/node2/child1_child2/data
add wave -position insertpoint  \
sim:/top_tb/dut/node1_1_in/data
add wave -position insertpoint  \
sim:/top_tb/dut/node1/child1_child2/data
add wave -position insertpoint  \
sim:/top_tb/dut/node3_1_in/data
add wave -position insertpoint  \
sim:/top_tb/dut/node3/child1_parent/data
add wave -position insertpoint  \
sim:/top_tb/dut/node3/child1_child2/data
add wave -position insertpoint  \
sim:/top_tb/dut/node2_2_out/data
add wave -position insertpoint  \
sim:/top_tb/dut/node5/parent_child1/data
add wave -position insertpoint  \
sim:/top_tb/dut/node5/parent_child2/data
add wave -position insertpoint  \
sim:/top_tb/dut/node4/child2_out/status \
sim:/top_tb/dut/node4/child2_out/req \
sim:/top_tb/dut/node4/child2_out/ack \
sim:/top_tb/dut/node4/child2_out/data
run -all
