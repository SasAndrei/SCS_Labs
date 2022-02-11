----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 07:08:28 PM
-- Design Name: 
-- Module Name: LookAheadAdder - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LookAheadAdder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR (3 downto 0));
end LookAheadAdder;

architecture Behavioral of LookAheadAdder is

signal g: std_logic_vector(3 downto 0);
signal p: std_logic_vector(3 downto 0);
signal carry: std_logic_vector(4 downto 0);

begin

g <= A AND B;
p <= A OR B;

carry(0) <= Cin;
carry(1) <= g(0) OR (p(0) AND Cin);
carry(2) <= g(1) OR (p(1) AND (g(0) OR (p(0) AND Cin)));
carry(3) <= g(2) OR (p(2) AND (g(1) OR (p(1) AND (g(0) OR (p(0) AND Cin)))));
carry(4) <= g(3) OR (p(3) AND (g(0) OR (p(0) AND (g(1) OR (p(1) AND (g(0) OR (p(0) AND Cin)))))));

Sum <= (A AND B) OR ((A OR B) AND carry(3 downto 0));
Cout <= carry(4);


end Behavioral;
