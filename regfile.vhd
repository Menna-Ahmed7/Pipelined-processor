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
        clk : IN STD_LOGIC;
        we : IN STD_LOGIC;
        address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;
ARCHITECTURE arch_register_file OF register_file IS
    SIGNAL registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL intilization : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL flag : STD_LOGIC := '1';
BEGIN
    -- intiliaze : reg_intiliaze PORT MAP(intilization);
    -- Loading data from the file into memory during initialization
    dataout1 <= registers(to_integer(unsigned(address1)));
    dataout2 <= registers(to_integer(unsigned(address2)));

    -- tr : PROCESS (we, datain, address1)
    -- BEGIN
    --     IF clk = '1' THEN
    --         IF (we = '1') THEN
    --             registers(to_integer(unsigned(address1))) <= datain;
    --         END IF;
    --     END IF;

    -- END PROCESS;
    -- registers(to_integer(unsigned(address1))) <= datain WHEN clk = '1'AND we = '1'

    ---intilizate out

    reg_file : PROCESS (clk, we, datain, address1)
        FILE reg_file : text OPEN READ_MODE IS "register.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF (flag = '1') THEN

            FOR i IN registers'RANGE LOOP
                IF NOT endfile(reg_file) THEN
                    readline(reg_file, file_line);
                    read(file_line, temp_data);
                    registers(i) <= temp_data;
                ELSE
                    file_close(reg_file);

                END IF;
            END LOOP;
            flag <= '0';
        ELSIF clk = '1' THEN
            IF (we = '1') THEN
                registers(to_integer(unsigned(write_address))) <= datain;
            END IF;
        END IF;

    END PROCESS;
END ARCHITECTURE;