----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2019 10:39:31 AM
-- Design Name: 
-- Module Name: phase_generator - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity phase_generator is
  Port (clk: in std_logic;
        rst: in std_logic;
        next_state : out STD_LOGIC_VECTOR (2 downto 0)
         );
end phase_generator;

architecture Behavioral of phase_generator is

signal count: std_logic_vector(2 downto 0);

-- 0 - IFF
-- 1 - ID
-- 2 - EX
-- 3 - MEM
-- 4 - WB

begin
    process (clk, rst)
    begin
       if rst = '1' then
           count <= "000";
       else
            if(clk'event and clk='1') then
                if(count = "100") then
                    count <= "000";
                else
                    count <= count + 1;
                end if;
            end if;
       end if;
       next_state <= count;
     end process;
end Behavioral;
