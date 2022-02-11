library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity displ_7seg is
	port ( clk, rd, wr, rst : in std_logic;
	       wrinc : in STD_LOGIC;
           rinc : in STD_LOGIC;
		    data : in std_logic_vector (15 downto 0);
		    sseg : out std_logic_vector (6 downto 0);
		    an : out std_logic_vector (3 downto 0));
end displ_7seg;

architecture Behavioral of displ_7seg is
	component hex2sseg is
    	port ( hex : in std_logic_vector (3 downto 0);
           	 sseg : out std_logic_vector (6 downto 0));
	end component hex2sseg;
	
	component Fifo is
    Port ( rd : in STD_LOGIC;
           wr : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           wrinc : in STD_LOGIC;
           rinc : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
    end component Fifo;
	
	signal ledsel : std_logic_vector (1 downto 0);
	signal cntdiv : std_logic_vector (10 downto 0);
	signal segdata : std_logic_vector (3 downto 0);
	
begin
	process (clk, rst)
	begin
		if rst = '1' then
			cntdiv <= (others => '0');
		elsif (clk'event and clk = '1') then
			cntdiv <= cntdiv + 1;
		end if;
	end process;
	
	
	
	
	ledsel <= cntdiv(10 downto 9);
	
	an <= "1110" when ledsel = "00" else
		   "1101" when ledsel = "01" else
		   "1011" when ledsel = "10" else
		   "0111" when ledsel = "11";
			
	segdata <= data (3 downto 0)   when ledsel = "00" else
		        data (7 downto 4)   when ledsel = "01" else
		        data (11 downto 8)  when ledsel = "10" else
		        data (15 downto 12) when ledsel = "11";
				
	fifo_u: Fifo 
	   port map (clk => clk, data_in => data, rst => rst, data_out => data, wr => wr, rd => rd,  wrinc => wrinc, rinc => rinc);
	
	hex2sseg_u: hex2sseg
		port map (hex => segdata, sseg => sseg);
		
end Behavioral;
