USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE std.textio.ALL;
USE IEEE.numeric_std.ALL;
ENTITY memoryAccess IS
    PORT (

        ram : IN memory_array(0 TO 4095)(15 DOWNTO 0);
        we : IN STD_LOGIC;
        re : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY memoryAccess;
ARCHITECTURE sync_memoryAccess OF memoryAccess IS
    SIGNAL temp : memory_array(0 TO 4095)(15 DOWNTO 0);
BEGIN
    temp <= ram;
    PROCESS (we, re, address, datain) IS
    BEGIN
        IF we = '1' THEN
            temp(to_integer(unsigned(address))) <= datain;

        ELSIF re = '1' THEN
            dataout <= ram(to_integer(unsigned(address)));
        END IF;
    END PROCESS;
END sync_memoryAccess;