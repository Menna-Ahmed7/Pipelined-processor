USE work.my_pkg1.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY decode IS
  PORT (
    registers : IN register_array(0 TO 7)(31 DOWNTO 0);
    src1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    src2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    src2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    src1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END ENTITY;
ARCHITECTURE arch_decode OF decode IS

BEGIN

  src1_data <= registers(to_integer(unsigned(src1)));
  src2_data <= registers(to_integer(unsigned(src2)));
END ARCHITECTURE;