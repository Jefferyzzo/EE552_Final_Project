quit -sim

vlog -work work SystemVerilogCSP.sv arbiter_merge_4in.sv arbiter_merge.sv arbiter.sv  \
copy.sv merge.sv tb_router.sv router.sv mesh.sv tb_mesh.sv

vsim -novopt work.tb_mesh

add wave -position insertpoint  \
{sim:/tb_mesh/PEi[0][0]/data}
add wave -position insertpoint  \
{sim:/tb_mesh/PEi[0][0]/status}
add wave -position insertpoint  \
{sim:/tb_mesh/PEi[0][0]/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/E2W[0][1]/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/E2W[0][1]/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/E2W[0][2]/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/E2W[0][2]/data}
add wave -position insertpoint  \
{sim:/tb_mesh/PEi[0][0]/status}
add wave -position insertpoint  \
{sim:/tb_mesh/PEi[0][0]/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[0]/router_node/PE2E/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[0]/router_node/PE2E/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[0]/router_node/W2E/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[0]/router_node/W2E/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[0]/router_node/PE2E/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[0]/router_node/PE2E/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/W2E[0][1]/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/W2E[0][1]/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[1]/router_node/Wi/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[1]/router_node/Wi/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[1]/router_node/W2E/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[1]/router_node/W2E/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[1]/router_node/Eo/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[1]/router_node/Eo/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/Wi/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/Wi/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/W2PE/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/W2PE/data}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/PEo/status}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/PEo/data}

add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/WIDTH}
add wave -position insertpoint  \
{sim:/tb_mesh/dut/gen_row[0]/gen_col[2]/router_node/Y_HOP_LOC}

add wave -position insertpoint  \
sim:/tb_mesh/dut/WIDTH
add wave -position insertpoint  \
sim:/tb_mesh/dut/Y_HOP_LOC


run -all