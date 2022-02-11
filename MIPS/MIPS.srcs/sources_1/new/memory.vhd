----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2021 06:48:00 PM
-- Design Name: 
-- Module Name: memory - Behavioral
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
USE work.procmem_definitions.ALL;
entity memory is
PORT (
clk : IN STD_ULOGIC;
rst_n : IN STD_ULOGIC;

MemRead : IN STD_ULOGIC;
MemWrite : IN STD_ULOGIC;

mem_address : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
data_in : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);

data_out : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0) );

end memory;

architecture Behavioral of memory is

SUBTYPE WordT IS std_logic_vector(width-1 DOWNTO 0); 
type RAM is array (0 to width-1) of WordT;
signal mem : RAM:=(

B"000000_00001_00010_00011_00000_100000",
B"101011_00001_00011_0000000000000001",
B"100011_00001_00011_0000000000000001",

others=>x"00000000");
begin

process(rst_n, MemWrite, MemRead, mem_address, data_in)
begin
        if MemWrite = '1' then
             mem(conv_integer(mem_address)) <= data_in;
        else
          if(MemRead = '1') then
            data_out <=  mem(conv_integer(mem_address));
           end if;
 end if;
end process;

end Behavioral;