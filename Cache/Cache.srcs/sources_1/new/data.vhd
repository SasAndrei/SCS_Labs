----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2021 07:34:21 PM
-- Design Name: 
-- Module Name: data - Behavioral
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
USE ieee.std_logic_arith.all;
USE IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data is
    port ( clk : in std_logic;
            we : in std_logic;
            en : in std_logic;
            addr : in std_logic_vector(7 downto 0);
            di : in std_logic_vector(9 downto 0);
            do : out std_logic_vector(9 downto 0));
end data;

architecture Behavioral of data is

type ram_type is array (0 to 255) of std_logic_vector (9 downto 0);
signal mem: ram_type;

begin

    process (clk)
    begin
    if rising_edge (clk) then
        if en = '1' then
            if we = '1' then
                mem(conv_integer(addr)) <= di;
            else
                do <= mem(conv_integer(addr));
            end if;
        end if;
    end if;
    end process;

end Behavioral;
