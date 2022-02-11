----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2021 06:41:20 PM
-- Design Name: 
-- Module Name: phaseGenerator - Behavioral
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

entity phaseGenerator is
    Port ( clk : in STD_LOGIC;
           res: in std_logic;
           stateo : out STD_LOGIC_VECTOR (2 downto 0));
end phaseGenerator;

architecture Behavioral of phaseGenerator is

type state_type is (IFF, ID, EX, MA, WB);
signal state : state_type;

begin
    process (clk, res)
    begin
        if res = '1' then
            state<=IFF;
        elsif rising_edge(clk) then
            case state is
            when IFF =>
                state<=ID;
            when ID =>
                state<=EX;
            when EX =>
                state<=MA;
            when MA =>
                state<=WB;
            when others =>
                state<=IFF;
            end case;
        end if;
    end process;

    process (state)
    begin
        case state is
            when IFF =>
                stateo<="000";
            when ID =>
                stateo<="001";
            when EX =>
                stateo<="010";
            when MA =>
                stateo<="011";
            when others =>
                stateo<="100";
        end case;
    end process;

end Behavioral;