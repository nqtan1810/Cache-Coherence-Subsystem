import concurrent.futures
import os
import shutil
import subprocess
import concurrent.futures

number_of_testcase = 116
cache_number_of_testcase = 16
axi_coherence_number_of_testcase = 14

# Path to the executable of Vivado
vivado_path = "C:/Xilinx/Vivado/2020.2/bin/vivado.bat"

current_dir = os.path.dirname(os.path.abspath(__file__))
testcase_dir = os.path.dirname(current_dir)
hw_design_dir = os.path.dirname(os.path.dirname(current_dir))
vivado_proj_dir = os.path.join(hw_design_dir, "coherence_cache")

current_dir = current_dir.replace("\\", "/")  # Replace backslashes with forward slashes
testcase_dir = testcase_dir.replace("\\", "/")  # Replace backslashes with forward slashes
hw_design_dir = hw_design_dir.replace("\\", "/")  # Replace backslashes with forward slashes
vivado_proj_dir = vivado_proj_dir.replace("\\", "/")  # Replace backslashes with forward slashes


def ignore_git_and_md_files(directory, files):
    """Ignore .git directory and all Markdown (.md) files."""
    return {f for f in files if f == ".git" or f.endswith(".md")}


def copy_vivado_projects(testcase_id):
    # print("Start copy Vivado projects for running parallel!")
    # Source directory
    source_folder = os.path.join(hw_design_dir, "coherence_cache")
    # Base destination directory
    destination_base = os.path.join(current_dir, "copied_vivado_project")

    # Copy Vivado project
    destination_folder = f"{destination_base}/copied_vivado_project_{testcase_id}"
    if not os.path.exists(destination_folder):
        shutil.copytree(source_folder, destination_folder, ignore=ignore_git_and_md_files, dirs_exist_ok=True)
        print(f"Copied to {destination_folder}")
    # print("Vivado projects are copied successfully!")


def delete_copied_vivado_projects(testcase_id):
    # print("Start delete Vivado projects!")
    # Đường dẫn thư mục đích
    destination_base = os.path.join(current_dir, "copied_vivado_project")

    # Xóa các thư mục Vivado project
    destination_folder = f"{destination_base}/copied_vivado_project_{testcase_id}"
    if os.path.exists(destination_folder):
        shutil.rmtree(destination_folder)
        print(f"Deleted {destination_folder}")
    # print("Vivado projects are deleted successfully")


def delete_previous_actual_result(actual_result_dir, testcase_id):
    # print("Start delete previous actual_result!")
    result_path = os.path.join(current_dir, f"{actual_result_dir}/testcase_{testcase_id}")
    if os.path.exists(result_path):
        shutil.rmtree(result_path)
        print(f"Deleted {result_path}")
    # print("Finish delete previous actual_result!")


def update_tcl_scripts(run_testbench_file, testcase_id):
    # print("Start update Tcl script to run Vivado project!")
    # Đường dẫn gốc của file .tcl
    tcl_script_path = os.path.join(current_dir, f"{run_testbench_file}.tcl")
    # Đường dẫn thư mục đích
    destination_base = os.path.join(current_dir, "copied_vivado_project")

    # Đọc nội dung file .tcl gốc
    with open(tcl_script_path, 'r') as file:
        tcl_content = file.read()

    # Tạo và cập nhật các file .tcl mới
    new_project_path = f"{destination_base}/copied_vivado_project_{testcase_id}/"
    new_project_path = new_project_path.replace("\\", "/")  # Replace backslashes with forward slashes
    updated_content = tcl_content.replace("***/", new_project_path)

    new_tcl_script_path = f"{destination_base}/copied_vivado_project_{testcase_id}/{run_testbench_file}.tcl"
    with open(new_tcl_script_path, 'w') as new_file:
        new_file.write(updated_content)
        print(f"Tcl in copied_vivado_project_{testcase_id} has been updated!")
    # print("Tcl scripts are updated successfully!")


