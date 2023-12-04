USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY data_memory IS
    PORT (
        clk : IN STD_LOGIC;
        we : IN STD_LOGIC;
        re : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_data_memory OF data_memory IS
    SIGNAL one : STD_LOGIC_VECTOR(31 DOWNTO 0) := (0 => '1', OTHERS => '0');
    SIGNAL two : STD_LOGIC_VECTOR(31 DOWNTO 0) := (1 => '1', OTHERS => '0');
    SIGNAL three : STD_LOGIC_VECTOR(31 DOWNTO 0) := (0 => '1', 1 => '1', OTHERS => '0');
    SIGNAL ram : memory_array(0 TO 20)(15 DOWNTO 0);
    SIGNAL initial_flag : STD_LOGIC := '1';
BEGIN

    data_memory : PROCESS (clk, address, datain, we, re) IS
        FILE memory_file : text OPEN read_mode IS "data.txt";
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

        ELSE

            IF we = '1' THEN
                ram(to_integer(unsigned(address))) <= datain(31 DOWNTO 16);
                ram(to_integer(unsigned(address + one))) <= datain(15 DOWNTO 0);

            ELSIF re = '1' THEN
                dataout <= ram(to_integer(unsigned(address))) & ram(to_integer(unsigned(address + one)));
            END IF;
        END IF;
    END PROCESS data_memory;
END ARCHITECTURE;