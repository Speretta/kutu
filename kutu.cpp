#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "obj_dir/Vtop.h"

#define MAX_TIME 30

vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env){
    Vtop *dut = new Vtop;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut -> trace(m_trace, 5);
    m_trace -> open("waveform.vcd");

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