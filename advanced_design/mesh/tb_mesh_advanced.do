quit -sim

vlog -work work ./design/SystemVerilogCSP.sv ./design/arbiter_merge_4in.sv ./design/arbiter_merge.sv ./design/arbiter.sv  \
./design/copy.sv ./design/merge.sv ./design/router_reversed.sv ./design/mesh_advanced.sv ./tb/tb_mesh_advanced.sv

vsim -novopt work.tb_mesh_advanced


run -all