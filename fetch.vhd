USE work.my_pkg.ALL;
USE work.my_pkg1.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY fetch IS
    PORT (
        registers : IN register_array(0 TO 6)(31 DOWNTO 0);
        ram : IN memory_array(0 TO 4095)(15 DOWNTO 0);
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        jz : IN STD_LOGIC;
        jz_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Fetch;
ARCHITECTURE arch_fetch OF fetch IS
    SIGNAL one : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL two : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    one <= (0 => '1', OTHERS => '0');
    two <= (1 => '1', OTHERS => '0');
    PROCESS (pc) IS
    BEGIN
        instruction(31 DOWNTO 16) <= ram(to_integer(unsigned(pc)));
        instruction(15 DOWNTO 0) <= ram(to_integer(unsigned(pc + one)));
        IF instruction(31 DOWNTO 22) = "100000001" OR instruction(31 DOWNTO 22) = "100000010" THEN
            reg <= instruction(21 DOWNTO 19);
            next_pc <= registers(to_integer(unsigned(reg)));

        ELSIF jz = '1' THEN
            reg <= (OTHERS => '0');
            next_pc <= jz_address;
        ELSIF instruction(31 DOWNTO 22) = "111111111" OR instruction(31 DOWNTO 22) = "111111111" THEN
            reg <= (OTHERS => '0');
            next_pc <= (OTHERS => '0');
        ELSE
            reg <= (OTHERS => '0');
            next_pc <= pc + two;
        END IF;
    END PROCESS;
END ARCHITECTURE;