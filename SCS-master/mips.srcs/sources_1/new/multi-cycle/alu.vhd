LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

-- use package
ENTITY alu IS
PORT (
        a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zero : OUT STD_LOGIC);
END alu;

ARCHITECTURE behave OF alu IS
BEGIN
PROCESS(a, b, opcode)
-- declaration of variables
VARIABLE a_uns : UNSIGNED(31 DOWNTO 0);
VARIABLE b_uns : UNSIGNED(31 DOWNTO 0);
VARIABLE r_uns : UNSIGNED(31 DOWNTO 0);
VARIABLE z_uns : UNSIGNED(0 DOWNTO 0);

BEGIN
-- initialize values
a_uns := UNSIGNED(a);
b_uns := UNSIGNED(b);
r_uns := (OTHERS => '0');
z_uns(0) := '0';
-- select desired operation
    CASE opcode IS
        -- add
        WHEN "00" =>
        r_uns := a_uns + b_uns;
        -- sub
        WHEN "01" =>
        r_uns := a_uns - b_uns;
        -- and
        WHEN "10" =>
        r_uns := a_uns AND b_uns;
        -- or
        WHEN "11" =>
        r_uns := a_uns OR b_uns;
        -- others
        WHEN OTHERS => r_uns := (OTHERS => 'X');
    END CASE;
-- set zero bit if result equals zero
    IF TO_INTEGER(r_uns) = 0 THEN
            z_uns(0) := '1';
    ELSE
            z_uns(0) := '0';
    END IF;
-- assign variables to output signals
    result <= STD_LOGIC_VECTOR(r_uns);
    zero <= z_uns(0);
END PROCESS;
END behave;
