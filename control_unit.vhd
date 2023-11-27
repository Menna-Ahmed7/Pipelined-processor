USE work.my_pkg1.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY decode IS
    PORT (
        opcode : IN std_logic_vector(8 DOWNTO 0); 
        alu_signal:OUT std_logic_vector(3 downto 0);
        memory_read:out std_logic;
        memory_write:out std_logic;
        write_back:out std_logic;
        read_src1:out std_logic;
        read_src2:out std_logic;
        read_dest:out std_logic;
        reg_dest_selector:out std_logic_vector(1 downto 0);
        io_read:out std_logic;
        io_write:out std_logic;
        push:out std_logic;
        pop:out std_logic;
        swap:out std_logic;
        imm:out std_logic;
        branch:out std_logic;
        RTI:out std_logic;
        RET:out std_logic;
        call:out std_logic;
        jz:out std_logic;
    );
END ENTITY;
ARCHITECTURE arch_decode OF decode IS

BEGIN
alu_signal<="0000";
memory_read<='0';
memory_write<='0';
write_back<='0';
read_src1<='0';
read_src2<='0';
read_dest<='0';
reg_dest_selector<="00";
io_read<='0';
io_write<='0';
push<='0';
pop<='0';
swap<='0';
imm<='0';
branch<='0';
RTI<='0';
RET<='0';
call<='0';
jz<='0';
process(opcode)

if opcode="010000000" then 

elsif opcode="010000001" then 
elsif opcode="010000010" then 
elsif opcode="010000011" then 

elsif opcode="011000100" then 
elsif opcode="010100101" then 
elsif opcode="010100110" then 
elsif opcode="010100111" then 
elsif opcode="010101000" then 
elsif opcode="010101001" then 
elsif opcode="010111010" then 
elsif opcode="010100001" then 
elsif opcode="010000001" then 
elsif opcode="010000001" then 
elsif opcode="010000001" then 
 

end if;
end process;
END ARCHITECTURE;

