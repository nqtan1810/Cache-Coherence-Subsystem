/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include <xuartlite_l.h>
#include <xil_io.h>
#include <sleep.h>
#include "subsystem.h"

#define core_0					0x0
#define core_1					0x1

#define reset              		0x00
#define enable             		0x04
#define m0_reg_rd_en       		0x08
#define m0_reg_addr        		0x0c
#define m0_reg_data        		0x10
#define m1_reg_rd_en       		0x14
#define m1_reg_addr        		0x18
#define m1_reg_data        		0x1c
#define m0_wr_i_cache_en    	0x20
#define m0_wr_i_cache_addr  	0x24
#define m0_wr_i_cache_data  	0x28
#define m1_wr_i_cache_en    	0x2c
#define m1_wr_i_cache_addr  	0x30
#define m1_wr_i_cache_data  	0x34
#define m0_rd_d_cache_en    	0x38
#define m0_rd_d_cache_way_sel   0x3c
#define m0_rd_d_cache_addr     	0x40
#define m0_rd_d_cache_data     	0x44
#define m0_wr_d_cache_en     	0x48
#define m0_wr_d_cache_addr     	0x4c
#define m0_wr_d_cache_data    	0x50
#define m1_rd_d_cache_en    	0x54
#define m1_rd_d_cache_way_sel   0x58
#define m1_rd_d_cache_addr    	0x5c
#define m1_rd_d_cache_data    	0x60
#define m1_wr_d_cache_en    	0x64
#define m1_wr_d_cache_addr    	0x68
#define m1_wr_d_cache_data    	0x6c
#define m_wr_mem_en    			0x70
#define m_wr_mem_addr    		0x74
#define m_wr_mem_data    		0x78

#define EN_RESET				0x1
#define DIS_RESET				0x0
#define ENABLE					0x1
#define DISABLE					0x0
#define I_CACHE_WRITE_VAL 		0x800000
#define D_CACHE_WRITE_VAL 		0x1000000

#define M_STATE					0x0
#define O_STATE					0x1
#define E_STATE					0x2
#define S_STATE					0x3
#define I_STATE					0x4

#define REG_NUM					0x20
#define NUM_WAY					0x4
#define SET_NUM					0x10
#define INSTR_NUM				0x100

#define MEM_SIZE				(1 << 16)	// 2^16 = 65536 = 64KB

#define printf           		xil_printf

uint32_t addr_inst_0;
uint32_t addr_inst_1;

// function prototype
void Reset_SoC ();
void Write_Cache (uint8_t core_id, uint8_t set_index);
void Display_State(uint8_t state_val);
void Read_Cache (uint8_t core_id, uint8_t set_index);
void Display_Cache_State (uint8_t core_id);
void Reset_Cache ();
void Reset_Mem ();
void Enable_SoC (uint32_t period);
void Load_Instr(uint8_t core_id, uint32_t *addr_inst, uint32_t data_inst);
void Read_Reg(uint8_t core_id, uint8_t reg_addr);
void Display_RegFile (uint32_t core_id);
void Init_Testcase (unsigned char tc_id);


void Reset_SoC ()
{
    u32 baseaddr;
    baseaddr = (u32) XPAR_SUBSYSTEM_0_S00_AXI_BASEADDR;

    SUBSYSTEM_mWriteReg (baseaddr, reset, EN_RESET);
	SUBSYSTEM_mWriteReg (baseaddr, enable, DISABLE);
	usleep(1);

    Reset_Cache ();
    Reset_Mem ();

    usleep(100);
    SUBSYSTEM_mWriteReg (baseaddr, reset, DIS_RESET);
    usleep(1);
}

void Write_Cache (uint8_t core_id, uint8_t set_index)
{
	u32 baseaddr;
	baseaddr = (u32) XPAR_SUBSYSTEM_0_S00_AXI_BASEADDR;

	if (core_id == core_0) {
		// I-Cache
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_i_cache_addr, set_index);
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_i_cache_data, I_CACHE_WRITE_VAL);
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_i_cache_en, ENABLE);
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_i_cache_en, DISABLE);
		// D-Cache
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_d_cache_addr, set_index);
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_d_cache_data, D_CACHE_WRITE_VAL);
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_d_cache_en, ENABLE);
		SUBSYSTEM_mWriteReg (baseaddr, m0_wr_d_cache_en, DISABLE);
	}
	else {
		// I-Cache
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_i_cache_addr, set_index);
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_i_cache_data, I_CACHE_WRITE_VAL);
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_i_cache_en, ENABLE);
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_i_cache_en, DISABLE);
		// D-Cache
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_d_cache_addr, set_index);
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_d_cache_data, D_CACHE_WRITE_VAL);
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_d_cache_en, ENABLE);
		SUBSYSTEM_mWriteReg (baseaddr, m1_wr_d_cache_en, DISABLE);
	}
}

void Display_State(uint8_t state_val)
{
	if (state_val == M_STATE)
		printf("\tM\t");
	if (state_val == O_STATE)
		printf("\tO\t");
	if (state_val == E_STATE)
		printf("\tE\t");
	if (state_val == S_STATE)
		printf("\tS\t");
	if (state_val == I_STATE)
		printf("\tI\t");
}