# def copy_vivado_bat(testcase_id):
#     print("Start copy vivado.bat!")
#     # Đường dẫn gốc của file .tcl
#     vivado_bat_path = "C:/Xilinx/Vivado/2020.2/bin/vivado.bat"
#     # Đường dẫn thư mục đích
#     destination_base = os.path.join(current_dir, "copied_vivado_project")
#
#     # Đọc nội dung file .tcl gốc
#     with open(vivado_bat_path, 'r') as file:
#         test_content = file.read()
#
#     new_vivado_bat_path = f"{destination_base}/copied_vivado_project_{testcase_id}/vivado.bat"
#     with open(new_vivado_bat_path, 'w') as new_file:
#         new_file.write(test_content)
#         print(f"vivado.bat in copied_vivado_project_{testcase_id} has been copied!")
#     print("vivado.bat are copied successfully!")


def copy_testcases(testcase_id):
    # print("Start copy testcases!")
    base_dir_path = os.path.join(current_dir, "copied_vivado_project")
    base_dir_path = base_dir_path.replace("\\", "/")  # Replace backslashes with forward slashes

    dst_instr_mem_A_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/instr_mem_A.mem"
    dst_instr_mem_B_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/instr_mem_B.mem"
    dst_main_memory_init_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/main_memory_init.mem"

    src_instr_mem_A_path = f"{testcase_dir}/generate_instruction/subsystem_testcase/testcase_{testcase_id}/instr_mem_A.mem"
    src_instr_mem_B_path = f"{testcase_dir}/generate_instruction/subsystem_testcase/testcase_{testcase_id}/instr_mem_B.mem"
    src_main_memory_init_path = f"{testcase_dir}/generate_instruction/subsystem_testcase/testcase_{testcase_id}/main_memory_init.mem"

    # copy testcase
    shutil.copyfile(src_instr_mem_A_path, dst_instr_mem_A_path)
    shutil.copyfile(src_instr_mem_B_path, dst_instr_mem_B_path)
    shutil.copyfile(src_main_memory_init_path, dst_main_memory_init_path)
    print(f"Testcase {testcase_id} has been copied!")

    # update path in subsystem_top_tb.sv
    subsystem_top_tb_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/subsystem_top_tb.sv"
    with open(subsystem_top_tb_path, 'r') as file:
        subsystem_top_tb_content = file.read()
    replace_data = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}")
    replace_data = replace_data.replace("\\", "/")  # Replace backslashes with forward slashes
    updated_subsystem_top_tb_content = subsystem_top_tb_content.replace("D:/University/KLTN/hw_design/coherence_cache", replace_data)

    with open(subsystem_top_tb_path, 'w') as updated_file:
        updated_file.write(updated_subsystem_top_tb_content)

    # print("Testcases are copied successfully!")

def copy_cache_testcases(testcase_id):
    # print("Start copy testcases!")
    base_dir_path = os.path.join(current_dir, "copied_vivado_project")
    base_dir_path = base_dir_path.replace("\\", "/")  # Replace backslashes with forward slashes

    dst_instr_mem_A_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/instr_mem_A.mem"
    dst_main_memory_init_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/main_memory_init.mem"

    src_instr_mem_A_path = f"{testcase_dir}/generate_instruction/cache_testcase/testcase_{testcase_id}/instr_mem_A.mem"
    src_main_memory_init_path = f"{testcase_dir}/generate_instruction/cache_testcase/testcase_{testcase_id}/main_memory_init.mem"

    # copy testcase
    shutil.copyfile(src_instr_mem_A_path, dst_instr_mem_A_path)
    shutil.copyfile(src_main_memory_init_path, dst_main_memory_init_path)
    print(f"Testcase {testcase_id} has been copied!")

    # update path in subsystem_top_tb.sv
    cache_top_tb_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/cache_top_tb.sv"
    with open(cache_top_tb_path, 'r') as file:
        subsystem_top_tb_content = file.read()
    replace_data = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}")
    replace_data = replace_data.replace("\\", "/")  # Replace backslashes with forward slashes
    updated_subsystem_top_tb_content = subsystem_top_tb_content.replace("D:/University/KLTN/hw_design/coherence_cache", replace_data)

    with open(cache_top_tb_path, 'w') as updated_file:
        updated_file.write(updated_subsystem_top_tb_content)

    # print("Testcases are copied successfully!")


