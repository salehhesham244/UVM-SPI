vlib work
vlog pack_one.sv pack_two.sv pack_three.sv shared_pkg.sv FIFO_if.sv top.sv monitor.sv FIFO.sv  tb.sv -define SIM +cover
vsim -voptargs=+acc work.top -cover
add wave *
run -all
coverage save top.ucdb -onexit 
quit -sim
vcover report top.ucdb -all -annotate -details  -output coverage.txt
