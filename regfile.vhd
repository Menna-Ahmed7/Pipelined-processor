LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

PACKAGE reg IS
    TYPE registers_block IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR;
END PACKAGE;

USE work.reg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY register_file IS
    PORT (
        registers : OUT registers_block(0 TO 7)(31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_register_file OF register_file IS
BEGIN
    -- Loading data from the file into memory during initialization
    reg_file : PROCESS
        FILE reg_file : text OPEN READ_MODE IS "register.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        FOR i IN registers'RANGE LOOP
            IF NOT endfile(reg_file) THEN
                readline(reg_file, file_line);
                read(file_line, temp_data);
                registers(i) <= temp_data;
            ELSE
                file_close(reg_file);

            END IF;
        END LOOP;
        WAIT;

    END PROCESS;
END ARCHITECTURE;