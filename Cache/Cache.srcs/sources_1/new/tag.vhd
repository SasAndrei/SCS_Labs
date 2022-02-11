----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2021 07:34:03 PM
-- Design Name: 
-- Module Name: tag - Behavioral
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

entity tag is
    port ( clk : in std_logic;
            we : in std_logic;
            en : in std_logic;
            addr : in std_logic_vector(7 downto 0);
            di : in std_logic_vector(9 downto 0);
            do : out std_logic_vector(9 downto 0));
end tag;

architecture Behavioral of tag is

begin


end Behavioral;
