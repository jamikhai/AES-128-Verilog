#----------------------------------------------------------------------
# generateProject.tcl
#
# Usage:
#   vivado -mode tcl -source generateProject.tcl -tclargs <project_name>
#
# This script builds a Vivado project for a design,
# targeting the Zybo Z7-10 board (Part: xc7z010clg400-1).
#
# Directory structure assumed:
#
#   AES-Project/
#   ├── <project_name>
#   │   ├── src    (Verilog design modules)
#   │   └── sim    (Verilog testbenches)
#   └── build
#       └── <project_name>  (Vivado project build directory)
#
# The script first cleans the entire build/ directory and then creates a new
# project in build/<project_name>.
#
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Get the project name from the command line arguments.
#----------------------------------------------------------------------
if {[llength $argv] < 1} {
    puts "Usage: vivado -mode tcl -source generateProject.tcl -tclargs <project_name>"
    exit 1
}
set projectName [lindex $argv 0]

#----------------------------------------------------------------------
# Clean the build/<projectName> directory.
#----------------------------------------------------------------------
if {[file exists "./build/$projectName"]} {
    file delete -force "./build/$projectName"
}
file mkdir "./build/$projectName"

#----------------------------------------------------------------------
# Create the Vivado project targeting the Zybo Z7-10 board.
#----------------------------------------------------------------------
set partName xc7z010clg400-1
create_project -force $projectName "./build/$projectName" \
    -part $partName

#----------------------------------------------------------------------
# Add design sources (Verilog files) from the <project_name>/src directory.
#----------------------------------------------------------------------
add_files "./$projectName/src/"

#----------------------------------------------------------------------
# Add simulation sources (Verilog testbenches) from the <project_name>/sim directory.
#----------------------------------------------------------------------
add_files -fileset sim_1 "./$projectName/sim/"

#----------------------------------------------------------------------
# Import the files into the project.
#----------------------------------------------------------------------
import_files -force

#----------------------------------------------------------------------
# Update compile order for the sources and simulation filesets.
#----------------------------------------------------------------------
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

#---------------------------------------------------------------------- 
# (Optional) Synthesis and Implementation steps
#---------------------------------------------------------------------- 
#launch_runs synth_1
#wait_on_run synth_1
#open_run synth_1 -name netlist_1
#
#report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose \
#    -max_paths 10 -input_pins -file syn_timing.rpt
#report_power -file syn_power.rpt
#
#launch_runs impl_1 -to_step write_bitstream
#wait_on_run impl_1
#open_run impl_1
#
#report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose \
#    -max_paths 10 -input_pins -file imp_timing.rpt
#report_power -file imp_power.rpt

#---------------------------------------------------------------------- 
# Exit the script after the project has been generated.
#---------------------------------------------------------------------- 
puts "Project '$projectName' generated successfully. Exiting Vivado."
exit
