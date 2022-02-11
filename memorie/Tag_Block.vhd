library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Tag_Block is
  Port ( 
         address: in std_logic_vector(8 downto 0);
         data_in: in std_logic_vector(19 downto 0);
         cs: in std_logic;
         wr: in std_logic;
         data_out: out std_logic_vector(19 downto 0)
  );
end Tag_Block;

architecture Behavioral of Tag_Block is

type memory_type is array (0 to 511) of std_logic_vector(19 downto 0);
signal memory : memory_type := (x"00000",x"00001",x"00002",x"00003",x"00004",x"00005",x"00006",x"00007",x"00008",x"00009",x"0000A",others => (others => '0'));

begin

process(address, data_in, cs, wr)
begin

    if cs = '1' then 
        data_out <= memory(conv_integer(address)); 
    else data_out <= (others => 'Z');
    end if; 
    if wr = '1' then
        memory(conv_integer(address)) <= data_in;
    end if;
       
end process;

end Behavioral;