void Read_Cache (uint8_t core_id, uint8_t set_index)
{
	u32 baseaddr;
	baseaddr = (u32) XPAR_SUBSYSTEM_0_S00_AXI_BASEADDR;

	for(int i = 0; i < NUM_WAY; i++){
		if (core_id == core_0) {
			// D-Cache
			SUBSYSTEM_mWriteReg (baseaddr, m0_rd_d_cache_way_sel, 1 << i);
			SUBSYSTEM_mWriteReg (baseaddr, m0_rd_d_cache_addr, set_index);
			SUBSYSTEM_mWriteReg (baseaddr, m0_rd_d_cache_en, ENABLE);
			// display read data
			Display_State ((SUBSYSTEM_mReadReg  (baseaddr, m0_rd_d_cache_data) >> 22) & 0x7);
			SUBSYSTEM_mWriteReg (baseaddr, m0_rd_d_cache_en, DISABLE);
		}
		else {
			// D-Cache
			SUBSYSTEM_mWriteReg (baseaddr, m1_rd_d_cache_way_sel, 1 << i);
			SUBSYSTEM_mWriteReg (baseaddr, m1_rd_d_cache_addr, set_index);
			SUBSYSTEM_mWriteReg (baseaddr, m1_rd_d_cache_en, ENABLE);
			// display read data
			Display_State ((SUBSYSTEM_mReadReg  (baseaddr, m1_rd_d_cache_data) >> 22) & 0x7);
			SUBSYSTEM_mWriteReg (baseaddr, m1_rd_d_cache_en, DISABLE);
		}
	}
	printf("\n");
}

void Display_Cache_State (uint8_t core_id)
{
	printf ("******* State of D-Cache CORE_%0d *******\n", core_id);
	for (int i = 0; i < SET_NUM; i++){
		Read_Cache (core_id, i);
	}
}

void Reset_Cache ()
{
	for(int i = 0; i < SET_NUM; i++){
		Write_Cache (core_0, i);
		Write_Cache (core_1, i);
	}
}

void Reset_Mem ()
{
//    addr_inst_0 = 0;
//    addr_inst_1 = 0;
//    for(int i = 0; i < INSTR_NUM; i++){
//    	Load_Instr (core_0, &addr_inst_0, 0x00000000);
//    	Load_Instr (core_1, &addr_inst_1, 0x00000000);
//    }
//    addr_inst_0 = 0;
//    addr_inst_1 = 0;
	addr_inst_0 = 0;
	addr_inst_1 = 0;
	for (int i = 0; i < MEM_SIZE; i++){
		Load_Instr (core_0, &addr_inst_0, 0x00000000);
	}
	addr_inst_0 = 0;
	addr_inst_1 = 0;
}

void Enable_SoC (uint32_t period)
{
    u32 baseaddr;
    baseaddr = (u32) XPAR_SUBSYSTEM_0_S00_AXI_BASEADDR;

    usleep(period);
    SUBSYSTEM_mWriteReg (baseaddr, enable, ENABLE);
	usleep(period + 1000);
	SUBSYSTEM_mWriteReg (baseaddr, enable, DISABLE);
	usleep(period);
}

void Load_Instr(uint8_t core_id, uint32_t *addr_inst, uint32_t data_inst)
{
    u32 baseaddr;
    baseaddr = (u32) XPAR_SUBSYSTEM_0_S00_AXI_BASEADDR;

    SUBSYSTEM_mWriteReg (baseaddr, m_wr_mem_addr, *addr_inst + core_id * INSTR_NUM * 4);
    SUBSYSTEM_mWriteReg (baseaddr, m_wr_mem_data, data_inst);
    SUBSYSTEM_mWriteReg (baseaddr, m_wr_mem_en, ENABLE);
    SUBSYSTEM_mWriteReg (baseaddr, m_wr_mem_en, DISABLE);
    *addr_inst = *addr_inst + 4;
}

void Read_Reg(uint8_t core_id, uint8_t reg_addr)
{
    u32 baseaddr;
    baseaddr = (u32) XPAR_SUBSYSTEM_0_S00_AXI_BASEADDR;

    if (core_id == core_0) {
    	SUBSYSTEM_mWriteReg (baseaddr, m0_reg_addr , reg_addr);
    	SUBSYSTEM_mWriteReg (baseaddr, m0_reg_rd_en, ENABLE);
    	printf("x%d = %x\n", reg_addr, SUBSYSTEM_mReadReg  (baseaddr, m0_reg_data));
    	SUBSYSTEM_mWriteReg (baseaddr, m0_reg_rd_en, DISABLE);
    }
    else {
    	SUBSYSTEM_mWriteReg (baseaddr, m1_reg_addr , reg_addr);
		SUBSYSTEM_mWriteReg (baseaddr, m1_reg_rd_en, ENABLE);
		printf("x%d = %x\n", reg_addr, SUBSYSTEM_mReadReg  (baseaddr, m1_reg_data));
		SUBSYSTEM_mWriteReg (baseaddr, m1_reg_rd_en, DISABLE);
    }
}

void Display_RegFile (uint32_t core_id)
{
	printf("Register File of Core_%d\n", core_id);
	for (int i = 0; i < REG_NUM; i = i + 1)
    {
		Read_Reg(core_id, i);
    }
}

