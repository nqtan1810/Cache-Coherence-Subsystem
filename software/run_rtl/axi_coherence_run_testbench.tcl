# Full path to the project file
set project_path "***/coherence_cache.xpr"

# Open the project
open_project $project_path

# Set the top module (testbench)
set_property top axi_coherence_top_tb [get_filesets sim_1]

foreach file [get_files *.wcfg] {
    set_property is_enabled false $file
}

# Launch simulation in behavioral mode
launch_simulation -simset sim_1 -mode behavioral

# Run simulation for 5000 time units
run 10000

# Open waveform window and display signals (if needed)
#open_wave_database wave_db
#add_wave -position end [get_objects /*]
#display_waveform

# Wait to view the waveform (you can adjust the wait time)
after 10000

# Close the project after simulation is done
close_project
exit
