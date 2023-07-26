# This script sets up a Vivado project with all ip references resolved.
# run on linux command line with:
#       vivado -mode batch -source setup.tcl
#
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
#create_project -force proj 
#set_property board_part numato.com:neso:part0:1.0 [current_project]
#set_property part xc7a100tcsg324-1 [current_project]
create_project -part xc7a35tcsg324-1 -force proj 
set_property target_language verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet
set_property CUSTOMIZED_DEFAULT_IP_LOCATION ./ [current_project]

read_ip ../source/ad9480_if/ad9480_fifo/ad9480_fifo.xci

source ../source/udp_stack/totlen/totlen_data_fifo.tcl
source ../source/udp_stack/totlen/totlen_length_fifo.tcl
source ../source/udp_stack/mac_fifo.tcl
source ../source/uart/uart_fifo.tcl

read_ip ../source/udp_stack/eth_ila/eth_ila.xci
read_ip ../source/capt_ila/capt_ila.xci
read_ip ../source/lidar_ila/lidar_ila.xci
#read_ip ../source/mb_controller/iic_ila/iic_ila.xci
read_ip ../source/frame_tx/reader_ila/reader_ila.xci
read_ip ../source/frame_tx/frame_tx_ila/frame_tx_ila.xci
#read_ip ../source/tempmon/tempmon_ila/tempmon_ila.xci
read_ip ../source/arty_top_vio/arty_top_vio.xci
read_ip ../source/arty_top_ila/arty_top_ila.xci
read_ip ../source/uart_ila/uart_ila.xci


upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

source ../source/mb_controller/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
set_property synth_checkpoint_mode None [get_files ./proj.srcs/sources_1/bd/system/system.bd]

read_verilog -sv ../source/alexforencich/axis_gmii_rx.v  
read_verilog -sv ../source/alexforencich/axis_gmii_tx.v  
read_verilog -sv ../source/alexforencich/eth_mac_1g.v  
read_verilog -sv ../source/alexforencich/eth_mac_mii.v  
read_verilog -sv ../source/alexforencich/alex_lfsr.v  
read_verilog -sv ../source/alexforencich/mii_phy_if.v  
read_verilog -sv ../source/alexforencich/ssio_sdr_in.v

read_verilog -sv ../source/udp_frame_rx/udp_frame_rx.sv
read_verilog -sv ../source/udp_stack/totlen/totlen.sv
read_verilog -sv ../source/udp_stack/udp_stack.sv
read_verilog -sv ../source/udp_stack/arp_rx/arp_rx.sv
read_verilog -sv ../source/udp_stack/arp_tx/arp_tx.sv
read_verilog -sv ../source/temac.sv

read_verilog -sv ../source/uart/uart_tx.sv
read_verilog -sv ../source/uart/uart_rx.sv
read_verilog -sv ../source/uart/uart_line_buffer/uart_line_buffer.sv
read_verilog -sv ../source/uart/uart.sv

read_verilog -sv ../source/amc7823/amc7823_if.sv  
read_verilog -sv ../source/amc7823/amc7823_scanner.sv
read_verilog -sv ../source/amc7823/amc7823.sv  

read_verilog -sv ../source/tempmon/tempmon.sv

read_verilog -sv ../source/linux_timer/linux_timer.sv

read_verilog -sv ../source/fan_tach/fan_tach.sv

read_verilog -sv ../source/energy_monitor/energy_monitor.sv

read_verilog -sv ../source/phase_gen/phase_gen.sv

read_verilog -sv ../source/tac/tac.sv
read_verilog -sv ../source/tac/pulse_timer/pulse_timer.sv

add_files        ../source/lidar_emulator/lidar_emu.mem
read_verilog -sv ../source/lidar_emulator/lidar_emulator.sv  

read_verilog -sv ../source/vec_accum/xpm_vec_accum_ram.sv
read_verilog -sv ../source/vec_accum/range_decimator.sv
read_verilog -sv ../source/vec_accum/vec_accum_fifo/vec_accum_fifo.sv
read_verilog -sv ../source/vec_accum/vec_accum.sv

read_verilog -sv ../source/xpm_memory/xpm_sync_fifo/xpm_sync_fifo.sv
read_verilog -sv ../source/frame_tx/status_reader.sv
read_verilog -sv ../source/frame_tx/vec_reader/vec_reader.sv
read_verilog -sv ../source/frame_tx/uart_reader.sv
read_verilog -sv ../source/frame_tx/event_reader.sv
read_verilog -sv ../source/frame_tx/frame_tx.sv

read_verilog -sv ../source/ad9480_if/input_delay.sv
read_verilog -sv ../source/ad9480_if/ad9480_if.sv

read_verilog -sv ../source/mb_controller/axi_regfile/axi_regfile_v1_0_S00_AXI.sv
read_verilog -sv ../source/mb_controller/mb_controller.sv

read_verilog -sv ../source/pwm/pwm.sv

read_verilog -sv ../source/top.sv
read_verilog -sv ../source/arty_top.sv

read_xdc         ../source/arty_top.xdc

close_project


