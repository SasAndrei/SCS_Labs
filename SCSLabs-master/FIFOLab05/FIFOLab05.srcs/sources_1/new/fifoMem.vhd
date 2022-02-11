----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2019 08:57:33 AM
-- Design Name: 
-- Module Name: fifoMem - Behavioral
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifoMem is
    Port ( rd : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           wr : in STD_LOGIC;
           wrinc : in STD_LOGIC;
           rdinc : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end fifoMem;

architecture Behavioral of fifoMem is

signal outCount: std_logic_vector(3 downto 0);
signal fifo: std_logic_vector(63 downto 0);
signal muxOut: std_logic_vector (7 downto 0);
signal debrdinc: std_logic;
signal debwrinc: std_logic;
signal inCount: std_logic_vector(3 downto 0);
signal dmuxOut: std_logic_vector(7 downto 0);
signal wrdeb: std_logic;
signal rddeb: std_logic;

component deb is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           res : in STD_LOGIC;
           debBtn : out STD_LOGIC);
end component;

begin

debOne: deb port map (btn => rdinc, clk => clk, res => rst, debBtn => debrdinc);
debTwo: deb port map (btn => wrinc, clk => clk, res => rst, debBtn => debwrinc);
debThree: deb port map (btn => wr, clk => clk, res => rst, debBtn => wrdeb);
debFour: deb port map (btn => rd, clk => clk, res => rst, debBtn => rddeb);

mux: process (outCount, fifo)
begin
    case outCount is
    when "000" => muxOut<=fifo(7 downto 0);
    when "001" => muxOut<=fifo(15 downto 7);
    when "010" => muxOut<=fifo(23 downto 16);
    when "011" => muxOut<=fifo(31 downto 24);
    when "100" => muxOut<=fifo(39 downto 32);
    when "101" => muxOut<=fifo(47 downto 40);
    when "110" => muxOut<=fifo(55 downto 48);
    when others => muxOut<=fifo(63 downto 56);
    end case;
end process mux;

muxSelCounter: process (clk)
begin
    if(rising_edge(clk)) then
        if rst = '1' then
            outCount <= 0;
        elsif debrdinc = '1' then
            outCount <= outCount + 1;
        end if;
    end if;
end process muxSelCounter;

dmuxCounter: process (clk)
begin
    if(rising_edge(clk)) then
        if rst = '1' then
            inCount <= 0;
        elsif debwrinc = '1' then
            inCount <= inCount + 1;
        end if;
    end if;
end process dmuxCounter;

dmux: process (inCount)
begin  
    case inCount is
    when "000" => dmuxOut(0) <= '0';
                  dmuxOut(1) <= '0';
                  dmuxOut(2) <= '0';
                  dmuxOut(3) <= '0';
                  dmuxOut(4) <= '0';
                  dmuxOut(5) <= '0';
                  dmuxOut(6) <= '0';
                  dmuxOut(7) <= '0';
    when "001" => dmuxOut(0) <= '0';
                dmuxOut(1) <= '1';
                dmuxOut(2) <= '0';
                dmuxOut(3) <= '0';
                dmuxOut(4) <= '0';
                dmuxOut(5) <= '0';
                dmuxOut(6) <= '0';
                dmuxOut(7) <= '0';
   when "010" => dmuxOut(0) <= '0';
              dmuxOut(1) <= '0';
              dmuxOut(2) <= '1';
              dmuxOut(3) <= '0';
              dmuxOut(4) <= '0';
              dmuxOut(5) <= '0';
              dmuxOut(6) <= '0';
              dmuxOut(7) <= '0';
  when "011" => dmuxOut(0) <= '0';
                    dmuxOut(1) <= '0';
                    dmuxOut(2) <= '0';
                    dmuxOut(3) <= '1';
                    dmuxOut(4) <= '0';
                    dmuxOut(5) <= '0';
                    dmuxOut(6) <= '0';
                    dmuxOut(7) <= '0';
   when "100" => dmuxOut(0) <= '0';
              dmuxOut(1) <= '0';
              dmuxOut(2) <= '0';
              dmuxOut(3) <= '0';
              dmuxOut(4) <= '1';
              dmuxOut(5) <= '0';
              dmuxOut(6) <= '0';
              dmuxOut(7) <= '0';
   when "101" => dmuxOut(0) <= '0';
                dmuxOut(1) <= '0';
                dmuxOut(2) <= '0';
                dmuxOut(3) <= '0';
                dmuxOut(4) <= '0';
                dmuxOut(5) <= '1';
                dmuxOut(6) <= '0';
                dmuxOut(7) <= '0';
when "110" => dmuxOut(0) <= '0';
                  dmuxOut(1) <= '0';
                  dmuxOut(2) <= '0';
                  dmuxOut(3) <= '0';
                  dmuxOut(4) <= '0';
                  dmuxOut(5) <= '0';
                  dmuxOut(6) <= '1';
                  dmuxOut(7) <= '0';
when others => dmuxOut(0) <= '0';
                dmuxOut(1) <= '0';
                dmuxOut(2) <= '0';
                dmuxOut(3) <= '0';
                dmuxOut(4) <= '0';
                dmuxOut(5) <= '0';
                dmuxOut(6) <= '0';
                dmuxOut(7) <= '1';
                end case;
end process dmux;

regSet: process(clk)
begin
    if rst = '1' then
    fifo <= 0;
    elsif rising_edge(clk) then
        if wrdeb = '1' then
            case dmuxOut is
            when "00000001" => fifo(7 downto 0) <= data_in (7 downto 0);
            when "00000010" => fifo(15 downto 8) <= data_in (7 downto 0);
            when "00000100" => fifo(23 downto 16) <= data_in (7 downto 0);
            when "00001000" => fifo(31 downto 24) <= data_in (7 downto 0);
            when "00010000" => fifo(39 downto 32) <= data_in (7 downto 0);
            when "00100000" => fifo(47 downto 40) <= data_in (7 downto 0);
            when "01000000" => fifo(55 downto 48) <= data_in (7 downto 0);
            when others => fifo(63 downto 56) <= data_in (7 downto 0);
            end case;
        end if;
        end if;
end process regSet;

buff: process(muxOut,rddeb)
begin
    if rddeb = '1' then
        data_out <= muxOut;
    else
        data_out <= "ZZZZZZZZ";
    end if;
end process buff;

end Behavioral;
