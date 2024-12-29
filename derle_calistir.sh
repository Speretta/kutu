#!/bin/bash
verilator --trace --exe --build --cc kutu.cpp top.v +incdir+ ./boru_hatti/* && ./obj_dir/Vtop && gtkwave waveform.vcd