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
        dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END memory;
ARCHITECTURE arch_memory OF memory IS

    COMPONENT data_memory
        PORT (
            clk : IN STD_LOGIC;
            we1 : IN STD_LOGIC;
            we2 : IN STD_LOGIC;
            re1 : IN STD_LOGIC;
            re2 : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            stack_memory : IN STD_LOGIC;
            datain2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
        );
    END COMPONENT;

    SIGNAL one : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL two : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL three : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL written_address : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL written_data1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL written_data2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory_read2 : STD_LOGIC;
    SIGNAL temp : STD_LOGIC;
    SIGNAL datatemp : STD_LOGIC;
    SIGNAL dataout2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    one <= (0 => '1', OTHERS => '0');
    two <= (1 => '1', OTHERS => '0');
    three <= (0 => '1', 1 => '1', OTHERS => '0');

    -- memory stage
    memory_instance_1 : data_memory PORT MAP(clk, memory_write, call, memory_read, memory_read2, written_address(11 DOWNTO 0), written_data1, temp, written_data2, dataout1, dataout2);

    memory : PROCESS (clk)
    BEGIN
        IF clk'event AND clk = '1' THEN
            written_data1 <= (OTHERS => '0');
            written_data2 <= (0 => CCR(0), 1 => CCR(1), 2 => CCR(2), OTHERS => '0');
            dataout2 <= (OTHERS => '0');
            memory_read2 <= '0';

            --address mux selector
            temp <= ret OR rti OR call OR push OR pop;

            --address mux
            IF (temp = '1') THEN
                written_address <= sp(19 DOWNTO 0);
            ELSE
                written_address <= EA;
            END IF;

            IF (call = '1') THEN
                written_data1 <= pc;

            ELSIF (push = '1') THEN
                written_data1 <= datain;

            ELSIF (pop = '1') THEN
                written_data1 <= datain;

            ELSIF (ret = '1') THEN
                memory_read2 <= '1';
                next_pc <= dataout1;

            ELSIF (rti = '1') THEN
                memory_read2 <= '1';
                next_pc <= dataout1;
                CCR <= dataout2(2 DOWNTO 0);

            END IF;

        END IF;
    END PROCESS memory;

END ARCHITECTURE;