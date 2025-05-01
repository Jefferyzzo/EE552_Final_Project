quit -sim

vlog -work work ./design/SystemVerilogCSP.sv ./design/*.sv  ./tb/tb_cu.sv
vsim -novopt work.tb_cu

add wave -position insertpoint  \
sim:/tb_cu/I/status \
sim:/tb_cu/I/data
add wave -position insertpoint  \
sim:/tb_cu/cu/ID_Filmem/status \
sim:/tb_cu/cu/ID_Filmem/data
add wave -position insertpoint  \
sim:/tb_cu/cu/ID/in_packet \
sim:/tb_cu/cu/ID/size_filter \
sim:/tb_cu/cu/ID/filter_row \
sim:/tb_cu/cu/ID/fil_done

run -all