onerror {exit -code 1}
vlib work
vmap work work

vlog -work work SystemVerilogCSP.sv
vlog -work work data_bucket.sv
vlog -work work data_generator.sv
vlog -work work arbiter_2to1.sv
vlog -work work input_ctrl.sv
vlog -work work output_ctrl.sv

vlog -work work router.sv
vlog -work work router_test.sv

vlog -sv -lint -reportprogress 300 -work work SystemVerilogCSP.sv
vlog -sv -lint -reportprogress 300 -work work data_bucket.sv
vlog -sv -lint -reportprogress 300 -work work data_generator.sv
vlog -sv -lint -reportprogress 300 -work work arbiter_2to1.sv
vlog -sv -lint -reportprogress 300 -work work input_ctrl.sv
vlog -sv -lint -reportprogress 300 -work work output_ctrl.sv
vlog -sv -lint -reportprogress 300 -work work router.sv
vlog -sv -lint -reportprogress 300 -work work router_test.sv

vsim -novopt work.router_test


