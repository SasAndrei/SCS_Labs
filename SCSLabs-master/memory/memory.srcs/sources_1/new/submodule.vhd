----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2019 08:02:30 AM
-- Design Name: 
-- Module Name: submodule - Behavioral
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
use IEEE.Numeric_Std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity submodule is
    Port ( a : in STD_LOGIC_VECTOR (15 downto 0);
           wrN : in STD_LOGIC;
           seliN : in STD_LOGIC;
           a0 : in STD_LOGIC;
           bheN : in STD_LOGIC;
           d : inout STD_LOGIC_VECTOR (15 downto 0));
end submodule;

architecture Behavioral of submodule is

type ram_type is array (0 to (2**16)-1) of std_logic_vector(7 downto 0);
signal ram1, ram2: ram_type;
signal seliLN, seliHN: std_logic;

begin

seliLN <= seliN or a0;
seliHN <= seliN or bheN;

pram1: process (a, seliLN, wrN, d)
begin
    if seliLN = '0' then
        if wrN = '0' then
            ram1(to_integer(unsigned(a)))<=d(7 downto 0);
        else
            d(7 downto 0)<=ram1(to_integer(unsigned(a)));
        end if;
    else
        d(7 downto 0)<="00000000";
    end if;
end process pram1;

pram2: process (a, seliHN, wrN, d)
begin
    if seliHN = '0' then
        if wrN = '0' then
            ram2(to_integer(unsigned(a)))<=d(15 downto 8);
        else
            d(15 downto 8)<=ram2(to_integer(unsigned(a)));
        end if;
    else
        d(15 downto 8)<="00000000";
    end if;
end process pram2;

end Behavioral;
