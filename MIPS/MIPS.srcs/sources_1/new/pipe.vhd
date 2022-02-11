----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 06:45:53 PM
-- Design Name: 
-- Module Name: pipe - Behavioral
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
entity pipe is
  Port (clk, rst: in std_logic);
end pipe;

architecture Behavioral of pipe is

component pc is
   PORT (
        clk : IN STD_ULOGIC;
        rst_n : IN STD_ULOGIC;
        pc_in : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
        PC_en : IN STD_ULOGIC;
        pc_out : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0) );
end component;

signal pcWrite, reg_write, reg_dst, zero, extOP, alu_src, mem_read, mem_write, mem_to_reg: std_logic;
signal instruction, next_address, result, read_data: std_logic_vector(31 downto 0);

--pipeline
signal reg_IF_ID: std_logic_vector(65 downto 0);
signal reg_ID_EX: std_logic_vector(145 downto 0);
signal reg_EX_MEM: std_logic_vector(105 downto 0);
signal reg_MEM_WB: std_logic_vector(70 downto 0);
signal write_data, ext_imm, result_to_write: std_logic_vector(31 downto 0);
signal write_address: std_logic_vector(4 downto 0);
signal instr_25_21, instr_20_16: std_logic_vector(31 downto 0);
signal alu_op: std_logic_vector(1 downto 0);
signal stateo: std_logic_vector(2 downto 0);

component phaseGenerator is
    Port ( clk : in STD_LOGIC;
           res: in std_logic;
           stateo : out STD_LOGIC_VECTOR (2 downto 0));
end component;

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

component alu is
  PORT (
        a, b : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
        opcode : IN STD_ULOGIC_VECTOR(1 DOWNTO 0);
        result : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
        zero : OUT STD_ULOGIC);
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

    phaseP: phaseGenerator port map (clk => clk,
                                res => rst,
                                stateo => stateo);
    pcP: pc port map (clk=>clk, 
                      rst_n=>rst, 
                      PC_en=>pcWrite, 
                      pc_in=>instruction, 
                      pc_out=>next_address);
    
     process(clk, rst)
        begin
        if(rst = '1') then
            reg_IF_ID <= (others => '0');
        else
        if(rising_edge(clk))then
             reg_IF_ID(65 downto 64) <= stateo;
             reg_IF_ID(63 downto 32) <= next_address;
             reg_IF_ID(31 downto 0) <= instruction;
          end if;
        end if;
     end process;
       
      iregP: instreg  port map(memdata=>reg_IF_ID(31 downto 0),    
                                    IRWrite=>reg_MEM_WB(70), 
                                    clk=>clk, 
                                    rst_n=>rst, 
                                    instr_25_21=>instr_25_21, 
                                    instr_20_16=>instr_20_16,                              
                                    instr_31_26=>reg_IF_ID(5 downto 0));
      
      controlUnitP: controlUnit PORT MAP(
            state=>reg_IF_ID(65 downto 63),
            opcode=>reg_IF_ID(31 downto 26), 
            func=> reg_IF_ID(5 downto 0),
            regDst=>reg_dst, 
            extOp=>extOp, 
            aluSrcA=>alu_src,
            aluOp=>alu_op, 
            memWrite=>mem_write, 
            memRead=>mem_read, 
            memToReg=>mem_to_reg, 
            regWrite=>reg_write); -- reg write vine de la WB

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
      
     aluP: alu port map(a => reg_ID_EX(105 downto 74), 
                        b => reg_ID_EX(73 downto 42), 
                        opcode => reg_ID_EX(140 downto 139), 
                        result=>result,
                        zero => zero);
     
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
     
     memoryP: memory port map(clk => clk, 
                              rst_n => rst, 
                              MemRead => reg_EX_MEM(103), 
                              MemWrite => reg_EX_MEM(104), 
                              mem_address => reg_EX_MEM(100 downto 69), 
                              data_in => reg_EX_MEM(36 downto 5), 
                              data_out => read_data);
      
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
