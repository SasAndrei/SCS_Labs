library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
    Port ( a : in STD_LOGIC_VECTOR (23 downto 17);
           rdN : in STD_LOGIC;
           wrN : in STD_LOGIC;
           selN : out STD_LOGIC_VECTOR (7 downto 0);
           selModN : out STD_LOGIC);
end decoder;

architecture Behavioral of decoder is

signal cmd, start: std_logic;

begin

cmd <= rdN and wrN;
start<= not ((not a(20)) and (not a(21)) and a(22) and a(23));
selModN <= start or cmd;

process (cmd, start, a(19 downto 17))
begin
    if cmd='0' and start='0' then
    case a(19 downto 17) is
    when "000"=>selN<="00000001";
    when "001"=>selN<="00000010";
    when "010"=>selN<="00000100";
    when "011"=>selN<="00001000";
    when "100"=>selN<="00010000";
    when "101"=>selN<="00100000";
    when "110"=>selN<="01000000";
    when others=>selN<="10000000";
    end case;
    else
        selN<="00000000";
    end if;
end process;


end Behavioral;