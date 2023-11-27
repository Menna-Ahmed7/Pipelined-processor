use work.my_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
USE IEEE.numeric_std.all;
ENTITY memory_access IS
PORT (
 ram : IN  memory_array(0 to 4095)(15 downto 0);
 write_en : IN std_logic;
read_en : IN std_logic; 
address : IN std_logic_vector(5 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0 ));
END ENTITY ;


ARCHITECTURE arch_memory_access OF memory_access IS
signal temp :memory_array(0 to 4095)(15 downto 0);
BEGIN
temp<=ram;
PROCESS(write_en,read_en,datain,address) IS
BEGIN


 IF write_en = '1' THEN
temp(to_integer(unsigned(address))) <= datain;
ELSIF read_en = '1' THEN
dataout <= ram(to_integer(unsigned(address)));
END IF;


END PROCESS; 
END ARCHITECTURE;


