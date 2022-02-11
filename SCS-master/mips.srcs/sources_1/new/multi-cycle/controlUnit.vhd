----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2019 07:35:16 PM
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
           memToReg : out STD_LOGIC;
           regDst : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           irWrite : out STD_LOGIC;
           extOp: out std_logic;
           IorD: out std_logic;
           aluSrcB : out STD_LOGIC;
           aluOp : out STD_LOGIC_VECTOR (1 downto 0);
           pcWrite: out std_logic);
end controlUnit;

architecture Behavioral of controlUnit is

begin
process (state, opcode, func)
begin
case state is
-- IFF
when "000" =>     aluSrcB<='0'; -- IFF - R-type, LOAD, STORE
                  irWrite<='1'; -- fetch next instruction
                  aluOp<="00";  --add operation
                  memRead<='1';
                  memWrite<='0';
                  regDst<='0';
                  regWrite<='0';
                  memToReg<='0';
                  extOp<='0';
                  IorD <= '0';
                  pcWrite <= '0';
-- DECODE
when "001" =>  aluSrcB<='0'; -- ID -- R-type, LOAD, STORE
                irWrite<='0';
                aluOp<="00"; --add
                memRead<='0';
                memWrite<='0';
                regDst<='0'; 
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '0';
                pcWrite <= '0';
-- EXECUTE
when "010" => case opcode is
              when "000000" => -- EX -- R-type
                                aluSrcB<='0'; -- B
                                irWrite<='0';
                                memRead<='0';
                                memWrite<='0';
                                regDst<='0';
                                regWrite<='0';
                                memToReg<='0';
                                extOp<='0';
                                IorD <= '0';
                                pcWrite <= '0';
                                case func is
                                    when "100000" => aluOp<="00"; -- add 
                                    when "100010" => aluOp<="01"; -- sub
                                    when "100100" => aluOp<="10"; -- and
                                    when "100101" => aluOp<="11"; -- or
                                    when others => aluOp <= "00";
                                end case;
              when "100011" =>          aluSrcB<='1'; -- B is from sign extension component
                                        irWrite<='0';
                                        aluOp<="00";
                                        memRead<='0';
                                        memWrite<='0';
                                        regDst<='0';
                                        regWrite<='0';
                                        memToReg<='0';
                                        extOp<='1'; --make sign extension
                                        IorD <= '0';
                                        pcWrite <= '0';
               when "101011" =>  -- EX -- LOAD, STORE
                                        aluSrcB<='1'; -- B is from sign extension component
                                        irWrite<='0';
                                        aluOp<="00";
                                        memRead<='0';
                                        memWrite<='0';
                                        regDst<='0';
                                        regWrite<='0';
                                        memToReg<='0';
                                        extOp<='1'; --make sign extension
                                        IorD <= '0';
                                        pcWrite <= '0';
              when others =>aluSrcb <= '0';
                            irWrite<='0';
                            aluOp<="00";
                            memRead<='0';
                            memWrite<='0';
                            regDst<='0';
                            regWrite<='0';
                            memToReg<='0';
                            extOp<='0';
                            IorD <= '0';
                            pcWrite <= '0';
              end case;  

-- MEMORY                                          
when "011" => case opcode is  
            when "000000"=> -- MA -- R-type
                aluSrcB<='0';
                irWrite<='0'; 
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='1';
                regWrite<='1';
                memToReg<='0';
                extOp<='0';
                IorD <= '0';
                pcWrite <= '0';
             when "100011" => -- MA -- LOAD
                aluSrcB<='1';
                irWrite<='0';
                aluOp<="00";
                memRead<='1'; -- read from memory
                memWrite<='0';
                regDst<='0'; 
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '1';
                pcWrite <= '0';
             when "101011"=> -- MA -- STORE
                aluSrcB<='1';
                irWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='1'; -- write in memory  
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '1';
                pcWrite <= '0';
            when others =>aluSrcb <= '0';
                irWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '0';
                pcWrite <= '0';

             end case;
             
-- WRITE BACK             
when "100" => case opcode is 
        when "000000"=> -- WB -- R-type
                aluSrcB<='0';
                irWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '0';
                pcWrite <= '1';
             when "100011" => -- WB -- LOAD
                aluSrcB<='0';
                irWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0'; -- rt
                regWrite<='1'; -- write in rt
                memToReg<='1'; -- write from memory
                extOp<='0';
                IorD <= '0';
                pcWrite <= '1';
            when "101011"=> -- WB -- STORE
                aluSrcB<='0';
                irWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '0';
                pcWrite <= '1';
           when others => aluSrcb <= '0';
            irWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '0';
                pcWrite <= '0';

        end case;
        when others => aluSrcB<='0';
                irWrite<='0';
                aluOp<="00";
                memRead<='0';
                memWrite<='0';
                regDst<='0';
                regWrite<='0';
                memToReg<='0';
                extOp<='0';
                IorD <= '0';
                pcWrite <= '0';
end case;
end process;

end Behavioral;
