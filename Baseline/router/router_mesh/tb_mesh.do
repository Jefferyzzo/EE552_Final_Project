quit -sim

vlog -work work SystemVerilogCSP.sv arbiter_merge_4in.sv arbiter_merge.sv arbiter.sv  \
copy.sv merge.sv tb_router.sv router.sv mesh.sv tb_mesh.sv

vsim -novopt work.tb_mesh

run -all