----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2021 04:56:00 PM
-- Design Name: 
-- Module Name: lookAheadAdderTB - Behavioral
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

entity lookAheadAdderTB is
--  Port ( );
end lookAheadAdderTB;

architecture Behavioral of lookAheadAdderTB is

component  LookAheadAdder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR (3 downto 0));
end component ;

signal carry : std_logic;
signal Sum : std_logic_vector(3 downto 0) := X"0";

begin

LAA: lookAheadAdder PORT MAP(
        A => "0101",
        B => "1101",
        Cin => '0',
        Cout => carry,
        Sum => Sum);

end Behavioral;
