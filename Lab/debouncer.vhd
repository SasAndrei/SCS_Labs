----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2021 01:13:41 PM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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

entity debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           res : in STD_LOGIC;
           debBtn : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

signal Q1, Q2, Q3 : std_logic;

begin

process(clk)
begin
   if (clk'event and clk = '1') then
      if (res = '1') then
         Q1 <= '0';
         Q2 <= '0';
         Q3 <= '0'; 
      else
         Q1 <= btn;
         Q2 <= Q1;
         Q3 <= Q2;
      end if;
   end if;
end process;
 
debBtn <= Q1 and Q2 and (not Q3);

end Behavioral;
