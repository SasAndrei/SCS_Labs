----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2021 07:15:02 PM
-- Design Name: 
-- Module Name: DEMUX - Behavioral
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

entity DEMUX is
    Port ( Data : in STD_LOGIC_VECTOR (7 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           Out0 : out STD_LOGIC_VECTOR (7 downto 0);
           Out1 : out STD_LOGIC_VECTOR (7 downto 0);
           Out2 : out STD_LOGIC_VECTOR (7 downto 0);
           Out3 : out STD_LOGIC_VECTOR (7 downto 0));
end DEMUX;

architecture Behavioral of DEMUX is

begin

process (sel)
begin

case sel is
    when "00" =>   Out0 <= Data;
    when "01" =>   Out1 <= Data;
    when "10" =>   Out2 <= Data;
    when "11" =>   Out3 <= Data;
    when others => Out3 <= Data;
end case;

end process;
end Behavioral;
