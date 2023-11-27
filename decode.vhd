USE work.my_pkg1.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY decode IS
    PORT (
        registers : IN register_array(0 TO 6)(31 DOWNTO 0); 
        src1:IN std_logic_vector(2 downto 0);
        src2:IN std_logic_vector(2 downto 0);
        src2_data:OUT std_logic_vector(31 downto 0);
        src1_data:OUT std_logic_vector(31 downto 0)
    );
END ENTITY;
ARCHITECTURE arch_decode OF decode IS

BEGIN

  src1_data<=registers(to_integer(unsigned(src1)));
  src2_data<=registers(to_integer(unsigned(src2)));


END ARCHITECTURE;