def copy_axi_coherence_testcases(testcase_id):
    # print("Start copy testcases!")
    base_dir_path = os.path.join(current_dir, "copied_vivado_project")
    base_dir_path = base_dir_path.replace("\\", "/")  # Replace backslashes with forward slashes

    dst_instr_mem_A_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/instr_mem_A.mem"
    dst_instr_mem_B_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/instr_mem_B.mem"
    dst_main_memory_init_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/main_memory_init.mem"

    src_instr_mem_A_path = f"{testcase_dir}/generate_instruction/axi_coherence_testcase/testcase_{testcase_id}/instr_mem_A.mem"
    src_instr_mem_B_path = f"{testcase_dir}/generate_instruction/axi_coherence_testcase/testcase_{testcase_id}/instr_mem_B.mem"
    src_main_memory_init_path = f"{testcase_dir}/generate_instruction/axi_coherence_testcase/testcase_{testcase_id}/main_memory_init.mem"

    # copy testcase
    shutil.copyfile(src_instr_mem_A_path, dst_instr_mem_A_path)
    shutil.copyfile(src_instr_mem_B_path, dst_instr_mem_B_path)
    shutil.copyfile(src_main_memory_init_path, dst_main_memory_init_path)
    print(f"Testcase {testcase_id} has been copied!")

    # update path in subsystem_top_tb.sv
    subsystem_top_tb_path = f"{base_dir_path}/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/axi_coherence_top_tb.sv"
    with open(subsystem_top_tb_path, 'r') as file:
        subsystem_top_tb_content = file.read()
    replace_data = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}")
    replace_data = replace_data.replace("\\", "/")  # Replace backslashes with forward slashes
    updated_subsystem_top_tb_content = subsystem_top_tb_content.replace("D:/University/KLTN/hw_design/coherence_cache", replace_data)

    with open(subsystem_top_tb_path, 'w') as updated_file:
        updated_file.write(updated_subsystem_top_tb_content)

    # print("Testcases are copied successfully!")


def run_testcase(run_testbench_file, testcase_id):
    print(f"Start running testcase_{testcase_id}!")

    project_dir = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}")
    tcl_script_path = os.path.join(project_dir, f"{run_testbench_file}.tcl")
    log_file_path = os.path.join(project_dir, "run.log")

    # Ensure the Tcl script file exists
    if not os.path.isfile(tcl_script_path):
        print(f"[Error] Tcl script '{tcl_script_path}' does not exist!")
        exit(1)

    vivado_command = [vivado_path, "-mode", "batch", "-source", tcl_script_path, "-nojournal", "-nolog"]

    # Run the command and write both stdout and stderr to run.log
    with open(log_file_path, "w") as log_file:
        result = subprocess.run(vivado_command, stdout=log_file, stderr=subprocess.STDOUT, cwd=project_dir)

    if result.returncode == 0:
        print(f"Finish running testcase_{testcase_id}!")
    else:
        print(f"[Error] Testcase_{testcase_id} failed. Check log at: {log_file_path}")


