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
vlog -work work router_tb.sv



vsim -novopt work.router_tb

add wave -position insertpoint  \
sim:/router_tb/L0/status \
sim:/router_tb/L0/req \
sim:/router_tb/L0/ack \
sim:/router_tb/L0/data

add wave -position insertpoint  \
sim:/router_tb/L1/status \
sim:/router_tb/L1/req \
sim:/router_tb/L1/ack \
sim:/router_tb/L1/data

add wave -position insertpoint  \
sim:/router_tb/L2/status \
sim:/router_tb/L2/req \
sim:/router_tb/L2/ack \
sim:/router_tb/L2/data

add wave -position insertpoint  \
sim:/router_tb/R0/status \
sim:/router_tb/R0/req \
sim:/router_tb/R0/ack \
sim:/router_tb/R0/data

add wave -position insertpoint  \
sim:/router_tb/R1/status \
sim:/router_tb/R1/req \
sim:/router_tb/R1/ack \
sim:/router_tb/R1/data

add wave -position insertpoint  \
sim:/router_tb/R2/status \
sim:/router_tb/R2/req \
sim:/router_tb/R2/ack \
sim:/router_tb/R2/data

add wave -position insertpoint  \
sim:/router_tb/dut/child2_parent/status \
sim:/router_tb/dut/child2_parent/req \
sim:/router_tb/dut/child2_parent/ack \
sim:/router_tb/dut/child2_parent/data
add wave -position insertpoint  \
sim:/router_tb/dut/child2_child1/status \
sim:/router_tb/dut/child2_child1/req \
sim:/router_tb/dut/child2_child1/ack \
sim:/router_tb/dut/child2_child1/data

run -all
