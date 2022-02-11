----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 07:24:29 PM
-- Design Name: 
-- Module Name: CarrySaveAdder - Behavioral
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

entity CarrySaveAdder is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           c : in STD_LOGIC_VECTOR (3 downto 0);
           s : out STD_LOGIC_VECTOR (4 downto 0);
           cout : out STD_LOGIC);
end CarrySaveAdder;

architecture Behavioral of CarrySaveAdder is

signal x: std_logic_vector(3 downto 0);
signal y: std_logic_vector(2 downto 0);
signal c1, c2, c3: std_logic;

component fullAdder is
    Port ( x : in STD_LOGIC;
           y : in STD_LOGIC;
           cin : in STD_LOGIC;
           s : out STD_LOGIC;
           cout : out STD_LOGIC);
end component;

begin

fa0: fullAdder port map (a(0),b(0),c(0),s(0),x(0));
fa1: fullAdder port map (a(1),b(1),c(1),y(0),x(1));
fa2: fullAdder port map (a(2),b(2),c(2),y(1),x(2));
fa3: fullAdder port map (a(3),b(3),c(3),y(2),x(3));

fa4: fullAdder port map (x(0),y(0),'0',s(1),c1);
fa5: fullAdder port map (x(1),y(1),c1,s(2),c2);
fa6: fullAdder port map (x(2),y(2),c2,s(3),c3);
fa7: fullAdder port map (x(3),'0',c3,s(4),cout);

end Behavioral;
