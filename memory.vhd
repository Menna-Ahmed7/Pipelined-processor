LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE std.textio.ALL;

ENTITY memory IS
    PORT (
        clk : IN STD_LOGIC;
        EA : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CCR : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        memory_write : IN STD_LOGIC;
        memory_read : IN STD_LOGIC;
        rti : IN STD_LOGIC;
        ret : IN STD_LOGIC;
        call : IN STD_LOGIC;
        pop : IN STD_LOGIC;
        push : IN STD_LOGIC;
        sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END memory;
ARCHITECTURE arch_memory OF memory IS

    COMPONENT data_memory
        PORT (
            clk : IN STD_LOGIC;
            we : IN STD_LOGIC;
            re : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL one : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL two : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL three : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL written_address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL written_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp : STD_LOGIC;

BEGIN
    one <= (0 => '1', OTHERS => '0');
    two <= (1 => '1', OTHERS => '0');
    three <= (0 => '1', 1 => '1', OTHERS => '0');

    -- memory stage
    memory_instance : data_memory PORT MAP(clk, memory_write, memory_read, written_address, written_data, dataout);

    memory : PROCESS (clk)
    BEGIN
        IF clk'event AND clk = '1' THEN
            written_address <= EA(11 DOWNTO 0);
            written_data <= datain;
            --address mux selector
            temp <= ret OR rti OR call OR push OR pop;

            --address mux
            IF (temp = '1') THEN
                written_address <= sp(11 DOWNTO 0);
            END IF;

            IF (call = '1') THEN
                written_data <= pc + one;

            ELSIF (push = '1') THEN
                written_data <= datain;

            ELSIF (ret = '1') THEN
                next_pc <= dataout;

            ELSIF (rti = '1') THEN
                next_pc <= dataout;

            END IF;

        END IF;
    END PROCESS memory;

END ARCHITECTURE;