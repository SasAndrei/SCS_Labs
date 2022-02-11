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
    Port ( a : in STD_LOGIC_VECTOR (23 downto 0);
           d : inout STD_LOGIC_VECTOR (15 downto 0);
           mrdN : in STD_LOGIC;
           mwrN : in STD_LOGIC;
           bheN : in STD_LOGIC);
end main;

architecture Behavioral of main is

component memoryMatrix is
    Port ( a : in STD_LOGIC_VECTOR (16 downto 0);
           bheN : in STD_LOGIC;
           wrN: in std_logic;
           selN : in STD_LOGIC_VECTOR (7 downto 0);
           d : inout STD_LOGIC_VECTOR (15 downto 0));
end component;

component decoder is
    Port ( a : in STD_LOGIC_VECTOR (23 downto 17);
           rdN : in STD_LOGIC;
           wrN : in STD_LOGIC;
           selN : out STD_LOGIC_VECTOR (7 downto 0);
           selModN : out STD_LOGIC);
end component;

signal selN: std_logic_vector (7 downto 0);
signal selModN: std_logic;

begin

mm: memoryMatrix port map(a=>a(16 downto 0), d=>d, selN => selN, bheN=>bheN, wrN => selModN);
dcd: decoder port map(a=>a(23 downto 17), rdN=>mrdN, wrN=>mwrN, selN=>selN, selModN=>selModN);

end Behavioral;