LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY regfile IS
PORT (clk,rst_n : IN std_logic;
wen : IN std_logic; -- write control

writeport : IN std_logic_vector(31 DOWNTO 0); -- register input
adrwport : IN std_logic_vector(4 DOWNTO 0);-- address write

adrport0 : IN std_logic_vector(4 DOWNTO 0);-- address port 0
adrport1 : IN std_logic_vector(4 DOWNTO 0);-- address port 1

readport0 : OUT std_logic_vector(31 DOWNTO 0); -- output port 0
readport1 : OUT std_logic_vector(31 DOWNTO 0) -- output port 1
);
END regfile;
ARCHITECTURE behave OF regfile IS
SUBTYPE WordT IS std_logic_vector(31 DOWNTO 0); -- reg word TYPE

TYPE StorageT IS ARRAY(0 TO 31) OF WordT; -- reg array TYPE
SIGNAL registerfile : StorageT:=(
0=>x"00000000",
1=>x"00000010",
2=>x"00000011",
3=>x"00000505",
4=>x"00000404",
5=>x"00000505",
6=>x"00000606",
7=>x"00000707",
others => x"00000000"
);
BEGIN
-- perform write operation
PROCESS(rst_n, clk, wen, writeport, adrwport, adrport0, adrport1)
BEGIN
   IF rst_n = '1' THEN
        FOR i IN 0 TO 31 LOOP
           registerfile(i) <= (OTHERS => '0');
        END LOOP;
        ELSIF rising_edge(clk) THEN
          IF wen = '1' THEN
              registerfile(to_integer(unsigned(adrwport))) <= writeport;
          END IF;
     END IF;
END PROCESS;
-- perform reading ports
         readport0 <= registerfile(to_integer(unsigned(adrport0)));
         readport1 <= registerfile(to_integer(unsigned(adrport1)));
END behave;