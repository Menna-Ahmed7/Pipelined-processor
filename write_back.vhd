USE work.reg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY write_back IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        memory_read : IN STD_LOGIC;
        write_back : IN STD_LOGIC;
        -- registers : INOUT registers_block(0 TO 7)(31 DOWNTO 0);
        dest_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        data_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        src1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        -- out_registers : OUT registers_block(0 TO 7)(31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_write_back OF write_back IS
BEGIN
    dataout1 <= (OTHERS => '0') WHEN RST = '1'ELSE
        data_memory WHEN memory_read = '1'
        ELSE
        data_alu;
    dataout2 <= src1;
END ARCHITECTURE;