library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  hour	: in std_logic;
           anode : out std_logic_vector(3 downto 0);
			  segments : out std_logic_vector (7 downto 0)
           );
end counter;

architecture counter of counter is

signal 	clk1 : std_logic :='0';
signal 	count : integer :=1;
signal 	div    :  std_logic_vector(22 downto 0);
signal 	WhichDisplay	:	std_logic_vector(1 downto 0);
signal 	digit1: INTEGER := 0;
signal 	digit2: INTEGER := 0;
signal 	digit3: INTEGER := 0;
signal 	digit4: INTEGER := 0;
signal 	digit5: INTEGER := 0;
signal 	digit6: INTEGER := 0;

type display_ROM is array (0 to 15) of std_logic_vector (7 downto 0);
constant convert_to_segments : display_ROM :=
		("00000011","10011111","00100101","00001101","10011001","01001001","01000001","00011111",
		 "00000001","00001001","00010000","00000000","01100010","00000010","01100000","01110000"); --0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F


begin

PROCESS(clk1, reset)
 
 BEGIN
 ---- counter: ----------------------
 IF (reset='1') THEN
 digit1 <= 0;
 digit2 <= 0;
 digit3 <= 0;
 digit4 <= 0;
 digit5 <= 0;
 digit6 <= 0;
 
 ELSIF rising_edge(clk1) THEN
 digit1 <= digit1 + 1;
 IF (digit1=9) THEN
 digit1 <= 0;
 digit2 <= digit2 + 1;
 IF (digit2=5) THEN
 digit2 <= 0;
 digit3 <= digit3 + 1;
 IF (digit3=9) THEN
 digit3 <= 0;
 digit4 <= digit4 + 1;
 IF (digit4=5) THEN
 digit4 <= 0;

 digit5 <= digit5 + 1;
 IF (digit5=9) THEN
 digit5 <=0;
  
 digit6 <= digit6 + 1;
 if (digit6=3) then 

 digit1 <= 0;
 digit2 <= 0;
 digit3 <= 0;
 digit4 <= 0;
 digit5 <= 0;
 digit6 <= 0;
END IF; END IF; END IF; END IF; END IF; END IF; END IF;
 
END PROCESS;
 
 
div<= div + 1 when rising_edge(clk);
WhichDisplay <= div(16 downto 15);

process(clk)
begin

		if rising_edge(clk) then
		count <=count+1;
		if(count = 50000000) then
			clk1 <= not clk1;
			count <=1;
		end if;
		end if;
	
		if rising_edge(clk) then
		
		if WhichDisplay ="11" then
			segments <= convert_to_segments(digit4 ); -- 0
			anode<="0111";
		elsif WhichDisplay ="10" then
			segments <= convert_to_segments(digit3); -- 1
			anode<="1011";
		elsif WhichDisplay ="01" then
			segments <= convert_to_segments(digit2); -- 2
			anode<="1101";
			
		else
			segments <= convert_to_segments(digit1); -- 3
			anode<="1110";
		end if;
		
		if hour='1' then
		if WhichDisplay ="11" then
			segments <= convert_to_segments(digit6); -- 0
			anode<="0111";
		elsif WhichDisplay ="10" then
			segments <= convert_to_segments(digit5); -- 1
			anode<="1011";
		elsif WhichDisplay ="01" then
			segments <= convert_to_segments(digit4); -- 2
			anode<="1101";
			
		else
			segments <= convert_to_segments(digit3); -- 3
			anode<="1110";
	
		end if;
		end if;
		
	else null;
	end if;
	
end process;
end counter;