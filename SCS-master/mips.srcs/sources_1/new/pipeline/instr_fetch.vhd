----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2019 02:43:28 PM
-- Design Name: 
-- Module Name: instr_fetch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_fetch is
   Port (clk: in std_logic;
         reset: in std_logic;
         pcWrite: in std_logic;
         instruction: out std_logic_vector(31 downto 0);
         next_address: out std_logic_vector(31 downto 0));
end instr_fetch;

architecture Behavioral of instr_fetch is

type ROM1 is array(0 to 31) of std_logic_vector(31 downto 0);
signal instructions:ROM1:=(

B"000000_00001_00010_00011_00000_100000", -- $3 <- $1 + $2
B"101011_00001_00011_0000000000000001",
B"100011_00001_00100_0000000000000001",
others=>x"00000000"
);

signal pc, na: std_logic_vector(31 downto 0);

begin 

  process(clk, reset, pcWrite)
     begin
          
     if(reset='1') then
        pc <= x"00000000";
        na <= x"00000000";
     else
        pc <= na;
        if(clk'event and clk='1') then
            if(pcWrite = '1') then
                na <= pc + 1;
            end if;
        end if;
     end if;
     end process; 
       
    instruction <= instructions(conv_integer(pc));
    next_address <= na;  

end Behavioral;
