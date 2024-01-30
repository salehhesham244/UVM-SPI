vlib work
vlog -sv +define+SIM_PARAM *v
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/top/spiwrapperif/*
add wave -position insertpoint sim:/top/spiwrappergif/*
run -all