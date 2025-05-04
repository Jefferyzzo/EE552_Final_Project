quit -sim

vlog -work work ./design/SystemVerilogCSP.sv ./design/*.sv  ./tb/tb_cu.sv
vsim -novopt work.tb_cu

add wave -position insertpoint  \
sim:/tb_cu/I/status \
sim:/tb_cu/I/data
add wave -position insertpoint  \
sim:/tb_cu/cu/ID_Ifmem/status \
sim:/tb_cu/cu/ID_Ifmem/data
add wave -position insertpoint  \
sim:/tb_cu/cu/ID_Pkt/status \
sim:/tb_cu/cu/ID_Pkt/data
add wave -position insertpoint  \
{sim:/tb_cu/cu/ID_TB[0]/status} \
{sim:/tb_cu/cu/ID_TB[0]/data}
add wave -position insertpoint  \
sim:/tb_cu/cu/Ifmem_Ifgen/status \
sim:/tb_cu/cu/Ifmem_Ifgen/data
add wave -position insertpoint  \
sim:/tb_cu/cu/Ifgen_Alloc/status \
sim:/tb_cu/cu/Ifgen_Alloc/data
add wave -position insertpoint  \
{sim:/tb_cu/cu/Alloc_FIFO[0]/status} \
{sim:/tb_cu/cu/Alloc_FIFO[0]/data}
add wave -position insertpoint  \
{sim:/tb_cu/cu/TB_FIFO[0]/status} \
{sim:/tb_cu/cu/TB_FIFO[0]/data}
add wave -position insertpoint  \
{sim:/tb_cu/cu/gen_fifo_tb[0]/PE_FIFO/rp} \
{sim:/tb_cu/cu/gen_fifo_tb[0]/PE_FIFO/wp} \
{sim:/tb_cu/cu/gen_fifo_tb[0]/PE_FIFO/data} \
{sim:/tb_cu/cu/gen_fifo_tb[0]/PE_FIFO/ack_dummy}
add wave -position insertpoint  \
{sim:/tb_cu/cu/FIFO_Arb[0]/status} \
{sim:/tb_cu/cu/FIFO_Arb[0]/data}
add wave -position insertpoint  \
sim:/tb_cu/O/status \
sim:/tb_cu/O/data


add wave -position insertpoint  \
sim:/tb_cu/cu/Ifmem/data_ts0 \
sim:/tb_cu/cu/Ifmem/data_ts1 \
sim:/tb_cu/cu/Ifmem/in_packet \
sim:/tb_cu/cu/Ifmem/if_size \
sim:/tb_cu/cu/Ifmem/conv_size \
sim:/tb_cu/cu/Ifmem/x_ts0 \
sim:/tb_cu/cu/Ifmem/y_ts0 \
sim:/tb_cu/cu/Ifmem/x_ts1 \
sim:/tb_cu/cu/Ifmem/y_ts1 \
sim:/tb_cu/cu/Ifmem/i_ts0 \
sim:/tb_cu/cu/Ifmem/i_ts1 \
sim:/tb_cu/cu/Ifmem/cnt_ts0 \
sim:/tb_cu/cu/Ifmem/cnt_ts1 \
sim:/tb_cu/cu/Ifmem/i \
sim:/tb_cu/cu/Ifmem/j \
sim:/tb_cu/cu/Ifmem/in_addr \
sim:/tb_cu/cu/Ifmem/out_packet \
sim:/tb_cu/cu/Ifmem/x \
sim:/tb_cu/cu/Ifmem/y \
sim:/tb_cu/cu/Ifmem/y_end

run -all