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
import concurrent.futures
import os
import shutil
import subprocess
import concurrent.futures
import filecmp

from system_common import *
from processor import *
from cache_L1 import *
from Interconnect import *
from main_memory import *
from deadlock_handler import *

current_dir = os.path.dirname(os.path.abspath(__file__))
sw_design_dir_path = os.path.dirname(current_dir)
hw_design_dir_path = os.path.join(os.path.dirname(sw_design_dir_path), 'hw_design')

testcase_dir = os.path.join(hw_design_dir_path, 'testcase')
run_dir = os.path.join(testcase_dir, f'run')
subsystem_testcase_dir = os.path.join(testcase_dir, 'generate_instruction/subsystem_testcase')
cache_testcase_dir = os.path.join(testcase_dir, 'generate_instruction/cache_testcase')
axi_coherence_testcase_dir = os.path.join(testcase_dir, 'generate_instruction/axi_coherence_testcase')

subsystem_expected_result_dir = os.path.join(testcase_dir, 'run/subsystem_expected_result')
subsystem_actual_result_dir = os.path.join(testcase_dir, 'run/subsystem_actual_result')

cache_expected_result_dir = os.path.join(testcase_dir, 'run/cache_expected_result')
cache_actual_result_dir = os.path.join(testcase_dir, 'run/cache_actual_result')

axi_coherence_expected_result_dir = os.path.join(testcase_dir, 'run/axi_coherence_expected_result')
axi_coherence_actual_result_dir = os.path.join(testcase_dir, 'run/axi_coherence_actual_result')


def compare_actual_expected_results(actual_dir=subsystem_actual_result_dir, expected_dir=subsystem_expected_result_dir, log_dir=run_dir):
    if actual_dir == subsystem_actual_result_dir:
        log_file = 'subsystem_result.log'
    elif actual_dir == cache_actual_result_dir:
        log_file = 'cache_result.log'
    elif actual_dir == axi_coherence_actual_result_dir:
        log_file = 'axi_coherence.log'
    else:
        log_file = 'subsystem_result.log'

    with open(f"{log_dir}/{log_file}", "w", encoding="utf-8") as log:
        total_tc = 0
        passed_tc = 0
        failed_tc = 0
        missing_tc = 0

        testcase_status = {}  # key: testcase_name, value: 'pass' | 'fail' | 'missing'

        for dirpath, _, filenames in os.walk(expected_dir):
            for filename in filenames:
                rel_path = os.path.relpath(os.path.join(dirpath, filename), expected_dir)
                expected_file = os.path.join(expected_dir, rel_path)
                actual_file = os.path.join(actual_dir, rel_path)

                testcase_name = rel_path.split(os.sep)[0]
                if testcase_name not in testcase_status:
                    total_tc += 1
                    testcase_status[testcase_name] = 'pass'  # giả định ban đầu là pass

                if not os.path.exists(actual_file):
                    log.write(f"[MISSING]    {rel_path}\n")
                    testcase_status[testcase_name] = 'missing'
                elif not filecmp.cmp(expected_file, actual_file, shallow=False):
                    log.write(f"[DIFFERENT]  {rel_path}\n")
                    if testcase_status[testcase_name] != 'missing':
                        testcase_status[testcase_name] = 'fail'
                else:
                    log.write(f"[MATCHED]    {rel_path}\n")

        for status in testcase_status.values():
            if status == 'pass':
                passed_tc += 1
            elif status == 'fail':
                failed_tc += 1
            elif status == 'missing':
                missing_tc += 1

        log.write("********************* SUMMARY *********************\n")
        log.write(f"{' - Number of Testcases:':40} {total_tc:>5}\n")
        log.write(f"{' - Number of PASSED Testcases:':40} {passed_tc:>5}\n")
        log.write(f"{' - Number of FAILED Testcases:':40} {failed_tc:>5}\n")
        log.write(f"{' - Number of MISSED Testcases:':40} {missing_tc:>5}\n")
        log.write("********************* END *************************\n")


