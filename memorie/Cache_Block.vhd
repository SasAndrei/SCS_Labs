library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cache_Block is
  Port ( address: in std_logic_vector(31 downto 0);
         data_in: in std_logic_vector(63 downto 0);
         cs: in std_logic_vector(7 downto 0);
         fetch: in std_logic;
         write: in std_logic;
         hit: out std_logic;
         data_out: out std_logic_vector(7 downto 0)
  );
end Cache_Block;

architecture Behavioral of Cache_Block is

component Memory_Block is
  Port ( 
         address: in std_logic_vector(8 downto 0);
         data_in: in std_logic_vector(7 downto 0);
         cs: in std_logic;
         wr: in std_logic;
         data_out: out std_logic_vector(7 downto 0)
  );
end component;

component Tag_Block is
  Port ( 
         address: in std_logic_vector(8 downto 0);
         data_in: in std_logic_vector(19 downto 0);
         cs: in std_logic;
         wr: in std_logic;
         data_out: out std_logic_vector(19 downto 0)
  );
end component;

signal Tag_out: std_logic_vector(19 downto 0);
signal WR: std_logic := '0';

begin
comp: process(Tag_out, address)
      begin
          if Tag_out = address(31 downto 12) then 
              hit <= '1';
          else hit <= '0';
          end if;
end process;
WR <= fetch or write;

byte0: Memory_Block port map(address(11 downto 3), data_in(7 downto 0), cs(0), WR, data_out);
byte1: Memory_Block port map(address(11 downto 3), data_in(15 downto 8), cs(1), WR, data_out);
byte2: Memory_Block port map(address(11 downto 3), data_in(23 downto 16), cs(2), WR, data_out);
byte3: Memory_Block port map(address(11 downto 3), data_in(31 downto 24), cs(3), WR, data_out);
byte4: Memory_Block port map(address(11 downto 3), data_in(39 downto 32), cs(4), WR, data_out);
byte5: Memory_Block port map(address(11 downto 3), data_in(47 downto 40), cs(5), WR, data_out);
byte6: Memory_Block port map(address(11 downto 3), data_in(55 downto 48), cs(6), WR, data_out);
byte7: Memory_Block port map(address(11 downto 3), data_in(63 downto 56), cs(7), WR, data_out);
tag: Tag_Block port map(address(11 downto 3), address(31 downto 12), '1', fetch, Tag_out);

end Behavioral;