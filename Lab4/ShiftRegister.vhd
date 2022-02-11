----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2021 06:38:46 PM
-- Design Name: 
-- Module Name: ShiftRegister - Behavioral
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

entity ShiftRegister is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           shiftIn : in STD_LOGIC;
           shiftOut : out STD_LOGIC);
end ShiftRegister;

architecture Behavioral of ShiftRegister is

signal temp: std_logic_vector (7 downto 0);

begin

process (clk)
begin

if (rising_edge(clk)) then
    if (en = '1') then
        temp <= shiftIn & temp(7 downto 1);
    end if;
end if;

end process;

shiftOut <= temp(0);

end Behavioral;