def copy_actual_result(testcase_id, behavioral0_post_synthesis_timming1):
    src_result_path = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/")
    dst_result_path = os.path.join(current_dir, f"subsystem_actual_result/testcase_{testcase_id}")
    src_log_path = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}")

    if behavioral0_post_synthesis_timming1 == 0:
        dst_log_path = os.path.join(current_dir, f"subsystem_logs")
    elif behavioral0_post_synthesis_timming1 == 1:
        dst_log_path = os.path.join(current_dir, f"subsystem_timing_logs")
    else:
        print("Unsupported option!")
        exit(1)

    os.makedirs(dst_result_path, exist_ok=True)

    # source
    src_state_tag_A_result = os.path.join(src_result_path, "state_tag_A.mem")
    src_state_tag_B_result = os.path.join(src_result_path, "state_tag_B.mem")

    src_plrut_ram_A_result = os.path.join(src_result_path, "plrut_ram_A.mem")
    src_plrut_ram_B_result = os.path.join(src_result_path, "plrut_ram_B.mem")

    src_data_ram_A_result = os.path.join(src_result_path, "data_ram_A.mem")
    src_data_ram_B_result = os.path.join(src_result_path, "data_ram_B.mem")

    src_read_data_A_result = os.path.join(src_result_path, "read_data_A.mem")
    src_read_data_B_result = os.path.join(src_result_path, "read_data_B.mem")

    src_main_memory_result = os.path.join(src_result_path, "main_memory_result.mem")

    src_log_file = os.path.join(src_log_path, "run.log")

    # destination
    dst_state_tag_A_result = os.path.join(dst_result_path, "state_tag_A.mem")
    dst_state_tag_B_result = os.path.join(dst_result_path, "state_tag_B.mem")

    dst_plrut_ram_A_result = os.path.join(dst_result_path, "plrut_ram_A.mem")
    dst_plrut_ram_B_result = os.path.join(dst_result_path, "plrut_ram_B.mem")

    dst_data_ram_A_result = os.path.join(dst_result_path, "data_ram_A.mem")
    dst_data_ram_B_result = os.path.join(dst_result_path, "data_ram_B.mem")

    dst_read_data_A_result = os.path.join(dst_result_path, "read_data_A.mem")
    dst_read_data_B_result = os.path.join(dst_result_path, "read_data_B.mem")

    dst_main_memory_result = os.path.join(dst_result_path, "main_memory_result.mem")

    dst_log_file = os.path.join(dst_log_path, f"run_{testcase_id}.log")

    # copy result to actual_result folder
    shutil.copyfile(src_state_tag_A_result, dst_state_tag_A_result)
    shutil.copyfile(src_state_tag_B_result, dst_state_tag_B_result)

    shutil.copyfile(src_plrut_ram_A_result, dst_plrut_ram_A_result)
    shutil.copyfile(src_plrut_ram_B_result, dst_plrut_ram_B_result)

    shutil.copyfile(src_data_ram_A_result, dst_data_ram_A_result)
    shutil.copyfile(src_data_ram_B_result, dst_data_ram_B_result)

    shutil.copyfile(src_read_data_A_result, dst_read_data_A_result)
    shutil.copyfile(src_read_data_B_result, dst_read_data_B_result)

    shutil.copyfile(src_main_memory_result, dst_main_memory_result)

    shutil.copyfile(src_log_file, dst_log_file)
    print(f"Result of testcase_{testcase_id} has been saved!")

def copy_cache_actual_result(testcase_id):
    src_result_path = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/")
    dst_result_path = os.path.join(current_dir, f"cache_actual_result/testcase_{testcase_id}")
    src_log_path = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}")
    dst_log_path = os.path.join(current_dir, f"cache_logs")

    os.makedirs(dst_result_path, exist_ok=True)

    # source
    src_state_tag_A_result = os.path.join(src_result_path, "state_tag_A.mem")
    src_plrut_ram_A_result = os.path.join(src_result_path, "plrut_ram_A.mem")
    src_data_ram_A_result = os.path.join(src_result_path, "data_ram_A.mem")
    src_read_data_A_result = os.path.join(src_result_path, "read_data_A.mem")
    src_main_memory_result = os.path.join(src_result_path, "main_memory_result.mem")
    src_log_file = os.path.join(src_log_path, "run.log")

    # destination
    dst_state_tag_A_result = os.path.join(dst_result_path, "state_tag_A.mem")
    dst_plrut_ram_A_result = os.path.join(dst_result_path, "plrut_ram_A.mem")
    dst_data_ram_A_result = os.path.join(dst_result_path, "data_ram_A.mem")
    dst_read_data_A_result = os.path.join(dst_result_path, "read_data_A.mem")
    dst_main_memory_result = os.path.join(dst_result_path, "main_memory_result.mem")
    dst_log_file = os.path.join(dst_log_path, f"run_{testcase_id}.log")

    # copy result to actual_result folder
    shutil.copyfile(src_state_tag_A_result, dst_state_tag_A_result)
    shutil.copyfile(src_plrut_ram_A_result, dst_plrut_ram_A_result)
    shutil.copyfile(src_data_ram_A_result, dst_data_ram_A_result)
    shutil.copyfile(src_read_data_A_result, dst_read_data_A_result)
    shutil.copyfile(src_main_memory_result, dst_main_memory_result)
    shutil.copyfile(src_log_file, dst_log_file)
    print(f"Result of testcase_{testcase_id} has been saved!")


