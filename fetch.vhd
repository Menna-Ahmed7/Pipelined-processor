USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY fetch IS
    PORT (
        ram : IN memory_array(0 TO 4095)(15 DOWNTO 0); 
        pc : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        jmporcall: out std_logic ;
        address: out std_logic_vector(31 downto 0)
    );
END Fetch;
ARCHITECTURE arch_fetch OF fetch IS
signal one:std_logic_vector(31 downto 0);
signal sel:std_logic;

BEGIN
one<=(0=>'1', Others => '0');

    PROCESS (pc) IS
    BEGIN
            instruction(31 downto 16) <= ram(to_integer(unsigned(pc)));
            instruction(15 downto 0) <= ram(to_integer(unsigned(pc+one)));
            if instruction(31 downto 22) = "100000001" or instruction(31 downto 22)= "100000010" then 
                    jmporcall<='1';
                    address<=instruction(21 downto 19);
                
            else 
                 jmporcall<='0';
                address<=(others=>'0');

                end if;



    END PROCESS;


END ARCHITECTURE;
