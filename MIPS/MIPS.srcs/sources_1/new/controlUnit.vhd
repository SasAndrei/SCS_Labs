----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2021 06:40:12 PM
-- Design Name: 
-- Module Name: controlUnit - Behavioral
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

entity controlUnit is
    Port ( state : in STD_LOGIC_VECTOR (2 downto 0);
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           func: in std_logic_vector (5 downto 0);
           memRead : out STD_LOGIC;
           memWrite : out STD_LOGIC;
           regDst : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           aluSrcA : out STD_LOGIC;
           aluSrcB : out STD_LOGIC_vector(1 downto 0);
           memToReg : out STD_LOGIC;
           irWrite : out STD_LOGIC;
           pcWrite : out STD_LOGIC;
           extOp: out std_logic;
           aluOp : out STD_LOGIC_VECTOR (1 downto 0));
end controlUnit;

architecture Behavioral of controlUnit is

signal s: std_logic_vector(8 downto 0);

begin

s(8 downto 0) <= state(2 downto 0) & opcode(5 downto 0);

process (s)
begin
case s is
when "000000000"=>aluSrcA<='0';
                  aluSrcB<="00";
                  irWrite<='1';
                  pcWrite<='1';
                  aluOp<="00";
                  memRead<='0';
                  memWrite<='0';
                  regDst<='0';
                  regWrite<='0';
                  memToReg<='0';
                  extOp<='0';
when "001000000"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "010000000"=>aluSrcA<='1';
                aluSrcB<="01";
                irWrite<='0';
                pcWrite<='0';
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                case func is
                when "100000" => aluOp<="00";
                when "100010" => aluOp<="01";
                when "100100" => aluOp<="10";
                when "100101" => aluOp<="11";
                when others => aluOp<="00";
                end case;
when "011000000"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='1';
                regWrite<='1';
                memToReg<='0';
                extOp<='0';
when "100000000"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "000100011"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='1';
                pcWrite<='1';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "001100011"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "010100011"=>aluSrcA<='0';
                aluSrcB<="10";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='1';
when "011100011"=>aluSrcA<='0';
                aluSrcB<="10";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='1';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "100100011"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='1';
                memToReg<='1';
                extOp<='0';
when "000101011"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='1';
                pcWrite<='1';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "001101011"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "010101011"=>aluSrcA<='0';
                aluSrcB<="10";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='1';
when "011101011"=>aluSrcA<='0';
                aluSrcB<="10";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='1';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when "100101011"=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
when others=>aluSrcA<='0';
                aluSrcB<="00";
                irWrite<='0';
                pcWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
end case;
end process;

end Behavioral;