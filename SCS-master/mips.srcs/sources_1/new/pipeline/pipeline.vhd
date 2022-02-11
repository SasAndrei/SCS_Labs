----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2019 02:32:14 PM
-- Design Name: 
-- Module Name: pipeline - Behavioral
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

entity pipeline is
  Port (clk, rst: in std_logic);
end pipeline;

architecture Behavioral of pipeline is
component instr_fetch is
   Port (clk: in std_logic;
         reset: in std_logic;
         pcWrite: in std_logic;
         instruction: out std_logic_vector(31 downto 0);
         next_address: out std_logic_vector(31 downto 0));
end component;

component instr_decode is
     Port (instr: in std_logic_vector(31 downto 0);
           
           write_data: in std_logic_vector(31 downto 0);
           write_address: in std_logic_vector(4 downto 0);
           
           reg_write: in std_logic;
           
           extOp: in std_logic;
           clk, rst: in std_logic;
           
           rd1: out std_logic_vector(31 downto 0);
           rd2: out std_logic_vector(31 downto 0);
           
           ext_imm: out std_logic_vector(31 downto 0);
           func: out std_logic_vector(5 downto 0));
           
end component;

signal pcWrite, reg_write, reg_dst, zero, extOP, alu_src, mem_read, mem_write, mem_to_reg: std_logic;
signal instruction, next_address, result, read_data: std_logic_vector(31 downto 0);

--pipeline
signal reg_IF_ID: std_logic_vector(63 downto 0);
signal reg_ID_EX: std_logic_vector(145 downto 0);
signal reg_EX_MEM: std_logic_vector(105 downto 0);
signal reg_MEM_WB: std_logic_vector(70 downto 0);
signal write_data, ext_imm, result_to_write: std_logic_vector(31 downto 0);
signal write_address: std_logic_vector(4 downto 0);
signal instr_25_21, instr_20_16: std_logic_vector(31 downto 0);
signal alu_op: std_logic_vector(1 downto 0);

component control_unit is
  Port ( opcode: in std_logic_vector(5 downto 0);
         func: in std_logic_vector(5 downto 0);
         reg_dst: out std_logic;
         ext_op: out std_logic;
         alu_src: out std_logic;
         alu_op: out std_logic_vector(1 downto 0);
         mem_write: out std_logic; 
         mem_read: out std_logic; 
         mem_to_reg: out std_logic; 
         reg_write: out std_logic);
end component;

component execute_unit is
  Port ( a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        instr_15_11, instr_20_16: IN STD_LOGIC_VECTOR(4 downto 0);
        ext: IN STD_LOGIC_VECTOR(31 downto 0);
        aluSrc, regDst: IN STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_address: OUT STD_LOGIC_VECTOR(4 downto 0);
        zero : OUT STD_LOGIC );
end component;

component memory is
PORT (
clk : IN STD_ULOGIC;
rst_n : IN STD_ULOGIC;

MemRead : IN STD_ULOGIC;
MemWrite : IN STD_ULOGIC;

mem_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );

end component;

begin

---------------------------- INSTRUCTION FETCH
    ifetch: instr_fetch port map (clk=>clk, reset=>rst, pcWrite=>pcWrite, instruction=>instruction, next_address=>next_address);
    
    ---------------IF/ID--------------------
     process(clk, rst)
        begin
        if(rst = '1') then
            reg_IF_ID <= (others => '0');
        else
        if(rising_edge(clk))then
             reg_IF_ID(63 downto 32) <= next_address;
             reg_IF_ID(31 downto 0) <= instruction;
          end if;
        end if;
     end process;
     -----------------------------------------

-------------------------INSTRUCTION DECODE
       
      idecode: instr_decode port map(instr=>reg_IF_ID(31 downto 0), write_data=>result_to_write, write_address=>reg_MEM_WB(4 downto 0), reg_write=>reg_MEM_WB(70), extOp=>extOp, clk=>clk, rst=>rst, rd1=>instr_25_21, rd2=>instr_20_16, ext_imm=>ext_imm, func=>reg_IF_ID(5 downto 0));
      control_unitt: control_unit PORT MAP(
            opcode=>reg_IF_ID(31 downto 26), 
            func=> reg_IF_ID(5 downto 0),
            reg_dst=>reg_dst, 
            ext_op=>extOp, 
            alu_src=>alu_src,
            alu_op=>alu_op, 
            mem_write=>mem_write, 
            mem_read=>mem_read, 
            mem_to_reg=>mem_to_reg, 
            reg_write=>reg_write); -- reg write vine de la WB

