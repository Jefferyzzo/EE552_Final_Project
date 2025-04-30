quit -sim

vlog -work work ./design/SystemVerilogCSP.sv ./design/arbiter_merge_4in.sv ./design/arbiter_merge.sv ./design/arbiter.sv  \
./design/copy.sv ./design/merge.sv ./tb/tb_router.sv ./design/router.sv

vsim -novopt work.tb_router

add wave -position insertpoint  \
sim:/tb_router/Ei/req \
sim:/tb_router/Ei/ack \
sim:/tb_router/Ei/data
add wave -position insertpoint  \
sim:/tb_router/dut/buffer_E/Ei_packet \
sim:/tb_router/dut/buffer_E/Eo_packet
add wave -position insertpoint  \
sim:/tb_router/dut/E2PE/req \
sim:/tb_router/dut/E2PE/ack \
sim:/tb_router/dut/E2PE/data

add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/L0/status \
sim:/tb_router/dut/PEo_arb/L0/data
add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/L1/status \
sim:/tb_router/dut/PEo_arb/L1/data
add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/L2/status \
sim:/tb_router/dut/PEo_arb/L2/data
add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/L3/status \
sim:/tb_router/dut/PEo_arb/L3/data
add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/R/status \
sim:/tb_router/dut/PEo_arb/R/data

add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/arb0_out/status \
sim:/tb_router/dut/PEo_arb/arb0_out/data
add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/arb1_out/status \
sim:/tb_router/dut/PEo_arb/arb1_out/data
add wave -position insertpoint  \
sim:/tb_router/dut/PEo_arb/arb2_sel/status \
sim:/tb_router/dut/PEo_arb/arb2_sel/data
run -all