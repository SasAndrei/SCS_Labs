----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2019 03:17:43 PM
-- Design Name: 
-- Module Name: instr_decode - Behavioral
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

entity instr_decode is
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
           
end instr_decode;

architecture Behavioral of instr_decode is

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
signal rs, rt: std_logic_vector(4 downto 0);
signal instr_15_0: std_logic_vector(15 downto 0);

begin   
    rs <= instr(25 downto 21);
    
    rt <= instr(20 downto 16);
    
    register_file: regfile PORT MAP(
                    clk=>clk,
                    rst_n=>rst,
                    wen=>reg_write,
                    
                    adrport0=>rs, 
                    adrport1=>rt, 
                    
                    adrwport=>write_address, 
                    writeport=>write_data, 
                    
                    readport0=>rd1, 
                    readport1=>rd2);
                    
     -- perform sign extension
    instr_15_0 <= instr(15 downto 0);
    
    process(clk, instr, extOp)
    begin
    case extOp is
        when '0' => ext_imm <= "0000000000000000"&instr_15_0;
        when '1' => if(instr_15_0(15)='0') then ext_imm <= "0000000000000000"&instr_15_0; 
                                     else ext_imm <= "1111111111111111"&instr_15_0;
                    end if;
        when others => null;
     end case;
     end process;

end Behavioral;