void Init_Testcase (unsigned char tc_id)
{
	printf("Start initializing of Testcase_%c\n", tc_id);
	switch(tc_id){
		case '1':{
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x00000113);
			Load_Instr (core_0, &addr_inst_0, 0x01000193);
			Load_Instr (core_0, &addr_inst_0, 0x02310663);
			Load_Instr (core_0, &addr_inst_0, 0x00ABC337);
			Load_Instr (core_0, &addr_inst_0, 0x7EF36313);
			Load_Instr (core_0, &addr_inst_0, 0x0062C2B3);
			Load_Instr (core_0, &addr_inst_0, 0xFF02F293);
			Load_Instr (core_0, &addr_inst_0, 0x0022E233);
			Load_Instr (core_0, &addr_inst_0, 0x00211293);
			Load_Instr (core_0, &addr_inst_0, 0x00508333);
			Load_Instr (core_0, &addr_inst_0, 0x00432023);
			Load_Instr (core_0, &addr_inst_0, 0x00110113);
			Load_Instr (core_0, &addr_inst_0, 0xFD9FF06F);
			Load_Instr (core_0, &addr_inst_0, 0x00000113);
			Load_Instr (core_0, &addr_inst_0, 0x01000193);
			Load_Instr (core_0, &addr_inst_0, 0xFFF00613);
			Load_Instr (core_0, &addr_inst_0, 0x02310E63);
			Load_Instr (core_0, &addr_inst_0, 0x00211213);
			Load_Instr (core_0, &addr_inst_0, 0x004082B3);
			Load_Instr (core_0, &addr_inst_0, 0x0002A303);
			Load_Instr (core_0, &addr_inst_0, 0x00029383);
			Load_Instr (core_0, &addr_inst_0, 0x0002D403);
			Load_Instr (core_0, &addr_inst_0, 0x00028483);
			Load_Instr (core_0, &addr_inst_0, 0x0002C503);
			Load_Instr (core_0, &addr_inst_0, 0x0065E5B3);
			Load_Instr (core_0, &addr_inst_0, 0x00767633);
			Load_Instr (core_0, &addr_inst_0, 0x0086C6B3);
			Load_Instr (core_0, &addr_inst_0, 0x00970733);
			Load_Instr (core_0, &addr_inst_0, 0x00A787B3);
			Load_Instr (core_0, &addr_inst_0, 0x00110113);
			Load_Instr (core_0, &addr_inst_0, 0xFC9FF06F);
			Load_Instr (core_0, &addr_inst_0, 0x01400093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x123452B7);
			Load_Instr (core_0, &addr_inst_0, 0x6782E293);
			Load_Instr (core_0, &addr_inst_0, 0x0050A023);
			Load_Instr (core_0, &addr_inst_0, 0x01800093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0xCAFEB2B7);
			Load_Instr (core_0, &addr_inst_0, 0x0BE2E293);
			Load_Instr (core_0, &addr_inst_0, 0x0050A023);
			Load_Instr (core_0, &addr_inst_0, 0x01C00093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x135792B7);
			Load_Instr (core_0, &addr_inst_0, 0x0E02E293);
			Load_Instr (core_0, &addr_inst_0, 0x0050A023);
			Load_Instr (core_0, &addr_inst_0, 0x02000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x2468A2B7);
			Load_Instr (core_0, &addr_inst_0, 0x0CE2E293);
			Load_Instr (core_0, &addr_inst_0, 0x0050A023);
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x00000113);
			Load_Instr (core_0, &addr_inst_0, 0x01000193);
			Load_Instr (core_0, &addr_inst_0, 0xFFF00893);
			Load_Instr (core_0, &addr_inst_0, 0x02310E63);
			Load_Instr (core_0, &addr_inst_0, 0x00211213);
			Load_Instr (core_0, &addr_inst_0, 0x004082B3);
			Load_Instr (core_0, &addr_inst_0, 0x0002A303);
			Load_Instr (core_0, &addr_inst_0, 0x00029383);
			Load_Instr (core_0, &addr_inst_0, 0x0002D403);
			Load_Instr (core_0, &addr_inst_0, 0x00028483);
			Load_Instr (core_0, &addr_inst_0, 0x0002C503);
			Load_Instr (core_0, &addr_inst_0, 0x00686833);
			Load_Instr (core_0, &addr_inst_0, 0x0078F8B3);
			Load_Instr (core_0, &addr_inst_0, 0x00894933);
			Load_Instr (core_0, &addr_inst_0, 0x009989B3);
			Load_Instr (core_0, &addr_inst_0, 0x00AA0A33);
			Load_Instr (core_0, &addr_inst_0, 0x00110113);
			Load_Instr (core_0, &addr_inst_0, 0xFC9FF06F);
			Load_Instr (core_0, &addr_inst_0, 0x0105CAB3);
			Load_Instr (core_0, &addr_inst_0, 0x01164B33);
			Load_Instr (core_0, &addr_inst_0, 0x0126CBB3);
			Load_Instr (core_0, &addr_inst_0, 0x01374C33);
			Load_Instr (core_0, &addr_inst_0, 0x0147CCB3);

			Load_Instr (core_1, &addr_inst_1, 0x02400093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x00000113);
			Load_Instr (core_1, &addr_inst_1, 0x01000193);
			Load_Instr (core_1, &addr_inst_1, 0x02310663);
			Load_Instr (core_1, &addr_inst_1, 0x00ABC337);
			Load_Instr (core_1, &addr_inst_1, 0x7EF36313);
			Load_Instr (core_1, &addr_inst_1, 0x0062C2B3);
			Load_Instr (core_1, &addr_inst_1, 0xFF02F293);
			Load_Instr (core_1, &addr_inst_1, 0x0022E233);
			Load_Instr (core_1, &addr_inst_1, 0x00211293);
			Load_Instr (core_1, &addr_inst_1, 0x00508333);
			Load_Instr (core_1, &addr_inst_1, 0x00432023);
			Load_Instr (core_1, &addr_inst_1, 0x00110113);
			Load_Instr (core_1, &addr_inst_1, 0xFD9FF06F);
			Load_Instr (core_1, &addr_inst_1, 0x00000113);
			Load_Instr (core_1, &addr_inst_1, 0x01000193);
			Load_Instr (core_1, &addr_inst_1, 0xFFF00B13);
			Load_Instr (core_1, &addr_inst_1, 0x02310E63);
			Load_Instr (core_1, &addr_inst_1, 0x00211213);
			Load_Instr (core_1, &addr_inst_1, 0x004082B3);
			Load_Instr (core_1, &addr_inst_1, 0x0002A303);
			Load_Instr (core_1, &addr_inst_1, 0x00029383);
			Load_Instr (core_1, &addr_inst_1, 0x0002D403);
			Load_Instr (core_1, &addr_inst_1, 0x00028483);
			Load_Instr (core_1, &addr_inst_1, 0x0002C503);
			Load_Instr (core_1, &addr_inst_1, 0x006AEAB3);
			Load_Instr (core_1, &addr_inst_1, 0x007B7B33);
			Load_Instr (core_1, &addr_inst_1, 0x008BCBB3);
			Load_Instr (core_1, &addr_inst_1, 0x009C0C33);
			Load_Instr (core_1, &addr_inst_1, 0x00AC8CB3);
			Load_Instr (core_1, &addr_inst_1, 0x00110113);
			Load_Instr (core_1, &addr_inst_1, 0xFC9FF06F);
			Load_Instr (core_1, &addr_inst_1, 0x02800093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x123452B7);
			Load_Instr (core_1, &addr_inst_1, 0x6782E293);
			Load_Instr (core_1, &addr_inst_1, 0x0050A023);
			Load_Instr (core_1, &addr_inst_1, 0x02C00093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0xCAFEB2B7);
			Load_Instr (core_1, &addr_inst_1, 0x0BE2E293);
			Load_Instr (core_1, &addr_inst_1, 0x0050A023);
			Load_Instr (core_1, &addr_inst_1, 0x00C00093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x135792B7);
			Load_Instr (core_1, &addr_inst_1, 0x0E02E293);
			Load_Instr (core_1, &addr_inst_1, 0x0050A023);
			Load_Instr (core_1, &addr_inst_1, 0x0C400093);
			Load_Instr (core_1, &addr_inst_1, 0x00409093);
			Load_Instr (core_1, &addr_inst_1, 0x2468A2B7);
			Load_Instr (core_1, &addr_inst_1, 0x0CE2E293);
			Load_Instr (core_1, &addr_inst_1, 0x0050A023);
			Load_Instr (core_1, &addr_inst_1, 0x02400093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x00000113);
			Load_Instr (core_1, &addr_inst_1, 0x01000193);
			Load_Instr (core_1, &addr_inst_1, 0xFFF00D93);
			Load_Instr (core_1, &addr_inst_1, 0x02310E63);
			Load_Instr (core_1, &addr_inst_1, 0x00211213);
			Load_Instr (core_1, &addr_inst_1, 0x004082B3);
			Load_Instr (core_1, &addr_inst_1, 0x0002A303);
			Load_Instr (core_1, &addr_inst_1, 0x00029383);
			Load_Instr (core_1, &addr_inst_1, 0x0002D403);
			Load_Instr (core_1, &addr_inst_1, 0x00028483);
			Load_Instr (core_1, &addr_inst_1, 0x0002C503);
			Load_Instr (core_1, &addr_inst_1, 0x006D6D33);
			Load_Instr (core_1, &addr_inst_1, 0x007DFDB3);
			Load_Instr (core_1, &addr_inst_1, 0x008E4E33);
			Load_Instr (core_1, &addr_inst_1, 0x009E8EB3);
			Load_Instr (core_1, &addr_inst_1, 0x00AF0F33);
			Load_Instr (core_1, &addr_inst_1, 0x00110113);
			Load_Instr (core_1, &addr_inst_1, 0xFC9FF06F);
			Load_Instr (core_1, &addr_inst_1, 0x01AAC5B3);
			Load_Instr (core_1, &addr_inst_1, 0x01BB4633);
			Load_Instr (core_1, &addr_inst_1, 0x01CBC6B3);
			Load_Instr (core_1, &addr_inst_1, 0x01DC4733);
			Load_Instr (core_1, &addr_inst_1, 0x01ECC7B3);
			break;
		}
		case '2':{
			Load_Instr (core_0, &addr_inst_0, 0x03200093);
			Load_Instr (core_0, &addr_inst_0, 0x00000033);
			Load_Instr (core_0, &addr_inst_0, 0xFFF08093);
			Load_Instr (core_0, &addr_inst_0, 0xFE009CE3);
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A503);
			Load_Instr (core_0, &addr_inst_0, 0x0040A583);
			Load_Instr (core_0, &addr_inst_0, 0x0080A603);
			Load_Instr (core_0, &addr_inst_0, 0x00C0A683);
			Load_Instr (core_0, &addr_inst_0, 0x0100A703);
			Load_Instr (core_0, &addr_inst_0, 0x0140A783);
			Load_Instr (core_0, &addr_inst_0, 0x0180A803);
			Load_Instr (core_0, &addr_inst_0, 0x01C0A883);
			Load_Instr (core_0, &addr_inst_0, 0x02000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x00000113);
			Load_Instr (core_0, &addr_inst_0, 0x01000193);
			Load_Instr (core_0, &addr_inst_0, 0x02310663);
			Load_Instr (core_0, &addr_inst_0, 0x13579337);
			Load_Instr (core_0, &addr_inst_0, 0x0BD36313);
			Load_Instr (core_0, &addr_inst_0, 0x0062C2B3);
			Load_Instr (core_0, &addr_inst_0, 0xFF02F293);
			Load_Instr (core_0, &addr_inst_0, 0x0022E233);
			Load_Instr (core_0, &addr_inst_0, 0x00211293);
			Load_Instr (core_0, &addr_inst_0, 0x00508333);
			Load_Instr (core_0, &addr_inst_0, 0x00432023);
			Load_Instr (core_0, &addr_inst_0, 0x00110113);
			Load_Instr (core_0, &addr_inst_0, 0xFD9FF06F);
			Load_Instr (core_0, &addr_inst_0, 0x0200AA03);
			Load_Instr (core_0, &addr_inst_0, 0x0240AA83);
			Load_Instr (core_0, &addr_inst_0, 0x0280AB03);
			Load_Instr (core_0, &addr_inst_0, 0x02C0AB83);
			Load_Instr (core_0, &addr_inst_0, 0x0300AC03);
			Load_Instr (core_0, &addr_inst_0, 0x0340AC83);
			Load_Instr (core_0, &addr_inst_0, 0x0380AD03);
			Load_Instr (core_0, &addr_inst_0, 0x03C0AD83);
			
			Load_Instr (core_1, &addr_inst_1, 0x01000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x00000113);
			Load_Instr (core_1, &addr_inst_1, 0x01000193);
			Load_Instr (core_1, &addr_inst_1, 0x02310663);
			Load_Instr (core_1, &addr_inst_1, 0x00ABC337);
			Load_Instr (core_1, &addr_inst_1, 0x7EF36313);
			Load_Instr (core_1, &addr_inst_1, 0x0062C2B3);
			Load_Instr (core_1, &addr_inst_1, 0xFF02F293);
			Load_Instr (core_1, &addr_inst_1, 0x0022E233);
			Load_Instr (core_1, &addr_inst_1, 0x00211293);
			Load_Instr (core_1, &addr_inst_1, 0x00508333);
			Load_Instr (core_1, &addr_inst_1, 0x00432023);
			Load_Instr (core_1, &addr_inst_1, 0x00110113);
			Load_Instr (core_1, &addr_inst_1, 0xFD9FF06F);
			Load_Instr (core_1, &addr_inst_1, 0x0000A503);
			Load_Instr (core_1, &addr_inst_1, 0x0040A583);
			Load_Instr (core_1, &addr_inst_1, 0x0080A603);
			Load_Instr (core_1, &addr_inst_1, 0x00C0A683);
			Load_Instr (core_1, &addr_inst_1, 0x0100A703);
			Load_Instr (core_1, &addr_inst_1, 0x0140A783);
			Load_Instr (core_1, &addr_inst_1, 0x0180A803);
			Load_Instr (core_1, &addr_inst_1, 0x01C0A883);
			Load_Instr (core_1, &addr_inst_1, 0x03200113);
			Load_Instr (core_1, &addr_inst_1, 0x00000033);
			Load_Instr (core_1, &addr_inst_1, 0xFFF10113);
			Load_Instr (core_1, &addr_inst_1, 0xFE011CE3);
			Load_Instr (core_1, &addr_inst_1, 0x02000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x0200AA03);
			Load_Instr (core_1, &addr_inst_1, 0x0240AA83);
			Load_Instr (core_1, &addr_inst_1, 0x0280AB03);
			Load_Instr (core_1, &addr_inst_1, 0x02C0AB83);
			Load_Instr (core_1, &addr_inst_1, 0x0300AC03);
			Load_Instr (core_1, &addr_inst_1, 0x0340AC83);
			Load_Instr (core_1, &addr_inst_1, 0x0380AD03);
			Load_Instr (core_1, &addr_inst_1, 0x03C0AD83);
			break;
		}
		case '3':{
			Load_Instr (core_0, &addr_inst_0, 0x03200093);
			Load_Instr (core_0, &addr_inst_0, 0x00000033);
			Load_Instr (core_0, &addr_inst_0, 0xFFF08093);
			Load_Instr (core_0, &addr_inst_0, 0xFE009CE3);
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x00800113);
			Load_Instr (core_0, &addr_inst_0, 0x01000193);
			Load_Instr (core_0, &addr_inst_0, 0x02310663);
			Load_Instr (core_0, &addr_inst_0, 0x2468A337);
			Load_Instr (core_0, &addr_inst_0, 0x0BD36313);
			Load_Instr (core_0, &addr_inst_0, 0x0062C2B3);
			Load_Instr (core_0, &addr_inst_0, 0xFF02F293);
			Load_Instr (core_0, &addr_inst_0, 0x0022E233);
			Load_Instr (core_0, &addr_inst_0, 0x00211293);
			Load_Instr (core_0, &addr_inst_0, 0x00508333);
			Load_Instr (core_0, &addr_inst_0, 0x00432023);
			Load_Instr (core_0, &addr_inst_0, 0x00110113);
			Load_Instr (core_0, &addr_inst_0, 0xFD9FF06F);
			Load_Instr (core_0, &addr_inst_0, 0x0000A503);
			Load_Instr (core_0, &addr_inst_0, 0x0040A583);
			Load_Instr (core_0, &addr_inst_0, 0x0080A603);
			Load_Instr (core_0, &addr_inst_0, 0x00C0A683);
			Load_Instr (core_0, &addr_inst_0, 0x0100A703);
			Load_Instr (core_0, &addr_inst_0, 0x0140A783);
			Load_Instr (core_0, &addr_inst_0, 0x0180A803);
			Load_Instr (core_0, &addr_inst_0, 0x01C0A883);
			Load_Instr (core_0, &addr_inst_0, 0x0200AA03);
			Load_Instr (core_0, &addr_inst_0, 0x0240AA83);
			Load_Instr (core_0, &addr_inst_0, 0x0280AB03);
			Load_Instr (core_0, &addr_inst_0, 0x02C0AB83);
			Load_Instr (core_0, &addr_inst_0, 0x0300AC03);
			Load_Instr (core_0, &addr_inst_0, 0x0340AC83);
			Load_Instr (core_0, &addr_inst_0, 0x0380AD03);
			Load_Instr (core_0, &addr_inst_0, 0x03C0AD83);
			
			Load_Instr (core_1, &addr_inst_1, 0x01000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x00000113);
			Load_Instr (core_1, &addr_inst_1, 0x00800193);
			Load_Instr (core_1, &addr_inst_1, 0x02310663);
			Load_Instr (core_1, &addr_inst_1, 0x11223337);
			Load_Instr (core_1, &addr_inst_1, 0x7C036313);
			Load_Instr (core_1, &addr_inst_1, 0x0062C2B3);
			Load_Instr (core_1, &addr_inst_1, 0xFF02F293);
			Load_Instr (core_1, &addr_inst_1, 0x0022E233);
			Load_Instr (core_1, &addr_inst_1, 0x00211293);
			Load_Instr (core_1, &addr_inst_1, 0x00508333);
			Load_Instr (core_1, &addr_inst_1, 0x00432023);
			Load_Instr (core_1, &addr_inst_1, 0x00110113);
			Load_Instr (core_1, &addr_inst_1, 0xFD9FF06F);
			Load_Instr (core_1, &addr_inst_1, 0x03200113);
			Load_Instr (core_1, &addr_inst_1, 0x00000033);
			Load_Instr (core_1, &addr_inst_1, 0xFFF10113);
			Load_Instr (core_1, &addr_inst_1, 0xFE011CE3);
			Load_Instr (core_1, &addr_inst_1, 0x0000A503);
			Load_Instr (core_1, &addr_inst_1, 0x0040A583);
			Load_Instr (core_1, &addr_inst_1, 0x0080A603);
			Load_Instr (core_1, &addr_inst_1, 0x00C0A683);
			Load_Instr (core_1, &addr_inst_1, 0x0100A703);
			Load_Instr (core_1, &addr_inst_1, 0x0140A783);
			Load_Instr (core_1, &addr_inst_1, 0x0180A803);
			Load_Instr (core_1, &addr_inst_1, 0x01C0A883);
			Load_Instr (core_1, &addr_inst_1, 0x0200AA03);
			Load_Instr (core_1, &addr_inst_1, 0x0240AA83);
			Load_Instr (core_1, &addr_inst_1, 0x0280AB03);
			Load_Instr (core_1, &addr_inst_1, 0x02C0AB83);
			Load_Instr (core_1, &addr_inst_1, 0x0300AC03);
			Load_Instr (core_1, &addr_inst_1, 0x0340AC83);
			Load_Instr (core_1, &addr_inst_1, 0x0380AD03);
			Load_Instr (core_1, &addr_inst_1, 0x03C0AD83);
			break;
		}
		case '4':{
			Load_Instr (core_0, &addr_inst_0, 0x03200093);
			Load_Instr (core_0, &addr_inst_0, 0x00000033);
			Load_Instr (core_0, &addr_inst_0, 0xFFF08093);
			Load_Instr (core_0, &addr_inst_0, 0xFE009CE3);
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A503);
			Load_Instr (core_0, &addr_inst_0, 0x0040A583);
			Load_Instr (core_0, &addr_inst_0, 0x0080A603);
			Load_Instr (core_0, &addr_inst_0, 0x00C0A683);
			Load_Instr (core_0, &addr_inst_0, 0x0100A703);
			Load_Instr (core_0, &addr_inst_0, 0x0140A783);
			Load_Instr (core_0, &addr_inst_0, 0x0180A803);
			Load_Instr (core_0, &addr_inst_0, 0x01C0A883);
			Load_Instr (core_0, &addr_inst_0, 0x00800113);
			Load_Instr (core_0, &addr_inst_0, 0x01000193);
			Load_Instr (core_0, &addr_inst_0, 0x02310663);
			Load_Instr (core_0, &addr_inst_0, 0x86420337);
			Load_Instr (core_0, &addr_inst_0, 0x2C036313);
			Load_Instr (core_0, &addr_inst_0, 0x0062C2B3);
			Load_Instr (core_0, &addr_inst_0, 0xFF02F293);
			Load_Instr (core_0, &addr_inst_0, 0x0022E233);
			Load_Instr (core_0, &addr_inst_0, 0x00211293);
			Load_Instr (core_0, &addr_inst_0, 0x00508333);
			Load_Instr (core_0, &addr_inst_0, 0x00432023);
			Load_Instr (core_0, &addr_inst_0, 0x00110113);
			Load_Instr (core_0, &addr_inst_0, 0xFD9FF06F);
			Load_Instr (core_0, &addr_inst_0, 0x0200AA03);
			Load_Instr (core_0, &addr_inst_0, 0x0240AA83);
			Load_Instr (core_0, &addr_inst_0, 0x0280AB03);
			Load_Instr (core_0, &addr_inst_0, 0x02C0AB83);
			Load_Instr (core_0, &addr_inst_0, 0x0300AC03);
			Load_Instr (core_0, &addr_inst_0, 0x0340AC83);
			Load_Instr (core_0, &addr_inst_0, 0x0380AD03);
			Load_Instr (core_0, &addr_inst_0, 0x03C0AD83);
			
			Load_Instr (core_1, &addr_inst_1, 0x01000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x00000113);
			Load_Instr (core_1, &addr_inst_1, 0x00800193);
			Load_Instr (core_1, &addr_inst_1, 0x02310663);
			Load_Instr (core_1, &addr_inst_1, 0x09753337);
			Load_Instr (core_1, &addr_inst_1, 0x0A036313);
			Load_Instr (core_1, &addr_inst_1, 0x0062C2B3);
			Load_Instr (core_1, &addr_inst_1, 0xFF02F293);
			Load_Instr (core_1, &addr_inst_1, 0x0022E233);
			Load_Instr (core_1, &addr_inst_1, 0x00211293);
			Load_Instr (core_1, &addr_inst_1, 0x00508333);
			Load_Instr (core_1, &addr_inst_1, 0x00432023);
			Load_Instr (core_1, &addr_inst_1, 0x00110113);
			Load_Instr (core_1, &addr_inst_1, 0xFD9FF06F);
			Load_Instr (core_1, &addr_inst_1, 0x0000A503);
			Load_Instr (core_1, &addr_inst_1, 0x0040A583);
			Load_Instr (core_1, &addr_inst_1, 0x0080A603);
			Load_Instr (core_1, &addr_inst_1, 0x00C0A683);
			Load_Instr (core_1, &addr_inst_1, 0x0100A703);
			Load_Instr (core_1, &addr_inst_1, 0x0140A783);
			Load_Instr (core_1, &addr_inst_1, 0x0180A803);
			Load_Instr (core_1, &addr_inst_1, 0x01C0A883);
			break;
		}
		case '5':{
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A303);
			Load_Instr (core_0, &addr_inst_0, 0x00009383);
			Load_Instr (core_0, &addr_inst_0, 0x0000D403);
			Load_Instr (core_0, &addr_inst_0, 0x00008483);
			Load_Instr (core_0, &addr_inst_0, 0x0000C503);
			Load_Instr (core_0, &addr_inst_0, 0x03200093);
			Load_Instr (core_0, &addr_inst_0, 0x00000033);
			Load_Instr (core_0, &addr_inst_0, 0xFFF08093);
			Load_Instr (core_0, &addr_inst_0, 0xFE009CE3);
			Load_Instr (core_0, &addr_inst_0, 0x01400093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A583);
			Load_Instr (core_0, &addr_inst_0, 0x00009603);
			Load_Instr (core_0, &addr_inst_0, 0x0000D683);
			Load_Instr (core_0, &addr_inst_0, 0x00008703);
			Load_Instr (core_0, &addr_inst_0, 0x0000C783);
			Load_Instr (core_0, &addr_inst_0, 0x01800093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x00B0A023);
			Load_Instr (core_0, &addr_inst_0, 0x00C09223);
			Load_Instr (core_0, &addr_inst_0, 0x00D08423);
			
			Load_Instr (core_1, &addr_inst_1, 0x01400093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x00000113);
			Load_Instr (core_1, &addr_inst_1, 0x00800193);
			Load_Instr (core_1, &addr_inst_1, 0x02310663);
			Load_Instr (core_1, &addr_inst_1, 0x01234337);
			Load_Instr (core_1, &addr_inst_1, 0x56736313);
			Load_Instr (core_1, &addr_inst_1, 0x0062C2B3);
			Load_Instr (core_1, &addr_inst_1, 0xFF02F293);
			Load_Instr (core_1, &addr_inst_1, 0x0022E233);
			Load_Instr (core_1, &addr_inst_1, 0x00211293);
			Load_Instr (core_1, &addr_inst_1, 0x00508333);
			Load_Instr (core_1, &addr_inst_1, 0x00432023);
			Load_Instr (core_1, &addr_inst_1, 0x00110113);
			Load_Instr (core_1, &addr_inst_1, 0xFD9FF06F);
			break;
		}
		case '6':{
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A303);
			Load_Instr (core_0, &addr_inst_0, 0x01400093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A383);
			Load_Instr (core_0, &addr_inst_0, 0x01800093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A383);
			Load_Instr (core_0, &addr_inst_0, 0x78900113);
			Load_Instr (core_0, &addr_inst_0, 0x0020A023);
			Load_Instr (core_0, &addr_inst_0, 0x0000A403);
			
			Load_Instr (core_1, &addr_inst_1, 0x09600093);
			Load_Instr (core_1, &addr_inst_1, 0x00000033);
			Load_Instr (core_1, &addr_inst_1, 0xFFF08093);
			Load_Instr (core_1, &addr_inst_1, 0xFE009CE3);
			Load_Instr (core_1, &addr_inst_1, 0x01000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x3FF00113);
			Load_Instr (core_1, &addr_inst_1, 0x0020A023);
			Load_Instr (core_1, &addr_inst_1, 0x01400093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x0000A303);
			break;
		}
		case '7':{
		    Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x7AC00113);
			Load_Instr (core_0, &addr_inst_0, 0x0020A023);
			Load_Instr (core_0, &addr_inst_0, 0x01400093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x45600113);
			Load_Instr (core_0, &addr_inst_0, 0x0020A023);
		    
			Load_Instr (core_1, &addr_inst_1, 0x06400093);
			Load_Instr (core_1, &addr_inst_1, 0x00000033);
			Load_Instr (core_1, &addr_inst_1, 0xFFF08093);
			Load_Instr (core_1, &addr_inst_1, 0xFE009CE3);
			Load_Instr (core_1, &addr_inst_1, 0x01000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x3FF00113);
			Load_Instr (core_1, &addr_inst_1, 0x0020A023);
			Load_Instr (core_1, &addr_inst_1, 0x01400093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x0000A383);
			break;
		}
		case '8':{
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x79C00113);
			Load_Instr (core_0, &addr_inst_0, 0x0020A023);
			Load_Instr (core_0, &addr_inst_0, 0x01400093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x17900113);
			Load_Instr (core_0, &addr_inst_0, 0x0020A023);
			Load_Instr (core_0, &addr_inst_0, 0x09600113);
			Load_Instr (core_0, &addr_inst_0, 0x00000033);
			Load_Instr (core_0, &addr_inst_0, 0xFFF10113);
			Load_Instr (core_0, &addr_inst_0, 0xFE011CE3);
			Load_Instr (core_0, &addr_inst_0, 0x24600113);
			Load_Instr (core_0, &addr_inst_0, 0x0020A023);
		    
			Load_Instr (core_1, &addr_inst_1, 0x06400093);
			Load_Instr (core_1, &addr_inst_1, 0x00000033);
			Load_Instr (core_1, &addr_inst_1, 0xFFF08093);
			Load_Instr (core_1, &addr_inst_1, 0xFE009CE3);
			Load_Instr (core_1, &addr_inst_1, 0x01000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x0000A383);
			Load_Instr (core_1, &addr_inst_1, 0x35700113);
			Load_Instr (core_1, &addr_inst_1, 0x0020A023);
			Load_Instr (core_1, &addr_inst_1, 0x01400093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x0000A403);
			break;
		}
		case '9':{
			Load_Instr (core_0, &addr_inst_0, 0x01000093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A303);
			Load_Instr (core_0, &addr_inst_0, 0x01400093);
			Load_Instr (core_0, &addr_inst_0, 0x00809093);
			Load_Instr (core_0, &addr_inst_0, 0x0000A383);
			Load_Instr (core_0, &addr_inst_0, 0x09600113);
			Load_Instr (core_0, &addr_inst_0, 0x00000033);
			Load_Instr (core_0, &addr_inst_0, 0xFFF10113);
			Load_Instr (core_0, &addr_inst_0, 0xFE011CE3);
			Load_Instr (core_0, &addr_inst_0, 0x3AE00113);
			Load_Instr (core_0, &addr_inst_0, 0x0020A023);
		    
			Load_Instr (core_1, &addr_inst_1, 0x06400093);
			Load_Instr (core_1, &addr_inst_1, 0x00000033);
			Load_Instr (core_1, &addr_inst_1, 0xFFF08093);
			Load_Instr (core_1, &addr_inst_1, 0xFE009CE3);
			Load_Instr (core_1, &addr_inst_1, 0x01000093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x0000A383);
			Load_Instr (core_1, &addr_inst_1, 0x76400113);
			Load_Instr (core_1, &addr_inst_1, 0x0020A023);
			Load_Instr (core_1, &addr_inst_1, 0x01400093);
			Load_Instr (core_1, &addr_inst_1, 0x00809093);
			Load_Instr (core_1, &addr_inst_1, 0x0000A403);
			break;
		}
		default: break;
	}
	printf("End initializing of Testcase_%c\n", tc_id);
}


