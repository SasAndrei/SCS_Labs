----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 07:04:35 PM
-- Design Name: 
-- Module Name: Counter4bits - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter4bits is
    Port ( clk: in STD_LOGIC;
           Output: out STD_LOGIC_VECTOR (3 downto 0));
end Counter4bits;

architecture Behavioral of Counter4bits is

signal temp: std_logic_vector (4 downto 0);

begin

process (clk)
begin
if (rising_edge(clk)) then
    temp <= temp + 1;
end if;
end process;

Output <= temp;

end Behavioral;
