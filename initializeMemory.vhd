LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE my_pkg IS
    TYPE memory_array IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR;
END PACKAGE;
USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE std.textio.ALL;

ENTITY Memory_Initialization IS
    PORT (
        ram : OUT memory_array(0 TO 100)(15 DOWNTO 0)
        

    );
END Memory_Initialization;
ARCHITECTURE Behavioral OF Memory_Initialization IS

BEGIN
    -- Loading data from the file into memory during initialization
    initialize_memory : PROCESS
        FILE memory_file : text OPEN READ_MODE IS "data.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN

        FOR i IN ram'RANGE LOOP
            IF NOT endfile(memory_file) THEN
                readline(memory_file, file_line);
                read(file_line, temp_data);
                ram(i) <= temp_data;

            ELSE
                file_close(memory_file);
                WAIT;
            END IF;
        END LOOP;

    END PROCESS initialize_memory;

END Behavioral;