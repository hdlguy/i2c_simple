
create_clock -period 10.000 -name clk100 -waveform {0.000 5.000} [get_ports {clk100}]

set_property IOSTANDARD LVCMOS33    [get_ports {clk100}]
set_property PACKAGE_PIN E3         [get_ports {clk100}]

set_property IOSTANDARD LVCMOS33    [get_ports {usb_uart*}]
set_property PACKAGE_PIN A9         [get_ports {usb_uart_rxd}]
set_property PACKAGE_PIN D10        [get_ports {usb_uart_txd}]

set_property IOSTANDARD LVCMOS33    [get_ports {led[*]}]
set_property PACKAGE_PIN T10        [get_ports {led[3]}]
set_property PACKAGE_PIN T9         [get_ports {led[2]}]
set_property PACKAGE_PIN J5         [get_ports {led[1]}]
set_property PACKAGE_PIN H5         [get_ports {led[0]}]

set_property IOSTANDARD LVCMOS33    [get_ports {scl}]
set_property IOSTANDARD LVCMOS33    [get_ports {sda}]
set_property PACKAGE_PIN D15        [get_ports {scl}]  ;# JB.3, JB2_P
set_property PACKAGE_PIN C15        [get_ports {sda}]  ;# JB.4, JB2_N

