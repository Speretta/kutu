#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "obj_dir/Vtop.h"
#include <filesystem>

#define MAX_TIME 30

vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env){
    std::string output_path = "./output/waveform.vcd"; 
    for (int i=0; i < argc; i++){
        if (std::string(argv[i]) == "-o" && i + 1 < argc){
            i = i+1;
            output_path = std::string(argv[i]);
        }
    }
    std::filesystem::path path_to_file(output_path);
    std::filesystem::path parent_path_to_file = path_to_file.parent_path();
    if (parent_path_to_file.empty()){
        parent_path_to_file = "./" / parent_path_to_file;
        path_to_file = "./" / path_to_file;
    }
    std::filesystem::create_directories(parent_path_to_file);
    Vtop *dut = new Vtop;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut -> trace(m_trace, 5);
    m_trace -> open(path_to_file.c_str());

    while (sim_time < MAX_TIME)
    {
        dut -> clk_i^=1;
        dut -> rst_i=0;
        dut -> eval();
        m_trace ->dump(sim_time);
        sim_time++;
    }
    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}