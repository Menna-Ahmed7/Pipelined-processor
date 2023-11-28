library ieee;
use ieee.std_logic_1164.all;

package my_pkg1 is
        type register_array is array(natural range <>) of std_logic_vector;
end package;
use work.my_pkg1.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
ENTITY register_file IS
    PORT (
        registers : OUT register_array(0 to 6)(31 downto 0)
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
                WAIT;
            END IF;
        END LOOP;
    END PROCESS ;

END ARCHITECTURE;

