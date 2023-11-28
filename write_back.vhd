USE work.my_pkg1.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY write_back IS
    PORT (
        registers : INOUT register_array(0 TO 7)(31 DOWNTO 0);
        dest_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        result_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        result_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memory_read : IN STD_LOGIC;
        write_back : IN STD_LOGIC
    );
END ENTITY;
ARCHITECTURE arch_write_back OF write_back IS

BEGIN
    registers(to_integer(unsigned(dest_address))) <= result;

END ARCHITECTURE;