USE work.my_pkg1.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY decode IS
    PORT (
        registers : INOUT register_array(0 TO 6)(31 DOWNTO 0); 
        dest_address:IN std_logic_vector(2 downto 0);
        result:IN std_logic_vector(31 downto 0)
    );
END ENTITY;
ARCHITECTURE arch_decode OF decode IS

BEGIN
registers(to_integer(unsigned(dest_address)))<=result;

END ARCHITECTURE;

