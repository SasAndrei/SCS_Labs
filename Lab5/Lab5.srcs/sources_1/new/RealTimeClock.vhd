----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/28/2021 06:26:49 PM
-- Design Name: 
-- Module Name: RealTimeClock - Behavioral
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

entity RealTimeClock is
    Port (clk: in STD_LOGIC;
            reset: in STD_LOGIC;
            hour: in STD_LOGIC;
            anode: out STD_LOGIC_VECTOR (3 downto 0);
            segments: out STD_LOGIC_VECTOR (7 downto 0));
end RealTimeClock;

architecture Behavioral of RealTimeClock is

begin


end Behavioral;
