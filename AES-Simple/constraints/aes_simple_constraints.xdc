create_clock -name sys_clk -period 40.0 -waveform {0 20} [get_ports {clk}]