vlib work
vlog -sv +define+SIM_PARAM pack1.sv pack2.sv shared_pack.sv Dp_Sync_RAM.sv RAM_golden_model.sv \
interface.sv SPI_slave_golden_model.sv SPI_Slave.sv SPI_wrapper_golden_model.v tb.sv top.sv tb.sv +cover
vsim -voptargs=+acc work.top -cover
add wave *
coverage save tb.ucdb  -onexit -du SPI_Slave
run -all
vcover report tb.ucdb -details -annotate -all -output coverage_rpt.txt