---------------ID/EX--------------------
     process(clk, rst)
        begin
        if(rst = '1') then
           reg_ID_EX <= (others => '0');
        else
         if(rising_edge(clk)) then 
            
                reg_ID_EX(145) <= mem_to_reg;
                reg_ID_EX(144) <= reg_write;
                reg_ID_EX(143) <= reg_dst;
                reg_ID_EX(142) <= mem_write;
                reg_ID_EX(141) <= mem_read;
                reg_ID_EX(140 downto 139) <= alu_op;
                reg_ID_EX(138) <= alu_src;
                
                reg_ID_EX(137 downto 106) <= reg_IF_ID(63 downto 32); --next_address
                
                reg_ID_EX(105 downto 74) <= instr_25_21; --output reg file
                reg_ID_EX(73 downto 42) <= instr_20_16;  --output reg file
                
                reg_ID_EX(41 downto 10) <= ext_imm; --32
                reg_ID_EX(9 downto 5) <= reg_IF_ID(20 downto 16); --5
                reg_ID_EX(4 downto 0) <= reg_IF_ID(15 downto 11); --5
            end if;
        end if;
     end process;
     -----------------------------------------    
      
     executeunit: execute_unit port map(a => reg_ID_EX(105 downto 74), b => reg_ID_EX(73 downto 42), aluOp => reg_ID_EX(140 downto 139), instr_15_11=>reg_ID_EX(9 downto 5), instr_20_16 => reg_ID_EX(4 downto 0), ext => reg_ID_EX(41 downto 10), aluSrc => reg_ID_EX(138), regDst => reg_ID_EX(143), result => result, write_address => write_address, zero => zero);
     
     ---------------EX/MEM--------------------
     process(clk, rst)
        begin
        if(rst = '1') then
            reg_EX_MEM <= (others => '0');
        else
         if(rising_edge(clk)) then
                
                reg_EX_MEM(105) <= reg_ID_EX(144); --reg write
                reg_EX_MEM(104) <= reg_ID_EX(142); -- mem write
                reg_EX_MEM(103) <= reg_ID_EX(141); -- mem read
                reg_EX_MEM(102) <= reg_ID_EX(145); -- mem to reg
                reg_EX_MEM(101) <= zero; 
                
                reg_EX_MEM(100 downto 69) <= result;
                reg_EX_MEM(68 downto 37) <= reg_ID_EX(137 downto 106); --next address
                reg_EX_MEM(36 downto 5) <= reg_ID_EX(73 downto 42); -- b
                reg_EX_MEM(4 downto 0) <= write_address;
                
         end if;
         end if;
     end process;
     
     memoryy: memory port map(clk => clk, rst_n => rst, MemRead => reg_EX_MEM(103), MemWrite => reg_EX_MEM(104), mem_address => reg_EX_MEM(100 downto 69), data_in => reg_EX_MEM(36 downto 5), data_out => read_data);
      ------------MEM/WB----------------------
      
      process(clk, rst)
        begin
        if(rst = '1') then
            reg_MEM_WB <= (others => '0');
        else
        if(rising_edge(clk)) then
         
            reg_MEM_WB(70) <= reg_EX_MEM(105); -- reg write
            reg_MEM_WB(69) <= reg_EX_MEM(102); -- mem to reg
            
            reg_MEM_WB(68 downto 37) <= read_data; -- read data
            
            reg_MEM_WB(36 downto 5) <= reg_EX_MEM(100 downto 69); -- alu res
            reg_MEM_WB(4 downto 0) <= reg_EX_MEM(4 downto 0); -- write address
            
            end if;
          end if;
    end process;
    
    write_back: process(reg_MEM_WB)
         begin
            if(reg_MEM_WB(69)='0') then --mem to reg 
                result_to_write <= reg_MEM_WB(36 downto 5); -- alu res
            else
                 result_to_write <= reg_MEM_WB(68 downto 37); -- read data
            end if;
     end process;
     
end Behavioral;
