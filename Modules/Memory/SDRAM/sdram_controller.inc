-- WARNING: Do NOT edit the input and output ports in this file in a text
-- editor if you plan to continue editing the block that represents it in
-- the Block Editor! File corruption is VERY likely to occur.

-- Copyright (C) 2024  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.


-- Generated by Quartus Prime Version 23.1 (Build Build 993 05/14/2024)
-- Created on Mon Oct 28 10:27:31 2024

FUNCTION sdram_controller (clk, reset, write_enable, address[23..0], data_in[15..0])
	WITH (STATE_INIT, STATE_IDLE, STATE_ACTIVE, STATE_READ, STATE_WRITE, STATE_PRECHARGE)
	RETURNS (data_out[15..0], DRAM_ADDR[12..0], DRAM_BA[1..0], DRAM_DQ[15..0], DRAM_CS_N, DRAM_RAS_N, DRAM_CAS_N, DRAM_WE_N, DRAM_CKE, DRAM_CLK, DRAM_LDQM, DRAM_UDQM);