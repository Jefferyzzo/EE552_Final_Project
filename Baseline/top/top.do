quit -sim

vlog -work work 
../PE/src/SystemVerilogCSP.sv \
./top_tb.sv \
./top.sv \
../PE/src/PE.sv \
../PE/src/depacketizer.sv \
../PE/src/split.sv \
../PE/src/special_split.sv \
../PE/src/priority_mux.sv \
../PE/src/copy.sv \
../PE/src/copy4.sv \
../PE/src/conditional_copy.sv \
../PE/src/mac.sv \
../PE/src/spike_residue.sv \
../PE/src/two_input_adder.sv \
../PE/src/merge.sv \
../PE/src/packetizer.sv \
../PE/src/buffer.sv \
../router/router_mesh/design/arbiter.sv \
../router/router_mesh/design/arbiter_merge.sv \
../router/router_mesh/design/arbiter_merge_4in.sv  \
../router/router_mesh/design/mesh.sv \
../router/router_mesh/design/router.sv

vsim -novopt work.top_tb

run -all