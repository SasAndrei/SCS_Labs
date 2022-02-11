----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 06:48:41 PM
-- Design Name: 
-- Module Name: mips - Behavioral
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


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- use package
USE work.procmem_definitions.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mips is
  Port ( clk : IN STD_ULOGIC;
        res : IN STD_ULOGIC );
end mips;

architecture Behavioral of mips is

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

component pc
PORT  (
clk : IN STD_ULOGIC;
rst_n : IN STD_ULOGIC;
pc_in : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
PC_en : IN STD_ULOGIC;
pc_out : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0) );
END component; 

component instreg 
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

component regfile 
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

signal pc_temp: STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
signal en : STD_ULOGIC;
signal opcode: STD_ULOGIC_VECTOR(5 DOWNTO 0);
signal rs: STD_ULOGIC_VECTOR(4 DOWNTO 0);
signal rt: STD_ULOGIC_VECTOR(4 DOWNTO 0);
signal add: STD_ULOGIC_VECTOR(15 DOWNTO 0);
signal oport1: STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
signal oport2: STD_ULOGIC_VECTOR(width-1 DOWNTO 0);

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

PHASEA: phaseGenerator port map (clk => clk,
                                res => res,
                                stateo => stateo);

PCA : pc Port Map (clk => clk,
                    rst_n => res,
                    pc_in => pc_temp,
                    PC_en => en,
                    pc_out=> pc_temp);

IRA : instreg Port Map (clk => clk,
                        rst_n => res,
                        memdata => pc_temp,
                        IRWrite => '0',
                        instr_31_26 => opcode,
                        instr_25_21 => rs,
                        instr_20_16 => rt,
                        instr_15_0 =>  add);
                        
REGA : regfile Port Map (clk => clk,
                        rst_n => res,
                        wen => '0',
                        writeport => pc_temp,
                        adrwport => rs,
                        adrport0 => rs,
                        adrport1 => rt,
                        readport0 => oport1,
                        readport1=>  oport2);
                        
ALUA: alu port map (a => a,
                    b => b,
                    result => aluOut,
                    opCode => To_StdULogicVector(aluOp));

CONTROLA: controlUnit port map (state => stateo,
                                opcode => To_StdLogicVector(instr_31_26),
                                func => To_StdLogicVector(instr_15_0(5 downto 0)),
                                memRead => memRead,
                                memWrite => memWrite,
                                regDst => regDst,
                                regWrite => regWrite,
                                memToReg => memToReg,
                                irWrite => irWrite,
                                extOp => extOp,
                                pcWrite => pcEn,
                                aluOp => aluOp,
                                aluSrcA => aluSrcA,
                                aluSrcB => aluSrcB);

end Behavioral;
