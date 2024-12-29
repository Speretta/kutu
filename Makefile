default: build_hard

build:
	verilator --trace --exe --build --cc kutu.cpp top.v +incdir+ ./boru_hatti/*

build_hard:
	verilator -Wall --trace --exe --build --cc kutu.cpp top.v +incdir+ ./boru_hatti/* 

run_trace:
	./obj_dir/Vtop

run_trace_gtkwave:
	./obj_dir/Vtop && gtkwave waveform.vcd