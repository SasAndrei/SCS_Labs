----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2019 10:06:42 PM
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- avem doar un clock
entity main is
      Port (clk, rst: in std_logic);
end main;

architecture Behavioral of main is

component phase_generator is
  Port (clk: in std_logic;
        rst: in std_logic;
        next_state : out STD_LOGIC_VECTOR (2 downto 0)
         );
end component;

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

component memory is
PORT (
clk : IN STD_LOGIC;
rst_n : IN STD_LOGIC;
MemRead : IN STD_LOGIC;
MemWrite : IN STD_LOGIC;
mem_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
end component;

component ir IS
PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        
        memdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- instuction content
        
        IRWrite : IN STD_LOGIC;
    
        instr_31_26 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        instr_25_21 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        instr_20_16 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        instr_15_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
END component;


COMPONENT tempreg IS
PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        reg_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        reg_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END COMPONENT;

component regfile IS
PORT (clk,rst_n : IN std_logic;
wen : IN std_logic; -- write control

writeport : IN std_logic_vector(31 DOWNTO 0); -- register input
adrwport : IN std_logic_vector(4 DOWNTO 0);-- address write

adrport0 : IN std_logic_vector(4 DOWNTO 0);-- address port 0
adrport1 : IN std_logic_vector(4 DOWNTO 0);-- address port 1

readport0 : OUT std_logic_vector(31 DOWNTO 0); -- output port 0
readport1 : OUT std_logic_vector(31 DOWNTO 0) -- output port 1
);
END component;

component alu IS
PORT (
        a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zero : OUT STD_LOGIC);
END component;

signal  memRead, memWrite, memToReg, regWrite, irWrite, extOp, IorD, aluSrcB, regDst, zero, pcWrite: std_logic;
signal aluOp: std_logic_vector(1 downto 0);
signal next_state: std_logic_vector(2 downto 0);
signal pc: std_logic_vector(31 downto 0);
signal data_out, mem_adr, alu_out, reg_memdata, write_data, outA, outB, reg_A, reg_B, ext_imm, op2, alu_res: std_logic_vector(31 downto 0);
signal instr_31_26, func, opcode: std_logic_vector(5 downto 0);
signal instr_25_21, instr_20_16, write_adr: std_logic_vector(4 downto 0);
signal instr_15_0: std_logic_vector(15 downto 0);

begin

    generate_next_state: phase_generator port map(clk=>clk, rst=>rst, next_state=>next_state);
    
    control_unit: controlUnit port map(state=>next_state,
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
     func <= instr_15_0(5 downto 0);
     
     -- INSTRUCTION FETCH
     -- generate next state
     process(clk, rst, pcWrite)
     begin
     if(rst='1') then
        pc <= x"00000000";
     else
        if(clk'event and clk='1') then
            if(pcWrite = '1') then
                pc <= pc + 1;
            end if;
        end if;
     end if;
     end process;
    
    -- compute address for memory
    process(IorD, pc, alu_out)
    begin
         IF IorD = '0' THEN
            mem_adr <= pc; -- din pc
         ELSIF IorD = '1' THEN
            mem_adr <= alu_res; --sau din alu_out, adresa computata pentru LW, SW
         END IF;
    end process;
    
    id_memory: memory port map(clk=>clk, rst_n=>'0', MemRead=>memRead, MemWrite=>memWrite, mem_address=>mem_adr, data_in=>reg_B, data_out=>data_out);

    instr_reg : ir
        PORT MAP (
        clk => clk,
        rst_n => rst,
        memdata => data_out,
        IRWrite => IRWrite,
        instr_31_26 => opcode,
        instr_25_21 => instr_25_21,
        instr_20_16 => instr_20_16,
        instr_15_0 => instr_15_0 );
     
    mem_data_reg : tempreg
    PORT MAP (
        clk => clk,
        rst_n => rst,
        reg_in => data_out,
        reg_out => reg_memdata ); 
    
    -- INSTRUCTION DECODE
    muxForRegDst: process(regDst, data_out, instr_20_16)
    begin
        if(regDst = '0') then
            write_adr <= instr_20_16; --rt
        else
            write_adr <= data_out(15 downto 11); -- rd
        end if;
    end process;    
    
    muxForMemToReg: process(alu_out, reg_memdata, memToReg)
    begin
        if(memToReg = '0') then
                write_data <= alu_out;
         else
                write_data <= reg_memdata;
        end if;
    end process;
    
    reg_file: regfile port map(clk=>clk,
                                rst_n=>'0',
                                wen=>regWrite,
                                writeport=>write_data, -- register input
                                adrwport=>write_adr,-- address write
                                adrport0=>instr_25_21,-- address port 0
                                adrport1=>instr_20_16,-- address port 1
                                readport0=>outA, -- output port 0
                                readport1=>outB); -- output port 1
    
     -- put in registers A and B  
     A_reg: tempreg
    PORT MAP (
        clk => clk,
        rst_n => rst,
        reg_in => outA,
        reg_out => reg_A ); 
        
    B_reg : tempreg
    PORT MAP (
        clk => clk,
        rst_n => rst,
        reg_in => outB,
        reg_out => reg_B);                          
    
    -- EXECUTE 
    -- perform sign extension
    process(clk, data_out, extOp)
    begin
    case extOp is
        when '0' => ext_imm <= "0000000000000000"&instr_15_0; ------instr_15_0 este undefined
        when '1' => if(instr_15_0(15)='0') then ext_imm <= "0000000000000000"&instr_15_0; 
                                     else ext_imm <= "1111111111111111"&instr_15_0;
                    end if;
        when others => null;
     end case;
     end process;
    -- mux for aluSrcB
    muxForAluSrc: process(aluSrcB, reg_B, ext_imm)
    begin
        if(aluSrcB = '0') then
            op2 <= reg_B;
        else
            op2 <= ext_imm;
        end if;
    end process;
    
    -- alu port map
    alunelu: alu port map(a=>reg_A, b=>op2, opcode=>aluOp, result=>alu_res, zero=>zero);
    
    -- alu out register
    alu_result: tempreg PORT MAP (
        clk => clk,
        rst_n => rst,
        reg_in => alu_res,
        reg_out => alu_out); 
    
end Behavioral;
