----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2021 06:27:07 PM
-- Design Name: 
-- Module Name: Dflip_flop - Behavioral
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

entity Dflip_flop is
    Port ( Input : in STD_LOGIC;
           clk : in STD_LOGIC;
           Output : out STD_LOGIC);
end Dflip_flop;

architecture Behavioral of Dflip_flop is

begin

process(clk)
begin

if (rising_edge(clk)) then
    Output <= Input;
end if;

end process;

end Behavioral;
