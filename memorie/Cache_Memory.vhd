library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cache_Memory is
Port(clk: in std_logic;
     address: in std_logic_vector(31 downto 0);
     data_in: in std_logic_vector(63 downto 0);
     read, write : in std_logic;
     hit_block_0, hit_block_1: out std_logic;
     data_out: out std_logic_vector(7 downto 0)
     );
end Cache_Memory;

architecture Behavioral of Cache_Memory is

component Cache_Block is
  Port ( address: in std_logic_vector(31 downto 0);
         data_in: in std_logic_vector(63 downto 0);
         cs: in std_logic_vector(7 downto 0);
         fetch: in std_logic;
         write: in std_logic;
         hit: out std_logic;
         data_out: out std_logic_vector(7 downto 0)
  );
end component;

component Memory_Block is
  Port ( index: in std_logic_vector(4 downto 0);
         din: in std_logic_vector(7 downto 0);
         cs: in std_logic;
         wr: in std_logic;
         dout: out std_logic_vector(7 downto 0)
        );
end component;

component RAM_Memory is
  Port ( 
         address: in std_logic_vector(8 downto 0);
         data_in: in std_logic_vector(63 downto 0);
         cs: in std_logic;
         wr: in std_logic;
         data_out: out std_logic_vector(63 downto 0)
  );
end component;

signal s_next: std_logic_vector(1 downto 0);
signal s_current: std_logic_vector(1 downto 0) := "00";

signal fetch_0, fetch_1: std_logic := '0';
signal data_out_0, data_out_1: std_logic_vector(7 downto 0);
signal hit_0, hit_1: std_logic;
signal choose: std_logic;
signal cs_0, cs_1: std_logic_vector(7 downto 0);
signal WR_0, WR_1: std_logic;
signal data_out_RAM: std_logic_vector(63 downto 0);
signal data_in_cache: std_logic_vector(63 downto 0);

begin

process(clk, s_current, hit_0, hit_1, read, write)
begin
    if rising_edge(clk) then 
        fetch_0 <= '0';
        fetch_1 <= '0';
        WR_0 <= '0';
        WR_1 <= '0';
        choose <= '0';
        case s_current is
            when "00" => 
                if hit_0 = '0' and hit_1 = '0' then 
                    s_next <= "11";
                elsif read = '1' then
                    s_next <= "01";
                elsif write = '1' then
                    s_next <= "10";
                end if;
                
                if hit_0 = '1' then 
                    WR_0 <= write;
                elsif hit_1 = '1' then
                    WR_1 <= write;
                end if;
                
            when "01" => s_next <= "00";
            when "10" => s_next <= "00";
            when "11" =>
                if choose = '0' then 
                    fetch_0 <= '1';
                    choose <= '1';
                else
                    fetch_1 <= '1';
                    choose <= '0';
                end if;
                
                if read = '1' then 
                    s_next <= "01"; 
                else s_next <= "10";
                end if;
            when others => s_next <= "00";
           end case; 
       end if;
end process;
s_current <= s_next; 
hit_block_0 <= hit_0;
hit_block_1 <= hit_1;

process(hit_0, hit_1, fetch_0, fetch_1, data_out_0, data_out_1)
begin
    if hit_0 = '1' then 
          data_out <= data_out_0;
    elsif hit_1 = '1' then 
          data_out <= data_out_1;
    else data_out <= "XXXXXXXX";
    end if;
end process;

block_0_sel: process(hit_0, fetch_0, address)
    begin
        if address(2 downto 0) = "000" then
            cs_0 <= (hit_0 or fetch_0) &"0000000";
        elsif address(2 downto 0) = "001" then
           cs_0 <= '0' & (hit_0 or fetch_0) & "000000";
        elsif address(2 downto 0) = "010" then 
           cs_0 <= "00" & (hit_0 or fetch_0) & "00000";
        elsif address(2 downto 0) = "011" then
           cs_0 <= "000" & (hit_0 or fetch_0) & "0000";
        elsif address(2 downto 0) = "100" then
            cs_0 <= "0000" & (hit_0 or fetch_0) & "000";
        elsif address(2 downto 0) = "101" then
           cs_0 <= "00000" & (hit_0 or fetch_0) & "00";
        elsif address(2 downto 0) = "110" then 
           cs_0 <= "000000" & (hit_0 or fetch_0) & "0";
        elsif address(2 downto 0) = "111" then
           cs_0 <= "0000000" & (hit_0 or fetch_0);
         else cs_0 <= "00000000";
        end if;
end process;

block_1_sel: process(hit_1, fetch_1, address)
    begin
        if address(2 downto 0) = "000" then
            cs_1 <= (hit_1 or fetch_1) &"0000000";
        elsif address(2 downto 0) = "001" then
           cs_1 <= '0' & (hit_1 or fetch_1) & "000000";
        elsif address(2 downto 0) = "010" then 
           cs_1 <= "00" & (hit_1 or fetch_1) & "00000";
        elsif address(2 downto 0) = "011" then
           cs_1 <= "000" & (hit_1 or fetch_1) & "0000";
        elsif address(2 downto 0) = "100" then
           cs_1 <= "0000" & (hit_1 or fetch_1) & "000";
        elsif address(2 downto 0) = "101" then
           cs_1 <= "00000" & (hit_1 or fetch_1) & "00";
        elsif address(2 downto 0) = "110" then 
           cs_1 <= "000000" & (hit_1 or fetch_1) & "0";
        elsif address(2 downto 0) = "111" then
           cs_1 <= "0000000" & (hit_1 or fetch_1);
         else cs_1 <= "00000000";
        end if;
end process;

write_data: process(write, data_in, data_out_RAM)
    begin
        if write = '1' then
            data_in_cache <= data_in;
        else
            data_in_cache <= data_out_RAM;
        end if;
end process;

Block0: Cache_Block port map(address, data_in_cache, cs_0, fetch_0, WR_0, hit_0, data_out_0);
Block1: Cache_Block port map(address, data_in_cache, cs_1, fetch_1, WR_1, hit_1, data_out_1);
Main: RAM_Memory port map(address(11 downto 3), data_in, '1', '0', data_out_RAM);

end Behavioral;