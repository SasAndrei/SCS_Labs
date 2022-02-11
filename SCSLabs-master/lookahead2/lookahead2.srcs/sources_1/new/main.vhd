----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2019 08:01:55 AM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
  Port (a :in std_logic_vector(3 downto 0);
        b :in std_logic_vector(3 downto 0);
        --
        r :out std_logic_vector(7 downto 0)
        );
end main;

architecture Behavioral of main is

component FullAdder is
  port (
  a : in std_logic; 
  b : in std_logic;
  cin : in std_logic;
  --
  s : out std_logic;
  cout : out std_logic
  );
end component;

signal p0 : std_logic_vector(3 downto 0);
signal p1 : std_logic_vector(3 downto 0);
signal p2 : std_logic_vector(3 downto 0);
signal p3 : std_logic_vector(3 downto 0);

signal z : std_logic;
signal si : std_logic_vector(12 downto 0);
signal ss : std_logic_vector(4 downto 0);
begin

z <= '0';
p0(0) <= a(0) and b(0);
p0(1) <= a(1) and b(0);
p0(2) <= a(2) and b(0);
p0(3) <= a(3) and b(0);

p1(0) <= a(0) and b(1);
p1(1) <= a(1) and b(1);
p1(2) <= a(2) and b(1);
p1(3) <= a(3) and b(1);

p2(0) <= a(0) and b(2);
p2(1) <= a(1) and b(2);
p2(2) <= a(2) and b(2);
p2(3) <= a(3) and b(2);

p3(0) <= a(0) and b(3);
p3(1) <= a(1) and b(3);
p3(2) <= a(2) and b(3);
p3(3) <= a(3) and b(3);

    f1: FullAdder port map (p2(2),p3(1),z,si(1),si(0));
    f2: FullAdder port map (p3(0),p2(1),z,si(3),si(2));
    f3: FullAdder port map (p2(3),p3(2),si(0),si(5),si(4));
    f4: FullAdder port map (p1(3),si(1),si(2),si(7),si(6));
    f5: FullAdder port map (p0(3),p1(2),si(3),si(9),si(8));
    f6: FullAdder port map (p1(1),p2(0),z,si(11),si(10));
    f7: FullAdder port map (p3(3),si(4),ss(0),r(6),r(7));
    f8: FullAdder port map (si(5),si(6),ss(1),r(5),ss(0));
    f9: FullAdder port map (si(7),si(8),ss(2),r(4),ss(1));
    f10: FullAdder port map (si(9),si(10),ss(3),r(3),ss(2));
    f11: FullAdder port map (si(11),p0(2),ss(4),r(2),ss(3));
    f12: FullAdder port map (p1(0),p0(1),z,r(1),ss(4));

r(0) <= p0(0);
end Behavioral;
