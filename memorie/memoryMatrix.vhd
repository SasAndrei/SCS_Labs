library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memoryMatrix is
    Port ( a : in STD_LOGIC_VECTOR (16 downto 0);
           bheN : in STD_LOGIC;
           wrN: in std_logic;
           selN : in STD_LOGIC_VECTOR (7 downto 0);
           d : inout STD_LOGIC_VECTOR (15 downto 0));
end memoryMatrix;

architecture Behavioral of memoryMatrix is

component submodule is
    Port ( a : in STD_LOGIC_VECTOR (15 downto 0);
           wrN : in STD_LOGIC;
           seliN : in STD_LOGIC;
           a0 : in STD_LOGIC;
           bheN : in STD_LOGIC;
           d : inout STD_LOGIC_VECTOR (15 downto 0));
end component;

signal d0, d1, d2, d3, d4, d5, d6, d7: std_logic_vector(15 downto 0);

begin

sm0: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(0), bheN=>bheN, d=>d0, a0=>a(0));
sm1: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(1), bheN=>bheN, d=>d1, a0=>a(0));
sm2: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(2), bheN=>bheN, d=>d2, a0=>a(0));
sm3: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(3), bheN=>bheN, d=>d3, a0=>a(0));
sm4: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(4), bheN=>bheN, d=>d4, a0=>a(0));
sm5: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(5), bheN=>bheN, d=>d5, a0=>a(0));
sm6: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(6), bheN=>bheN, d=>d6, a0=>a(0));
sm7: submodule port map (a=>a(16 downto 1), wrN=>wrN, seliN=>selN(7), bheN=>bheN, d=>d7, a0=>a(0));

d<=d0 or d1 or d2 or d3 or d4 or d5 or d6 or d7;

end Behavioral;