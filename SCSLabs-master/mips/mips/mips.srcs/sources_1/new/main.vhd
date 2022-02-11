----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2019 08:37:22 AM
-- Design Name: 
-- Module Name: main - Behavioral
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

USE work.procmem_definitions.ALL;

entity main is
  Port (clk: in std_logic;
        res: in std_logic
   );
end main;

architecture Behavioral of main is

component phaseGenerator is
    Port ( clk : in STD_LOGIC;
           res: in std_logic;
           stateo : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component alu IS
PORT (
a, b : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
opcode : IN STD_ULOGIC_VECTOR(1 DOWNTO 0);
result : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
zero : OUT STD_ULOGIC);
END component;

component controlUnit is
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
end component;

component instreg IS
PORT (
clk : IN STD_ULOGIC;
rst_n : IN STD_ULOGIC;
memdata : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
IRWrite : IN STD_ULOGIC;
instr_31_26 : OUT STD_ULOGIC_VECTOR(5 DOWNTO 0);
instr_25_21 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
instr_20_16 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
instr_15_0 : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0) );
END component;

component pc IS
PORT (
clk : IN STD_ULOGIC;
rst_n : IN STD_ULOGIC;
pc_in : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
PC_en : IN STD_ULOGIC;
pc_out : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0) );
END component; 

component regfile IS
PORT (clk,rst_n : IN std_ulogic;
wen : IN std_ulogic; -- write control
writeport : IN std_ulogic_vector(width-1 DOWNTO 0); -- register input
adrwport : IN std_ulogic_vector(regfile_adrsize-1 DOWNTO 0);-- address write
adrport0 : IN std_ulogic_vector(regfile_adrsize-1 DOWNTO 0);-- address port 0
adrport1 : IN std_ulogic_vector(regfile_adrsize-1 DOWNTO 0);-- address port 1
readport0 : OUT std_ulogic_vector(width-1 DOWNTO 0); -- output port 0
readport1 : OUT std_ulogic_vector(width-1 DOWNTO 0) -- output port 1
);
END component;

signal stateo: std_logic_vector(2 downto 0);
signal aluOp, aluSrcB: std_logic_vector (1 downto 0);
signal aluOut, pcOut, memOut: STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
signal memRead, memWrite, regDst, regWrite, aluSrcA, memToReg, irWrite, extOp, pcEn: std_logic;
signal instr_31_26 : STD_ULOGIC_VECTOR(5 DOWNTO 0);
signal instr_25_21 : STD_ULOGIC_VECTOR(4 DOWNTO 0);
signal instr_20_16 : STD_ULOGIC_VECTOR(4 DOWNTO 0);
signal instr_15_0 : STD_ULOGIC_VECTOR(15 DOWNTO 0);
signal a, b, readport0, readport1: std_ulogic_vector(width-1 DOWNTO 0);
signal adrwport: std_ulogic_vector(regfile_adrsize-1 DOWNTO 0);
signal writePort: std_ulogic_vector(width-1 DOWNTO 0);


begin

with regDst select adrwport <= instr_20_16 when '0', instr_15_0(15 downto 11) when '1';
with memToReg select writePort <= aluOut when '0', memOut when '1';

with aluSrcA select readport0 <= a when '1', pcOut when '0';
with aluSrcB select readport1 <= b when "01", "00000000000000000000000000000100" when "00", "0000000000000000" & instr_15_0 when "10", "00000000000000000000000000000000" when "11";

phase: phaseGenerator port map (clk => clk, res => res, stateo => stateo);
pc1: pc port map (clk=>clk, rst_n=>res, pc_in => aluOut, pc_out=>pcOut, pc_en => pcEn);
instreg1: instreg port map (clk=>clk, rst_n=>res, memdata => "00000000000000010001000000100000", IRWrite => irWrite, instr_31_26 => instr_31_26, instr_25_21 => instr_25_21, instr_20_16 => instr_20_16, instr_15_0 => instr_15_0);
regfile1: regfile port map (clk => clk, rst_n => res, wen => regWrite, writePort => writePort, adrwport => adrwport, adrport0 => instr_25_21, adrport1 => instr_20_16, readport0 => a, readport1 => b);
alu1: alu port map (a => a, b => b, result => aluOut, opCode => To_StdULogicVector(aluOp));
control: controlUnit port map (state => stateo, opcode => To_StdLogicVector(instr_31_26), func => To_StdLogicVector(instr_15_0(5 downto 0)), memRead => memRead, memWrite => memWrite, regDst => regDst, regWrite => regWrite, memToReg => memToReg, irWrite => irWrite, extOp => extOp, pcWrite => pcEn, aluOp => aluOp, aluSrcA => aluSrcA, aluSrcB => aluSrcB);

end Behavioral;
