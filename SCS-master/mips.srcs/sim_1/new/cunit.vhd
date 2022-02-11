----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2019 05:34:52 PM
-- Design Name: 
-- Module Name: cunit - Behavioral
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

entity cunit is
--  Port ( );
end cunit;

architecture Behavioral of cunit is

component controlUnit is
    Port ( state : in STD_LOGIC_VECTOR (2 downto 0);
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           func: in std_logic_vector (5 downto 0);
           memRead : out STD_LOGIC;
           memWrite : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           regDst : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           irWrite : out STD_LOGIC;
           extOp: out std_logic;
           IorD: out std_logic;
           aluSrcB : out STD_LOGIC;
           aluOp : out STD_LOGIC_VECTOR (1 downto 0);
           pcWrite: out std_logic);
end component;

signal state: std_logic_vector(2 downto 0);
signal opcode : STD_LOGIC_VECTOR (5 downto 0);
signal func: std_logic_vector (5 downto 0);
signal memRead, memWrite, memToReg, regDst, regWrite, irWrite, extOp, IorD, aluSrcB, pcWrite: std_logic;
signal aluOp: std_logic_vector(1 downto 0);    
    
begin
    
    CU: controlUnit port map( state=>state,
                               opcode=>opcode,
                               func=>func,
                               memRead=>memRead,
                               memWrite=>memWrite,
                               memToReg=>memToReg,
                               regDst=>regDst,
                               regWrite=>regWrite,
                               irWrite=>irWrite,
                               extOp=>extOp,
                               IorD=>IorD,
                               aluSrcB=>aluSrcB,
                               aluOp=>aluOp,
                               pcWrite=>pcWrite);
    
    process
    begin
    
    state <= "000"; -- IF
    opcode <= "000000"; --R  
    wait for 100 ns;
    
    state <= "001"; -- ID
    opcode <= "000000"; --R   
    wait for 100 ns;
    
    state <= "010"; -- EX
    opcode <= "000000"; --R   
    func <= "100000";
    wait for 100 ns;
    
    state <= "011"; -- MEM
    opcode <= "000000"; --R   
    wait for 100 ns;
    
    state <= "100"; -- WB
    opcode <= "000000"; --R   
    wait for 100 ns;
   
    state <= "000"; -- IF
    opcode <= "100011"; --LW  
    wait for 100 ns; 
    
    state <= "000"; -- IF
    opcode <= "101011"; --SW 
    wait for 100 ns;
        
    state <= "011"; -- IF
    opcode <= "101011"; --SW 
    wait for 100 ns;
   
    end process;

end Behavioral;
