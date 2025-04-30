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

add wave -position insertpoint  \
sim:/tree_tb/dut/node1_1_in/status \
sim:/tree_tb/dut/node1_1_in/req \
sim:/tree_tb/dut/node1_1_in/ack \
sim:/tree_tb/dut/node1_1_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node1_1_out/status \
sim:/tree_tb/dut/node1_1_out/req \
sim:/tree_tb/dut/node1_1_out/ack \
sim:/tree_tb/dut/node1_1_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node1_2_in/status \
sim:/tree_tb/dut/node1_2_in/req \
sim:/tree_tb/dut/node1_2_in/ack \
sim:/tree_tb/dut/node1_2_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node1_2_out/status \
sim:/tree_tb/dut/node1_2_out/req \
sim:/tree_tb/dut/node1_2_out/ack \
sim:/tree_tb/dut/node1_2_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node2_1_in/status \
sim:/tree_tb/dut/node2_1_in/req \
sim:/tree_tb/dut/node2_1_in/ack \
sim:/tree_tb/dut/node2_1_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node2_1_out/status \
sim:/tree_tb/dut/node2_1_out/req \
sim:/tree_tb/dut/node2_1_out/ack \
sim:/tree_tb/dut/node2_1_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node2_2_in/status \
sim:/tree_tb/dut/node2_2_in/req \
sim:/tree_tb/dut/node2_2_in/ack \
sim:/tree_tb/dut/node2_2_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node2_2_out/status \
sim:/tree_tb/dut/node2_2_out/req \
sim:/tree_tb/dut/node2_2_out/ack \
sim:/tree_tb/dut/node2_2_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node3_1_in/status \
sim:/tree_tb/dut/node3_1_in/req \
sim:/tree_tb/dut/node3_1_in/ack \
sim:/tree_tb/dut/node3_1_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node3_1_out/status \
sim:/tree_tb/dut/node3_1_out/req \
sim:/tree_tb/dut/node3_1_out/ack \
sim:/tree_tb/dut/node3_1_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node3_2_in/status \
sim:/tree_tb/dut/node3_2_in/req \
sim:/tree_tb/dut/node3_2_in/ack \
sim:/tree_tb/dut/node3_2_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node3_2_out/status \
sim:/tree_tb/dut/node3_2_out/req \
sim:/tree_tb/dut/node3_2_out/ack \
sim:/tree_tb/dut/node3_2_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node4_1_in/status \
sim:/tree_tb/dut/node4_1_in/req \
sim:/tree_tb/dut/node4_1_in/ack \
sim:/tree_tb/dut/node4_1_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node4_1_out/status \
sim:/tree_tb/dut/node4_1_out/req \
sim:/tree_tb/dut/node4_1_out/ack \
sim:/tree_tb/dut/node4_1_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node4_2_in/status \
sim:/tree_tb/dut/node4_2_in/req \
sim:/tree_tb/dut/node4_2_in/ack \
sim:/tree_tb/dut/node4_2_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node4_2_out/status \
sim:/tree_tb/dut/node4_2_out/req \
sim:/tree_tb/dut/node4_2_out/ack \
sim:/tree_tb/dut/node4_2_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node5_1_in/status \
sim:/tree_tb/dut/node5_1_in/req \
sim:/tree_tb/dut/node5_1_in/ack \
sim:/tree_tb/dut/node5_1_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node5_1_out/status \
sim:/tree_tb/dut/node5_1_out/req \
sim:/tree_tb/dut/node5_1_out/ack \
sim:/tree_tb/dut/node5_1_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node5_2_in/status \
sim:/tree_tb/dut/node5_2_in/req \
sim:/tree_tb/dut/node5_2_in/ack \
sim:/tree_tb/dut/node5_2_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node5_2_out/status \
sim:/tree_tb/dut/node5_2_out/req \
sim:/tree_tb/dut/node5_2_out/ack \
sim:/tree_tb/dut/node5_2_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node6_1_in/status \
sim:/tree_tb/dut/node6_1_in/req \
sim:/tree_tb/dut/node6_1_in/ack \
sim:/tree_tb/dut/node6_1_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node6_1_out/status \
sim:/tree_tb/dut/node6_1_out/req \
sim:/tree_tb/dut/node6_1_out/ack \
sim:/tree_tb/dut/node6_1_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node6_2_in/status \
sim:/tree_tb/dut/node6_2_in/req \
sim:/tree_tb/dut/node6_2_in/ack \
sim:/tree_tb/dut/node6_2_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node6_2_out/status \
sim:/tree_tb/dut/node6_2_out/req \
sim:/tree_tb/dut/node6_2_out/ack \
sim:/tree_tb/dut/node6_2_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node7_1_in/status \
sim:/tree_tb/dut/node7_1_in/req \
sim:/tree_tb/dut/node7_1_in/ack \
sim:/tree_tb/dut/node7_1_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node7_1_out/status \
sim:/tree_tb/dut/node7_1_out/req \
sim:/tree_tb/dut/node7_1_out/ack \
sim:/tree_tb/dut/node7_1_out/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node7_2_in/status \
sim:/tree_tb/dut/node7_2_in/req \
sim:/tree_tb/dut/node7_2_in/ack \
sim:/tree_tb/dut/node7_2_in/data
add wave -position insertpoint  \
sim:/tree_tb/dut/node7_2_out/status \
sim:/tree_tb/dut/node7_2_out/req \
sim:/tree_tb/dut/node7_2_out/ack \
sim:/tree_tb/dut/node7_2_out/data