def run_cache_testcase(testcase_id):
    create_expected_resutl_folder(cache_expected_result_dir, testcase_id)
    testcase_id_path = os.path.join(cache_testcase_dir, f'testcase_{testcase_id}')
    expected_result_path = os.path.join(cache_expected_result_dir, f'testcase_{testcase_id}')

    # clock generator
    sys_c = system_common()

    # create components
    cpuA = processor('CpuA', testcase_id_path, expected_result_path)
    cacheA = cache_L1('CacheA', expected_result_path)
    AXI_Coherence = Interconnect('AXI_Bus')
    Mem = main_memory('Mem', testcase_id_path, expected_result_path)

    # connection between cpu and cache
    cpuA.s_port.send_port = cacheA.m_port.send_port
    cpuA.s_port.recv_port = cacheA.m_port.recv_port

    # connection between cache and bus
    cacheA.s_port.send_port = AXI_Coherence.m0_port.send_port
    cacheA.s_port.recv_port = AXI_Coherence.m0_port.recv_port

    # connection between bus and dram
    AXI_Coherence.s_port.send_port = Mem.m_port.send_port
    AXI_Coherence.s_port.recv_port = Mem.m_port.recv_port

    while sys_c.cycle <= SIMULATION_TIME:
        cpuA.run(sys_c)
        cacheA.run(sys_c)
        AXI_Coherence.run(sys_c)
        Mem.run(sys_c)

        # Components update
        cpuA.update()
        cacheA.update()
        AXI_Coherence.update()
        Mem.update()

        # this is rising edge
        sys_c.clk_posedge()

    cacheA.save_state_tag()
    cacheA.save_plrut()
    cacheA.save_data()
    cpuA.save_read_data()

    Mem.save_mem()


def run_cache():
    testcase = int(input(f"Which testcase do you want to run? \n 0    : runall\n 1-{cache_number_of_testcase}: testcase 1 - testcase {cache_number_of_testcase} \n Your choice: "))

    if testcase == 0:
        for i in range(1, cache_number_of_testcase + 1):
            delete_previous_expected_result(cache_expected_result_dir, i)

        # Generate test case IDs from 1 to 119 (as integers)
        testcase_ids = list(range(1, cache_number_of_testcase + 1))  # Creates [1, 2, ..., 115]

        # Run test cases in parallel using 4 worker processes
        with concurrent.futures.ProcessPoolExecutor(max_workers=3) as executor:
            executor.map(run_cache_testcase, testcase_ids)

    elif testcase >= 1 and testcase <= cache_number_of_testcase:
        delete_previous_expected_result(cache_expected_result_dir, testcase)
        run_cache_testcase(testcase)


def run_axi_coherence_testcase(testcase_id):
    create_expected_resutl_folder(axi_coherence_expected_result_dir, testcase_id)
    testcase_id_path = os.path.join(axi_coherence_testcase_dir, f'testcase_{testcase_id}')
    expected_result_path = os.path.join(axi_coherence_expected_result_dir, f'testcase_{testcase_id}')

    # clock generator
    sys_c = system_common()

    # create components
    cpuA = processor('16_CpuA', testcase_id_path, expected_result_path)
    cpuB = processor('16_CpuB', testcase_id_path, expected_result_path)

    AXI_Coherence = Interconnect('AXI_Coherence')

    Mem = main_memory('Mem', testcase_id_path, expected_result_path)

    # connection between cache and bus
    cpuA.s_port.send_port = AXI_Coherence.m0_port.send_port
    cpuA.s_port.recv_port = AXI_Coherence.m0_port.recv_port

    cpuB.s_port.send_port = AXI_Coherence.m1_port.send_port
    cpuB.s_port.recv_port = AXI_Coherence.m1_port.recv_port

    # connection between bus and dram
    AXI_Coherence.s_port.send_port = Mem.m_port.send_port
    AXI_Coherence.s_port.recv_port = Mem.m_port.recv_port

    while sys_c.cycle <= SIMULATION_TIME:
        cpuA.run(sys_c)
        cpuB.run(sys_c)
        AXI_Coherence.run(sys_c)
        Mem.run(sys_c)

        # Components update
        cpuA.update()
        cpuB.update()
        AXI_Coherence.update()
        Mem.update()

        # this is rising edge
        sys_c.clk_posedge()

    cpuA.save_read_data_16()
    cpuB.save_read_data_16()

    Mem.save_mem()

    # print(cpuA.state)
    # print(cpuB.state)
    # print(AXI_Coherence.m0_port.recv_port.buffer)
    # print(AXI_Coherence.m0_port.send_port.buffer)
    # print(AXI_Coherence.m1_port.recv_port.buffer[0])
    # print(AXI_Coherence.m1_port.send_port.buffer)
    # print(Mem.m_port.recv_port.buffer)
    # print(Mem.m_port.send_port.buffer)
    # print(Mem.w_state)
    # print(Mem.r_state)
    # print(Mem.write_q)
    # print(Mem.read_q)


def run_axi_coherence():
    testcase = int(input(
        f"Which testcase do you want to run? \n 0    : runall\n 1-{axi_coherence_number_of_testcase}: testcase 1 - testcase {axi_coherence_number_of_testcase} \n Your choice: "))

    if testcase == 0:
        for i in range(1, axi_coherence_number_of_testcase + 1):
            delete_previous_expected_result(axi_coherence_expected_result_dir, i)

        # Generate test case IDs from 1 to 119 (as integers)
        testcase_ids = list(range(1, axi_coherence_number_of_testcase + 1))  # Creates [1, 2, ..., 115]

        # Run test cases in parallel using 4 worker processes
        with concurrent.futures.ProcessPoolExecutor(max_workers=3) as executor:
            executor.map(run_axi_coherence_testcase, testcase_ids)

    elif testcase >= 1 and testcase <= number_of_testcase:
        delete_previous_expected_result(axi_coherence_expected_result_dir, testcase)
        run_axi_coherence_testcase(testcase)


