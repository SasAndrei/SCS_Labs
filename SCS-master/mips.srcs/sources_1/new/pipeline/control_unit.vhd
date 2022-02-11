----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2019 04:53:58 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is

begin

process(opcode)
    begin
    case opcode is
    
    --R-type
    when "000000" => reg_dst <= '1'; ext_op <='0'; alu_src <= '0'; reg_write <= '1'; mem_read <= '0'; mem_write <= '0'; mem_to_reg <= '0'; 
        case func is
            when "100000" => alu_op<="00"; -- add 
            when "100010" => alu_op<="01"; -- sub
            when "100100" => alu_op<="10"; -- and
            when "100101" => alu_op<="11"; -- or
            when others => alu_op <= "00";
         end case;
    --lw
    when "100011" => reg_dst <= '0'; ext_op <='1'; alu_src <= '1'; reg_write <= '1'; mem_read <= '1'; mem_write <= '0'; mem_to_reg <= '1'; alu_op <= "00";
    --sw
    when "101011" => reg_dst <= 'X'; ext_op <='1'; alu_src <= '1'; reg_write <= '0'; mem_read <= '0'; mem_write <= '1'; mem_to_reg <= '0'; alu_op <= "00";
   
    when others => reg_dst <= '0'; ext_op <='0'; alu_src <= '1'; reg_write <= '0'; mem_read <= '0'; mem_write <= '0'; mem_to_reg <= '0'; alu_op <= "00";
    end case;
    end process;

end Behavioral;
