LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
PACKAGE my_pkg IS
    TYPE memory_array IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR;
END PACKAGE;

USE work.my_pkg.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY instruction_memory IS
    PORT (
        clk : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_instruction_memory OF instruction_memory IS
    SIGNAL one : STD_LOGIC_VECTOR(31 DOWNTO 0) := (0 => '1', OTHERS => '0');
    SIGNAL ram : memory_array(0 TO 20)(15 DOWNTO 0);
    SIGNAL initial_flag : STD_LOGIC := '1';
BEGIN

    instruction_memory : PROCESS (clk) IS
        FILE memory_file : text OPEN read_mode IS "instruction.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF (initial_flag = '1') THEN
            FOR i IN ram'RANGE LOOP
                IF NOT endfile(memory_file) THEN
                    readline(memory_file, file_line);
                    read(file_line, temp_data);
                    ram(i) <= temp_data;
                ELSE
                    file_close(memory_file);

                END IF;
            END LOOP;
            initial_flag <= '0';

        ELSIF clk'event AND clk = '0' THEN
            dataout <= ram(to_integer(unsigned(address)));
        END IF;

    END PROCESS instruction_memory;
END ARCHITECTURE;