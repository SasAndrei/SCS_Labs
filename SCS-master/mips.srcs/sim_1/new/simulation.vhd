----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2019 09:04:42 AM
-- Design Name: 
-- Module Name: simulation - Behavioral
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

entity simulation is
--  Port ( );
end simulation;

architecture Behavioral of simulation is
component main is
      Port (clk, rst: in std_logic;
             alu_result1: out std_logic_vector(31 downto 0));
end component;

signal clk, rst: std_logic;
signal alu_result: std_logic_vector(31 downto 0);

begin

    mips: main port map(clk=>clk, rst=>rst, alu_result1=>alu_result);

    process
    begin
        rst <= '0';
        wait for 100ns;
        
        rst <= '1';
        wait for 100ns;
    end process;
end Behavioral;
