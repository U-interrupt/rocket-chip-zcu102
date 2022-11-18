
################################################################
# This is a generated script based on design: zynq_soc
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source zynq_soc_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_crossbar:2.1\
xilinx.com:ip:axi_uart16550:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:xlconcat:2.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hier_uart
proc create_hier_cell_hier_uart { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_uart() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1


  # Create pins
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type clk pardcore_coreclk
  create_bd_pin -dir O -from 4 -to 0 pardcore_uart_irq
  create_bd_pin -dir I -type rst pardcore_uncorerstn
  create_bd_pin -dir O -type intr uart0_irq
  create_bd_pin -dir O -type intr uart1_irq
  create_bd_pin -dir O -type intr uart2_irq
  create_bd_pin -dir O -type intr uart3_irq

  # Create instance: axi_crossbar_pardcore, and set properties
  set axi_crossbar_pardcore [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_pardcore ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $axi_crossbar_pardcore

  # Create instance: axi_crossbar_prm, and set properties
  set axi_crossbar_prm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_prm ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $axi_crossbar_prm

  # Create instance: axi_uart16550_pardcore_1, and set properties
  set axi_uart16550_pardcore_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_pardcore_1 ]

  # Create instance: axi_uart16550_pardcore_2, and set properties
  set axi_uart16550_pardcore_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_pardcore_2 ]

  # Create instance: axi_uart16550_pardcore_3, and set properties
  set axi_uart16550_pardcore_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_pardcore_3 ]

  # Create instance: axi_uart16550_pardcore_4, and set properties
  set axi_uart16550_pardcore_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_pardcore_4 ]

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_0

  # Create instance: axi_uartlite_1, and set properties
  set axi_uartlite_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_1 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_1

  # Create instance: axi_uartlite_2, and set properties
  set axi_uartlite_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_2 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_2

  # Create instance: axi_uartlite_3, and set properties
  set axi_uartlite_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_3 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_3

  # Create instance: axi_uartlite_pardcore_0, and set properties
  set axi_uartlite_pardcore_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_pardcore_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_pardcore_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {5} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_crossbar_pardcore/S00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S00_AXI1] [get_bd_intf_pins axi_crossbar_prm/S00_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_pardcore_M00_AXI [get_bd_intf_pins axi_crossbar_pardcore/M00_AXI] [get_bd_intf_pins axi_uartlite_pardcore_0/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_pardcore_M01_AXI [get_bd_intf_pins axi_crossbar_pardcore/M01_AXI] [get_bd_intf_pins axi_uart16550_pardcore_1/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_pardcore_M02_AXI [get_bd_intf_pins axi_crossbar_pardcore/M02_AXI] [get_bd_intf_pins axi_uart16550_pardcore_2/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_pardcore_M03_AXI [get_bd_intf_pins axi_crossbar_pardcore/M03_AXI] [get_bd_intf_pins axi_uart16550_pardcore_3/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_pardcore_M04_AXI [get_bd_intf_pins axi_crossbar_pardcore/M04_AXI] [get_bd_intf_pins axi_uart16550_pardcore_4/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_prm_M00_AXI [get_bd_intf_pins axi_crossbar_prm/M00_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_prm_M01_AXI [get_bd_intf_pins axi_crossbar_prm/M01_AXI] [get_bd_intf_pins axi_uartlite_1/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_prm_M02_AXI [get_bd_intf_pins axi_crossbar_prm/M02_AXI] [get_bd_intf_pins axi_uartlite_2/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_prm_M03_AXI [get_bd_intf_pins axi_crossbar_prm/M03_AXI] [get_bd_intf_pins axi_uartlite_3/S_AXI]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_crossbar_pardcore/aresetn] [get_bd_pins axi_crossbar_prm/aresetn]
  connect_bd_net -net axi_uart16550_1_ip2intc_irpt [get_bd_pins axi_uart16550_pardcore_1/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_uart16550_1_sout [get_bd_pins axi_uart16550_pardcore_1/sout] [get_bd_pins axi_uartlite_1/rx]
  connect_bd_net -net axi_uart16550_2_ip2intc_irpt [get_bd_pins axi_uart16550_pardcore_2/ip2intc_irpt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_uart16550_2_sout [get_bd_pins axi_uart16550_pardcore_2/sout] [get_bd_pins axi_uartlite_2/rx]
  connect_bd_net -net axi_uart16550_3_ip2intc_irpt [get_bd_pins axi_uart16550_pardcore_3/ip2intc_irpt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_uart16550_3_sout [get_bd_pins axi_uart16550_pardcore_3/sout] [get_bd_pins axi_uart16550_pardcore_4/sin]
  connect_bd_net -net axi_uart16550_4_ip2intc_irpt [get_bd_pins axi_uart16550_pardcore_4/ip2intc_irpt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_uart16550_4_sout [get_bd_pins axi_uart16550_pardcore_3/sin] [get_bd_pins axi_uart16550_pardcore_4/sout]
  connect_bd_net -net axi_uartlite_0_interrupt [get_bd_pins uart0_irq] [get_bd_pins axi_uartlite_0/interrupt]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins axi_uartlite_pardcore_0/rx]
  connect_bd_net -net axi_uartlite_1_interrupt [get_bd_pins uart1_irq] [get_bd_pins axi_uartlite_1/interrupt]
  connect_bd_net -net axi_uartlite_1_tx [get_bd_pins axi_uart16550_pardcore_1/sin] [get_bd_pins axi_uartlite_1/tx]
  connect_bd_net -net axi_uartlite_2_interrupt [get_bd_pins uart2_irq] [get_bd_pins axi_uartlite_2/interrupt]
  connect_bd_net -net axi_uartlite_2_tx [get_bd_pins axi_uart16550_pardcore_2/sin] [get_bd_pins axi_uartlite_2/tx]
  connect_bd_net -net axi_uartlite_3_interrupt [get_bd_pins uart3_irq] [get_bd_pins axi_uartlite_3/interrupt]
  connect_bd_net -net axi_uartlite_pardcore_0_interrupt [get_bd_pins axi_uartlite_pardcore_0/interrupt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_uartlite_pardcore_0_tx [get_bd_pins axi_uartlite_0/rx] [get_bd_pins axi_uartlite_pardcore_0/tx]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins pardcore_coreclk] [get_bd_pins axi_crossbar_pardcore/aclk] [get_bd_pins axi_crossbar_prm/aclk] [get_bd_pins axi_uart16550_pardcore_1/s_axi_aclk] [get_bd_pins axi_uart16550_pardcore_2/s_axi_aclk] [get_bd_pins axi_uart16550_pardcore_3/s_axi_aclk] [get_bd_pins axi_uart16550_pardcore_4/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins axi_uartlite_1/s_axi_aclk] [get_bd_pins axi_uartlite_2/s_axi_aclk] [get_bd_pins axi_uartlite_3/s_axi_aclk] [get_bd_pins axi_uartlite_pardcore_0/s_axi_aclk]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins pardcore_uncorerstn] [get_bd_pins axi_uart16550_pardcore_1/s_axi_aresetn] [get_bd_pins axi_uart16550_pardcore_2/s_axi_aresetn] [get_bd_pins axi_uart16550_pardcore_3/s_axi_aresetn] [get_bd_pins axi_uart16550_pardcore_4/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins axi_uartlite_1/s_axi_aresetn] [get_bd_pins axi_uartlite_2/s_axi_aresetn] [get_bd_pins axi_uartlite_3/s_axi_aresetn] [get_bd_pins axi_uartlite_pardcore_0/s_axi_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins pardcore_uart_irq] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_hier_uart parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
