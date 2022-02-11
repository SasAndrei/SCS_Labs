----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2021 04:43:52 PM
-- Design Name: 
-- Module Name: TestBench - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity testBench is
end testBench;

architecture Behavioral of testBench is

constant T : time := 50 ns;

component Counter8 is
    port( clk : in std_logic;
        q : out std_logic_vector(3 downto 0));
end component;

component lookAheadAdder4bit is
port( in1 : in std_logic_vector(3 downto 0);
        in2 : in std_logic_vector(3 downto 0);
        cin : in std_logic;
        outSum : out std_logic_vector(3 downto 0);
        outC: out std_logic
);
end component;

signal clk, outC : std_logic;
signal q, outSum : std_logic_vector(3 downto 0) := X"0";

begin


    -- EIGHT BIT COUNTER
--    uut1: Counter8 PORT MAP(
--        clk => clk,
--        q => q
--    );


    --LOOK AHEAD ADDER
    uut2: lookAheadAdder4bit PORT MAP(
        in1 => "0101",
        in2 => "1101",
        cin => '0',
        outSum => outSum,
        outC => outC
    );

    clock: process
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
    end process;
    

end Behavioral;