def copy_axi_coherence_actual_result(testcase_id):
    src_result_path = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}/coherence_cache.srcs/sim_1/new/")
    dst_result_path = os.path.join(current_dir, f"axi_coherence_actual_result/testcase_{testcase_id}")
    src_log_path = os.path.join(current_dir, f"copied_vivado_project/copied_vivado_project_{testcase_id}")
    dst_log_path = os.path.join(current_dir, f"axi_coherence_logs")

    os.makedirs(dst_result_path, exist_ok=True)

    # source
    src_read_data_A_result = os.path.join(src_result_path, "read_data_A.mem")
    src_read_data_B_result = os.path.join(src_result_path, "read_data_B.mem")
    src_main_memory_result = os.path.join(src_result_path, "main_memory_result.mem")
    src_log_file = os.path.join(src_log_path, "run.log")

    # destination
    dst_read_data_A_result = os.path.join(dst_result_path, "read_data_A.mem")
    dst_read_data_B_result = os.path.join(dst_result_path, "read_data_B.mem")
    dst_main_memory_result = os.path.join(dst_result_path, "main_memory_result.mem")
    dst_log_file = os.path.join(dst_log_path, f"run_{testcase_id}.log")

    # copy result to actual_result folder
    shutil.copyfile(src_read_data_A_result, dst_read_data_A_result)
    shutil.copyfile(src_read_data_B_result, dst_read_data_B_result)

    shutil.copyfile(src_main_memory_result, dst_main_memory_result)
    shutil.copyfile(src_log_file, dst_log_file)
    print(f"Result of testcase_{testcase_id} has been saved!")


def run_subsystem(behavioral0_post_synthesis_timming1):
    testcase = int(input(f"Which testcase do you want to run? \n 0    : runall\n 1-{number_of_testcase}: testcase 1 - testcase {number_of_testcase} \n Your choice: "))
    if behavioral0_post_synthesis_timming1 == 0:
        tcl_file_name = "subsystem_run_testbench"
    elif behavioral0_post_synthesis_timming1 == 1:
        tcl_file_name = "subsystem_run_testbench_timing"
    else:
        print("Unsupported option!")
        exit(1)


    if testcase == 0:
        for i in range(1, number_of_testcase + 1):
            delete_copied_vivado_projects(i)
        for i in range(1, number_of_testcase + 1):
            delete_previous_actual_result("subsystem_actual_result", i)
        for i in range(1, number_of_testcase + 1):
            copy_vivado_projects(i)
        for i in range(1, number_of_testcase + 1):
            update_tcl_scripts(tcl_file_name, i)
            # copy_vivado_bat(i)
        for i in range(1, number_of_testcase + 1):
            copy_testcases(i)

        # create input for running in parallel
        tcl_list = [tcl_file_name] * number_of_testcase
        # Generate test case IDs from 1 to 119 (as integers)
        testcase_ids = list(range(1, number_of_testcase + 1))  # Creates [1, 2, ..., 115]

        # Run test cases in parallel using 4 worker processes
        with concurrent.futures.ProcessPoolExecutor(max_workers=1) as executor:
            executor.map(run_testcase, tcl_list, testcase_ids)

        for i in range(1, number_of_testcase + 1):
            copy_actual_result(i, behavioral0_post_synthesis_timming1)

        for i in range(1, number_of_testcase + 1):
            delete_copied_vivado_projects(i)

    elif testcase >= 1 and testcase <= number_of_testcase:
        delete_copied_vivado_projects(testcase)
        delete_previous_actual_result("subsystem_actual_result", testcase)
        copy_vivado_projects(testcase)
        update_tcl_scripts(tcl_file_name, testcase)
        # copy_vivado_bat(testcase)
        copy_testcases(testcase)
        run_testcase(tcl_file_name, testcase)
        copy_actual_result(testcase, behavioral0_post_synthesis_timming1)
        delete_copied_vivado_projects(testcase)

