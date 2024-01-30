vlib work
vlog -sv +define+SIM_PARAM *v +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint sim:/top/ramif/*
run -all
coverage save top.ucdb -onexit 
quit -sim
vcover report top.ucdb -all -annotate -details  -output coverage.txt