add wave -position insertpoint  \
sim:/tree_tb/L0/status \
sim:/tree_tb/L0/req \
sim:/tree_tb/L0/ack \
sim:/tree_tb/L0/data
add wave -position insertpoint  \
sim:/tree_tb/L1/status \
sim:/tree_tb/L1/req \
sim:/tree_tb/L1/ack \
sim:/tree_tb/L1/data
add wave -position insertpoint  \
sim:/tree_tb/L2/status \
sim:/tree_tb/L2/req \
sim:/tree_tb/L2/ack \
sim:/tree_tb/L2/data
add wave -position insertpoint  \
sim:/tree_tb/L3/status \
sim:/tree_tb/L3/req \
sim:/tree_tb/L3/ack \
sim:/tree_tb/L3/data
add wave -position insertpoint  \
sim:/tree_tb/L4/status \
sim:/tree_tb/L4/req \
sim:/tree_tb/L4/ack \
sim:/tree_tb/L4/data
add wave -position insertpoint  \
sim:/tree_tb/L5/status \
sim:/tree_tb/L5/req \
sim:/tree_tb/L5/ack \
sim:/tree_tb/L5/data
add wave -position insertpoint  \
sim:/tree_tb/L6/status \
sim:/tree_tb/L6/req \
sim:/tree_tb/L6/ack \
sim:/tree_tb/L6/data
add wave -position insertpoint  \
sim:/tree_tb/L7/status \
sim:/tree_tb/L7/req \
sim:/tree_tb/L7/ack \
sim:/tree_tb/L7/data
add wave -position insertpoint  \
sim:/tree_tb/R0/status \
sim:/tree_tb/R0/req \
sim:/tree_tb/R0/ack \
sim:/tree_tb/R0/data
add wave -position insertpoint  \
sim:/tree_tb/R1/status \
sim:/tree_tb/R1/req \
sim:/tree_tb/R1/ack \
sim:/tree_tb/R1/data
add wave -position insertpoint  \
sim:/tree_tb/R2/status \
sim:/tree_tb/R2/req \
sim:/tree_tb/R2/ack \
sim:/tree_tb/R2/data
add wave -position insertpoint  \
sim:/tree_tb/R3/status \
sim:/tree_tb/R3/req \
sim:/tree_tb/R3/ack \
sim:/tree_tb/R3/data
add wave -position insertpoint  \
sim:/tree_tb/R4/status \
sim:/tree_tb/R4/req \
sim:/tree_tb/R4/ack \
sim:/tree_tb/R4/data
add wave -position insertpoint  \
sim:/tree_tb/R5/status \
sim:/tree_tb/R5/req \
sim:/tree_tb/R5/ack \
sim:/tree_tb/R5/data
add wave -position insertpoint  \
sim:/tree_tb/R6/status \
sim:/tree_tb/R6/req \
sim:/tree_tb/R6/ack \
sim:/tree_tb/R6/data
add wave -position insertpoint  \
sim:/tree_tb/R7/status \
sim:/tree_tb/R7/req \
sim:/tree_tb/R7/ack \
sim:/tree_tb/R7/data

run -all
