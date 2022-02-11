library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory_Block is
  Port ( 
         address: in std_logic_vector(8 downto 0);
         data_in: in std_logic_vector(7 downto 0);
         cs: in std_logic;
         wr: in std_logic;
         data_out: out std_logic_vector(7 downto 0)
  );
end Memory_Block;

architecture Behavioral of Memory_Block is

type memory_type is array (0 to 511) of std_logic_vector(7 downto 0);
signal memory : memory_type := (x"00", x"11", x"22", x"33", x"44", x"55", x"66", x"77", x"88", x"99",others => (others => '0'));

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