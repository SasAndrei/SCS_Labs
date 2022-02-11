----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2021 04:30:49 PM
-- Design Name: 
-- Module Name: wallaceTree - Behavioral
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

entity wallaceTree is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           prod : out STD_LOGIC_VECTOR (7 downto 0));
end wallaceTree;

architecture Behavioral of wallaceTree is

component fullAdder is
    Port ( x : in STD_LOGIC;
           y : in STD_LOGIC;
           cin : in STD_LOGIC;
           s : out STD_LOGIC;
           cout : out STD_LOGIC);
end component;

signal pp0, pp1, pp2, pp3: std_logic_vector (3 downto 0);
signal step1, step1carry: std_logic_vector (4 downto 0);
signal step2, step2carry: std_logic_vector (4 downto 0);
signal step3carry: std_logic_vector (4 downto 0); 

begin

process (a, b)
begin
    for i in 0 to 3 loop
    pp0(i) <= a(0) and b(i);
    pp1(i) <= a(1) and b(i);
    pp2(i) <= a(2) and b(i);
    pp3(i) <= a(3) and b(i);
    end loop;
end process;

prod(0)<=pp0(0);

--first step
add00: fullAdder port map (pp0(1),pp1(0),'0',prod(1),step1carry(0));
add01: fullAdder port map (pp0(2),pp1(1),pp2(0),step1(0),step1carry(1)); 
add02: fullAdder port map (pp1(2),pp2(1),pp3(0),step1(1),step1carry(2)); 
add03: fullAdder port map (pp1(3),pp2(2),pp3(1),step1(2),step1carry(3)); 
add04: fullAdder port map (pp2(3),pp3(2),'0',step1(3),step1carry(4)); 

--second
add10: fullAdder port map (step1carry(0),step1(0),'0',prod(2),step2carry(0));
add11: fullAdder port map (pp0(3),step1carry(1),step1(1),step2(0),step2carry(1)); 
add12: fullAdder port map ('0',step1carry(2),step1(2),step2(1),step2carry(2)); 
add13: fullAdder port map ('0',step1carry(3),step1(3),step2(2),step2carry(3)); 
add14: fullAdder port map (pp3(3),step1carry(3),'0',step2(3),step2carry(4));

--third
add20: fullAdder port map (step2carry(0),step2(0),'0',prod(3),step3carry(0));
add21: fullAdder port map (step2carry(1),step2(1),step3carry(0),prod(4),step3carry(1)); 
add22: fullAdder port map (step2carry(2),step2(2),step3carry(1),prod(5),step3carry(2)); 
add23: fullAdder port map (step2carry(3),step2(3),step3carry(2),prod(6),step3carry(3)); 
add24: fullAdder port map (step2carry(4),'0',step3carry(3),prod(7),step3carry(4));

end Behavioral;