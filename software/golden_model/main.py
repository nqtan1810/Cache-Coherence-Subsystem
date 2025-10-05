# **************************************************************************************
# subsystem's software model
# **************************************************************************************

# **************************************************************************************
"""
                                           ----------          ----------
                                           |  CPU A |          |  CPU A |
                                           ----------          ----------
                                                ^                  ^
                                                |                  |
                                                |                  |
                                                V                  V
                                          ------------        ------------
                                          |  CACHE A |        |  CACHE B |   (4-way, 16-set) 4MB
                                          ------------        ------------
                                                ^                  ^
                                                |                  |
                                                |                  |
                                                V                  V
                               -------------------------------------------------------
                                                  AXI + Coherence
                               -------------------------------------------------------
                                                         ^
                                                         |
                                                         |
                                                         V
                                               ---------------------
                                               |    Main Memory    |
                                               ---------------------
"""
# **************************************************************************************
from subsystem import *

if __name__ == "__main__":
    while (testbench_id := int(input("Which component do you want to run simulation?\n1. Cache\n2. AXI + Coherence\n3. Subsystem\nEnter your choice: "))) not in [1, 2, 3]:
        print("Your choice is unsupported!")
    if testbench_id == 1:
        run_cache()
        compare_actual_expected_results(cache_actual_result_dir, cache_expected_result_dir)
    elif testbench_id == 2:
        run_axi_coherence()
        compare_actual_expected_results(axi_coherence_actual_result_dir, axi_coherence_expected_result_dir)
    elif testbench_id == 3:
        run_subsystem()
        compare_actual_expected_results(subsystem_actual_result_dir, subsystem_expected_result_dir)
