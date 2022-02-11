----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2021 04:51:32 PM
-- Design Name: 
-- Module Name: CounterTB - Behavioral
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

entity CounterTB is
--  Port ( );
end CounterTB;

architecture Behavioral of CounterTB is

constant T : time := 20 ns;

component  Counter4bits is
    Port ( clk: in STD_LOGIC;
           Output: out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal clk : std_logic;
signal c : std_logic_vector(3 downto 0) := X"0";

begin

count: Counter4bits PORT MAP (clk => clk , Output => c);

clock: process
begin
    clk <= '0';
    wait for T/2;
    clk <= '1';
    wait for T/2;
end process;


end Behavioral;
