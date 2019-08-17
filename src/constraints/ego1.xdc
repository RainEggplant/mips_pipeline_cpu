# 100MHz system clock
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports sysclk]
create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports sysclk]

# Button 0
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {reset}]

# LED 0
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports led]
