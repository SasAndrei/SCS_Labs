----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2019 06:34:32 PM
-- Design Name: 
-- Module Name: execute_unit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execute_unit is
  Port ( a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        instr_15_11, instr_20_16: IN STD_LOGIC_VECTOR(4 downto 0);
        ext: IN STD_LOGIC_VECTOR(31 downto 0);
        aluSrc, regDst: IN STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_address: OUT STD_LOGIC_VECTOR(4 downto 0);
        zero : OUT STD_LOGIC );
end execute_unit;

architecture Behavioral of execute_unit is
component alu IS
PORT (
        a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zero : OUT STD_LOGIC);
END component;

signal op2: STD_LOGIC_VECTOR(31 downto 0);
begin

    alun: alu port map(a=>a, b=>op2, opcode=>aluOp, result=>result, zero=>zero);

    muxForRegDst: process(regDst, instr_15_11, instr_20_16)
    begin
        if(regDst = '0') then
            write_address <= instr_20_16; --rt
        else
            write_address <= instr_15_11; -- rd
        end if;
    end process;
    
    muxForAluSrc: process(aluSrc, b, ext)
    begin
        if(aluSrc = '0') then
            op2 <= b;
        else
            op2 <= ext;
        end if;
    end process;
 
end Behavioral;
