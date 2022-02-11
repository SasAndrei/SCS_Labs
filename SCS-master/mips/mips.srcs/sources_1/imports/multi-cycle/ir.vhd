LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ir IS
PORT (
clk : IN STD_LOGIC;
rst_n : IN STD_LOGIC;

memdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- instuction content

IRWrite : IN STD_LOGIC;

instr_31_26 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
instr_25_21 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
instr_20_16 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
instr_15_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
END ir;

ARCHITECTURE behave OF ir IS
BEGIN
proc_instreg : PROCESS(clk, rst_n, memdata, IRWrite)
BEGIN
    IF rst_n = '1' THEN
        instr_31_26 <= (OTHERS => '0');
        instr_25_21 <= (OTHERS => '0');
        instr_20_16 <= (OTHERS => '0');
        instr_15_0 <= (OTHERS => '0');
    ELSIF RISING_EDGE(clk) THEN
-- write the output of the memory into the instruction register
     IF(IRWrite = '1') THEN
        instr_31_26 <= memdata(31 DOWNTO 26);
        instr_25_21 <= memdata(25 DOWNTO 21);
        instr_20_16 <= memdata(20 DOWNTO 16);
        instr_15_0 <= memdata(15 DOWNTO 0);
     END IF;
    END IF;
END PROCESS;
END behave;
