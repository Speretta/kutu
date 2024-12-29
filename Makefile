default: build_hard

build:
	verilator --trace --exe --build -j -O3 --cc kutu.cpp top.v -y ./src ./src/boru_hatti/*

build_hard:
	verilator -Wall --trace --exe --build -j -O3 --cc kutu.cpp top.v -y ./src ./src/boru_hatti/*

run_trace:
	./obj_dir/Vtop

run_trace_gtkwave:
	./obj_dir/Vtop && gtkwave ./output/waveform.vcd

clean:
	rm -rf ./obj_dir ./output