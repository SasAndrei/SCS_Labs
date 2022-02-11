library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM_Memory is
  Port ( 
         address: in std_logic_vector(8 downto 0);
         data_in: in std_logic_vector(63 downto 0);
         cs: in std_logic;
         wr: in std_logic;
         data_out: out std_logic_vector(63 downto 0)
  );
end RAM_Memory;

architecture Behavioral of RAM_Memory is

type memory_type is array (0 to 511) of std_logic_vector(63 downto 0);
signal memory : memory_type := (x"0000000000000000", x"1000000000000000", x"2000000000000000", x"3000000000000000", x"4000000000000000", x"5000000000000000", x"6000000000000000", x"7000000000000000", x"8000000000000000", others => (others => '0'));

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