int main()
{
    init_platform();

    print("Start program\n");

    unsigned char c;
	addr_inst_0 = 0;
	addr_inst_1 = 0;

	printf("Press r to RESET. \n");
	printf("Press a to DISPLAY REGFILE of CORE_0. \n");
	printf("Press b to DISPLAY REGFILE of CORE_0. \n");
	printf("Press c to DISPLAY STATE of D-Cache CORE_0. \n");
	printf("Press d to DISPLAY STATE of D-Cache CORE_1. \n");
	printf("Press 1 to CHECK TESTCASE 1: Test Read (hit/miss), Write (hit/miss), Write-back, PLRUt, Fetch MEM, Read-Write Allocate \n");
	printf("Press 2 to CHECK TESTCASE 2: Test Rd Request 	  - Rd Response \n");
	printf("Press 3 to CHECK TESTCASE 3: Test RdX Request 	  - RdX Response \n");
	printf("Press 4 to CHECK TESTCASE 4: Test Invalid Request - Invalid Response \n");
	printf("Press 5 to CHECK TESTCASE 5: Test state transition: I --> E, I --> S, I --> M \n");
	printf("Press 6 to CHECK TESTCASE 6: Test state transition: E --> I, E --> S, E --> M \n");
	printf("Press 7 to CHECK TESTCASE 7: Test state transition: M --> I, M --> O \n");
	printf("Press 8 to CHECK TESTCASE 8: Test state transition: O --> I, O --> M \n");
	printf("Press 9 to CHECK TESTCASE 9: Test state transition: S --> I, S --> M \n");
	printf("Press e to EXIT. \n");

	while (1) {
		printf("\nMake your select: ");
		c = XUartLite_RecvByte(XPAR_AXI_UARTLITE_0_BASEADDR);
		XUartLite_SendByte(XPAR_AXI_UARTLITE_0_BASEADDR, c);
		printf("\n");
		if (c == 'e') {
			printf("End program %c.\n");
			break;
		}
		switch(c){
			case 'r':{
				Reset_SoC ();
				printf("Done RESET.\n");
				break;
			}
			case 'a':{
				Display_RegFile (core_0);
				break;
			}
			case 'b':{
				Display_RegFile (core_1);
				break;
			}
			case 'c':{
				Display_Cache_State (core_0);
				break;
			}
			case 'd':{
				Display_Cache_State (core_1);
				break;
			}
			case '1':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '2':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '3':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '4':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '5':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '6':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '7':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '8':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			case '9':{
				printf("Start of Testcase %c.\n", c);
				Init_Testcase (c);
				printf("Running of Testcase %c.\n", c);
				Enable_SoC ((addr_inst_0 > addr_inst_1) ? addr_inst_0 : addr_inst_1);
				printf("End of Testcase %c.\n", c);
				break;
			}
			default: {
				printf("Unsupport selection.\n", c);
				break;
			}
		}
		// used to inorged redundant \r
		c = XUartLite_RecvByte(XPAR_AXI_UARTLITE_0_BASEADDR);
	}

    cleanup_platform();
    return 0;
}
