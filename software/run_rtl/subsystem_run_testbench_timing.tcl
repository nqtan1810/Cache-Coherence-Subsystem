# Full path to the project file
set project_path "***/coherence_cache.xpr"

# Open the project
open_project $project_path

# Set the top module (testbench)
set_property top subsystem_top_tb [get_filesets sim_1]

set_property is_enabled false [get_files  ***/cache_top_tb_behav.wcfg]
set_property is_enabled false [get_files  ***/subsystem_top_tb_behav.wcfg]
set_property is_enabled false [get_files  ***/axi_coherence_top_tb_behav.wcfg]

# Launch simulation in post-synthesis timing mode
# Open synthesized design — this is REQUIRED for post-synthesis sim
open_run synth_1 -name synth_1
launch_simulation -simset sim_1 -mode post-synthesis -type timing

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