def delete_previous_expected_result(expected_result_dir, testcase_id):
    # print("Start delete previous actual_result!")
    result_path = os.path.join(current_dir, f"{expected_result_dir}/testcase_{testcase_id}")
    if os.path.exists(result_path):
        shutil.rmtree(result_path)
        print(f"Deleted {result_path}")


def create_expected_resutl_folder(base_path, testcase_id):
    folder_path = os.path.join(base_path, f"testcase_{testcase_id}")
    os.makedirs(folder_path, exist_ok=True)


def run_subsystem_testcase(testcase_id):
    create_expected_resutl_folder(subsystem_expected_result_dir, testcase_id)
    testcase_id_path = os.path.join(subsystem_testcase_dir, f'testcase_{testcase_id}')
    expected_result_path = os.path.join(subsystem_expected_result_dir, f'testcase_{testcase_id}')

    # clock generator
    sys_c = system_common()

    # create components
    cpuA = processor('CpuA', testcase_id_path, expected_result_path)
    cpuB = processor('CpuB', testcase_id_path, expected_result_path)

    cacheA = cache_L1('CacheA', expected_result_path)
    cacheB = cache_L1('CacheB', expected_result_path)
    deadlock_handler_ = deadlock_handler('Deadlock_Handler')

    AXI_Coherence = Interconnect('AXI_Coherence')

    Mem = main_memory('Mem', testcase_id_path, expected_result_path)

    # connection between cpu and cache
    cpuA.s_port.send_port = cacheA.m_port.send_port
    cpuA.s_port.recv_port = cacheA.m_port.recv_port

    cpuB.s_port.send_port = cacheB.m_port.send_port
    cpuB.s_port.recv_port = cacheB.m_port.recv_port

    # connection between 2 cache
    deadlock_handler_.cache_L1_0 = cacheA
    deadlock_handler_.cache_L1_1 = cacheB

    cacheA.other_cache = cacheB
    cacheB.other_cache = cacheA

    cacheA.resp_port.send_port = cacheB.req_port.send_port
    cacheA.resp_port.recv_port = cacheB.req_port.recv_port

    cacheB.resp_port.send_port = cacheA.req_port.send_port
    cacheB.resp_port.recv_port = cacheA.req_port.recv_port

    # connection between cache and bus
    cacheA.s_port.send_port = AXI_Coherence.m0_port.send_port
    cacheA.s_port.recv_port = AXI_Coherence.m0_port.recv_port

    cacheB.s_port.send_port = AXI_Coherence.m1_port.send_port
    cacheB.s_port.recv_port = AXI_Coherence.m1_port.recv_port

    # connection between bus and dram
    AXI_Coherence.s_port.send_port = Mem.m_port.send_port
    AXI_Coherence.s_port.recv_port = Mem.m_port.recv_port

    while sys_c.cycle <= SIMULATION_TIME:
        cpuA.run(sys_c)
        cpuB.run(sys_c)
        deadlock_handler_.run(sys_c)
        cacheA.run(sys_c)
        cacheB.run(sys_c)
        AXI_Coherence.run(sys_c)
        Mem.run(sys_c)

        # Components update
        cpuA.update()
        cpuB.update()
        cacheA.update()
        cacheB.update()
        AXI_Coherence.update()
        Mem.update()

        # this is rising edge
        sys_c.clk_posedge()

    cacheA.save_state_tag()
    cacheB.save_state_tag()

    cacheA.save_plrut()
    cacheB.save_plrut()

    cacheA.save_data()
    cacheB.save_data()

    cpuA.save_read_data()
    cpuB.save_read_data()

    Mem.save_mem()


def run_subsystem():
    testcase = int(input(f"Which testcase do you want to run? \n 0    : runall\n 1-{number_of_testcase}: testcase 1 - testcase {number_of_testcase} \n Your choice: "))

    if testcase == 0:
        for i in range(1, number_of_testcase + 1):
            delete_previous_expected_result(subsystem_expected_result_dir, i)

        # Generate test case IDs from 1 to 119 (as integers)
        testcase_ids = list(range(1, number_of_testcase + 1))  # Creates [1, 2, ..., 115]

        # Run test cases in parallel using 4 worker processes
        with concurrent.futures.ProcessPoolExecutor(max_workers=3) as executor:
            executor.map(run_subsystem_testcase, testcase_ids)

    elif testcase >= 1 and testcase <= number_of_testcase:
        delete_previous_expected_result(subsystem_expected_result_dir, testcase)
        run_subsystem_testcase(testcase)