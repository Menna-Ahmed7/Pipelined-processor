LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY fetch_decode IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;
ARCHITECTURE arch_fetch_decode OF fetch_decode IS
BEGIN
    fetch_decode_p : PROCESS (clk, RST)
    BEGIN
        IF RST = '1' THEN
            out_instruction <= (OTHERS => '0');
            out_pc <= (OTHERS => '0');
        ELSIF clk'event AND clk = '1'THEN
            out_instruction <= instruction;
            out_pc <= pc;

        END IF;
    END PROCESS;

END ARCHITECTURE;