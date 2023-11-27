library ieee;
use ieee.std_logic_1164.all;

package my_pkg is
        type memory_array is array(natural range <>) of std_logic_vector;
end package;
use work.my_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;



ENTITY Memory_Initialization IS
    PORT (
        ram : OUT memory_array(0 to 100)(15 downto 0)
    );
END Memory_Initialization;
ARCHITECTURE Behavioral OF Memory_Initialization IS


    
BEGIN
    -- Loading data from the file into memory during initialization
    initialize_memory : PROCESS
FILE memory_file : text OPEN READ_MODE IS "memory.txt";
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
