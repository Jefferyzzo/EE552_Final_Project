quit -sim

vlog -work work SystemVerilogCSP.sv input_ctrl.sv input_ctrl_tb.sv
vlog -work work data_generator.sv data_bucket.sv

vsim -novopt work.input_ctrl_tb

add wave -position insertpoint  \
sim:/input_ctrl_tb/L/status \
sim:/input_ctrl_tb/L/req \
sim:/input_ctrl_tb/L/ack \
sim:/input_ctrl_tb/L/data
add wave -position insertpoint  \
sim:/input_ctrl_tb/R0/status \
sim:/input_ctrl_tb/R0/req \
sim:/input_ctrl_tb/R0/ack \
sim:/input_ctrl_tb/R0/data
add wave -position insertpoint  \
sim:/input_ctrl_tb/R1/status \
sim:/input_ctrl_tb/R1/req \
sim:/input_ctrl_tb/R1/ack \
sim:/input_ctrl_tb/R1/data

run -all