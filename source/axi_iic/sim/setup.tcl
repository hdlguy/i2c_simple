# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -part xc7a35tcsg324-1 -force proj
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]

#read_ip ../dgen_rom/dgen_rom.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

read_verilog -sv ../xpm_sync_fifo/xpm_sync_fifo.sv
read_verilog -sv ../iic_core.sv
read_verilog -sv ../axi_iic.sv
read_verilog -sv ../axi_master_v1_0_M00_AXI.sv  
read_verilog -sv ../axi_iic_tb.sv  

add_files -fileset sim_1 -norecurse ./axi_iic_tb_behav.wcfg

close_project

#########################



