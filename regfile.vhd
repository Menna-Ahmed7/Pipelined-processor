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

ENTITY register_file IS
    PORT (
        clk : IN STD_LOGIC;
        we : IN STD_LOGIC;
        re : IN STD_LOGIC;
        reg_number : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_register_file OF register_file IS
    SIGNAL registers : memory_array(0 TO 7)(31 DOWNTO 0);
    SIGNAL initial_flag : STD_LOGIC := '1';
BEGIN
    -- Loading data from the file into memory during initialization
    reg_file : PROCESS (clk)
        FILE reg_file : text OPEN READ_MODE IS "register.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN

        IF (initial_flag = '1') THEN
            FOR i IN registers'RANGE LOOP
                IF NOT endfile(reg_file) THEN
                    readline(reg_file, file_line);
                    read(file_line, temp_data);
                    registers(i) <= temp_data;
                ELSE
                    file_close(reg_file);

                END IF;
            END LOOP;
            initial_flag <= '0';
        ELSIF clk'event AND clk = '0' THEN

            IF we = '1' THEN
                dataout <= registers(to_integer(unsigned(reg_number)));
            ELSIF re = '1' THEN
                registers(to_integer(unsigned(reg_number))) <= datain;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;