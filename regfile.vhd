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
        RST : IN STD_LOGIC;
        we : IN STD_LOGIC;
        swap : IN STD_LOGIC;
        address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        datain1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        datain2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;
ARCHITECTURE arch_register_file OF register_file IS
    SIGNAL registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL flag : STD_LOGIC := '1';
BEGIN
    -- Loading data from the file into memory during initialization
    dataout1 <= registers(to_integer(unsigned(address1)));
    dataout2 <= registers(to_integer(unsigned(address2)));

    reg_file : PROCESS (clk, we, datain1, datain2, address1, address2, write_address1, write_address2)
        FILE reg_file : text;
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF (flag = '1' OR RST = '1') THEN
            file_close(reg_file);
            file_open(reg_file, "register.txt");
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
            file_close(reg_file);
        ELSIF clk = '1' THEN
            IF (swap = '1' AND we = '1') THEN
                registers(to_integer(unsigned(write_address1))) <= datain1;
                registers(to_integer(unsigned(write_address2))) <= datain2;
            ELSIF (we = '1') THEN
                registers(to_integer(unsigned(write_address1))) <= datain1;
            END IF;
        END IF;

    END PROCESS;
END ARCHITECTURE;