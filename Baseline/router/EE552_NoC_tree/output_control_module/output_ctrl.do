quit -sim

vlog -work work SystemVerilogCSP.sv arbiter.sv output_ctrl.sv output_ctrl_tb.sv
vlog -work work data_bucket.sv
vlog -work work copy.sv
vlog -work work arbiter.sv
vlog -work work merge.sv
vlog -work work arbiter_merge.sv

vsim -novopt work.output_ctrl_tb

add wave -position insertpoint  \
sim:/output_ctrl_tb/L0/status \
sim:/output_ctrl_tb/L0/req \
sim:/output_ctrl_tb/L0/ack \
sim:/output_ctrl_tb/L0/data
add wave -position insertpoint  \
sim:/output_ctrl_tb/L1/status \
sim:/output_ctrl_tb/L1/req \
sim:/output_ctrl_tb/L1/ack \
sim:/output_ctrl_tb/L1/data
add wave -position insertpoint  \
sim:/output_ctrl_tb/R/status \
sim:/output_ctrl_tb/R/req \
sim:/output_ctrl_tb/R/ack \
sim:/output_ctrl_tb/R/data



run -all