----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2019 09:43:45 PM
-- Design Name: 
-- Module Name: tempreg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY tempreg IS
PORT (
clk : IN STD_LOGIC;
rst_n : IN STD_LOGIC;
reg_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
reg_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END tempreg;

ARCHITECTURE behave OF tempreg IS
BEGIN
temp_reg: PROCESS(clk, rst_n, reg_in)
BEGIN
IF rst_n = '1' THEN
reg_out <= (OTHERS => '0');
ELSIF RISING_EDGE(clk) THEN
-- write register input to output at rising edge
reg_out <= reg_in;
END IF;
END PROCESS;
END behave;