def run_cache():
    testcase = int(input(f"Which testcase do you want to run? \n 0   : runall\n 1-{cache_number_of_testcase}: testcase 1 - testcase {cache_number_of_testcase} \n Your choice: "))

    if testcase == 0:
        for i in range(1, cache_number_of_testcase + 1):
            delete_copied_vivado_projects(i)
        for i in range(1, cache_number_of_testcase + 1):
            delete_previous_actual_result("cache_actual_result", i)
        for i in range(1, cache_number_of_testcase + 1):
            copy_vivado_projects(i)
        for i in range(1, cache_number_of_testcase + 1):
            update_tcl_scripts("cache_run_testbench", i)
            # copy_vivado_bat(i)
        for i in range(1, cache_number_of_testcase + 1):
            copy_cache_testcases(i)

        # create input for running in parallel
        tcl_list = ["cache_run_testbench"] * cache_number_of_testcase
        # Generate test case IDs from 1 to 119 (as integers)
        testcase_ids = list(range(1, cache_number_of_testcase + 1))  # Creates [1, 2, ..., 115]

        # Run test cases in parallel using 4 worker processes
        with concurrent.futures.ProcessPoolExecutor(max_workers=1) as executor:
            executor.map(run_testcase, tcl_list, testcase_ids)

        for i in range(1, cache_number_of_testcase + 1):
            copy_cache_actual_result(i)

        for i in range(1, cache_number_of_testcase + 1):
            delete_copied_vivado_projects(i)

    elif testcase >= 1 and testcase <= cache_number_of_testcase:
        delete_copied_vivado_projects(testcase)
        delete_previous_actual_result("cache_actual_result", testcase)
        copy_vivado_projects(testcase)
        update_tcl_scripts("cache_run_testbench", testcase)
        # copy_vivado_bat(testcase)
        copy_cache_testcases(testcase)
        run_testcase("cache_run_testbench", testcase)
        copy_cache_actual_result(testcase)
        delete_copied_vivado_projects(testcase)


def run_axi_coherence():
    testcase = int(input(f"Which testcase do you want to run? \n 0    : runall\n 1-{axi_coherence_number_of_testcase}: testcase 1 - testcase {axi_coherence_number_of_testcase} \n Your choice: "))

    if testcase == 0:
        for i in range(1, axi_coherence_number_of_testcase + 1):
            delete_copied_vivado_projects(i)
        for i in range(1, axi_coherence_number_of_testcase + 1):
            delete_previous_actual_result("axi_coherence_actual_result", i)
        for i in range(1, axi_coherence_number_of_testcase + 1):
            copy_vivado_projects(i)
        for i in range(1, axi_coherence_number_of_testcase + 1):
            update_tcl_scripts("axi_coherence_run_testbench", i)
            # copy_vivado_bat(i)
        for i in range(1, axi_coherence_number_of_testcase + 1):
            copy_axi_coherence_testcases(i)

        # create input for running in parallel
        tcl_list = ["axi_coherence_run_testbench"] * axi_coherence_number_of_testcase
        # Generate test case IDs from 1 to 119 (as integers)
        testcase_ids = list(range(1, axi_coherence_number_of_testcase + 1))  # Creates [1, 2, ..., 115]

        # Run test cases in parallel using 4 worker processes
        with concurrent.futures.ProcessPoolExecutor(max_workers=1) as executor:
            executor.map(run_testcase, tcl_list, testcase_ids)

        for i in range(1, axi_coherence_number_of_testcase + 1):
            copy_axi_coherence_actual_result(i)

        for i in range(1, axi_coherence_number_of_testcase + 1):
            delete_copied_vivado_projects(i)

    elif testcase >= 1 and testcase <= axi_coherence_number_of_testcase:
        delete_copied_vivado_projects(testcase)
        delete_previous_actual_result("axi_coherence_actual_result", testcase)
        copy_vivado_projects(testcase)
        update_tcl_scripts("axi_coherence_run_testbench", testcase)
        # copy_vivado_bat(testcase)
        copy_axi_coherence_testcases(testcase)
        run_testcase("axi_coherence_run_testbench", testcase)
        copy_axi_coherence_actual_result(testcase)
        delete_copied_vivado_projects(testcase)


if __name__ == "__main__":
    while (testbench_id := int(input("Which component do you want to run simulation?\n1. Run Cache\n2. Run AXI Bus with ACE extension\n3. Run Subsystem\nEnter your choice: "))) not in [1, 2, 3]:
        print("Your choice is unsupported!")
    if testbench_id == 1:
        run_cache()
    elif testbench_id == 2:
        run_axi_coherence()
    elif testbench_id == 3:
        run_subsystem(0)
