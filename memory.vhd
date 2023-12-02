
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
        ram : INOUT memory_array(0 TO 4095)(15 DOWNTO 0);
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

    COMPONENT memory_access
        PORT (
            ram : IN memory_array(0 TO 4095)(15 DOWNTO 0);
            we : IN STD_LOGIC;
            re : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL one : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL two : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL three : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL written_address1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL written_address2 : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL written_address3 : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL written_data1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL written_data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL dataout2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_write3_sel : STD_LOGIC;
    SIGNAL memory_read3_sel : STD_LOGIC;
    SIGNAL temp : STD_LOGIC;
    SIGNAL datatemp : STD_LOGIC;

BEGIN
    one <= (0 => '1', OTHERS => '0');
    two <= (1 => '1', OTHERS => '0');
    three <= (0 => '1', 1 => '1', OTHERS => '0');

    -- memory stage
    memory_instance_1 : memory_access PORT MAP(ram, memory_write, memory_read, written_address1(11 DOWNTO 0), written_data1(31 DOWNTO 16), dataout1(31 DOWNTO 16));
    memory_instance_2 : memory_access PORT MAP(ram, memory_write, memory_read, written_address2(11 DOWNTO 0), written_data1(15 DOWNTO 0), dataout1(15 DOWNTO 0));
    memory_instance_3 : memory_access PORT MAP(ram, memory_write3_sel, memory_read3_sel, written_address3(11 DOWNTO 0), written_data2(15 DOWNTO 0), dataout2(15 DOWNTO 0));

    memory : PROCESS
    BEGIN
       
        written_address1 <= (OTHERS => '0');
        written_address2 <= (OTHERS => '0');
        written_address3 <= (OTHERS => '0');
        written_data1 <= (OTHERS => '0');
        written_data2 <= "0000000000000"&CCR;
        dataout2 <= (OTHERS => '0');
        memory_write3_sel <= '0';
        memory_read3_sel <= '0';

        --address mux selecto
        temp <= ret OR rti OR call OR push OR pop;

        --address mux
        IF (temp = '1') THEN
            written_address1 <= sp(19 DOWNTO 0);
        ELSE
            written_address1 <= EA (19 DOWNTO 0);
        END IF;

        IF (call = '1') THEN
            written_data1 <= pc;
            written_data2 <= "0000000000000" & CCR;
            memory_write3_sel <= '1';
            written_address2 <= written_address1 - one;
            written_address3 <= written_address1 - two;

        ELSIF (push = '1') THEN
            written_data1 <= datain;
            written_address2 <= written_address1 - one;
            written_address3 <= written_address1 - two;

        ELSIF (pop = '1') THEN
            written_data1 <= datain;
            written_address1 <= written_address1 + one;
            written_address2 <= written_address1 + two;

        ELSIF (ret = '1') THEN
            written_data1 <= datain;
            memory_read3_sel <= '1';
            written_address1 <= written_address1 + one;
            written_address2 <= written_address1 + two;
            written_address3 <= written_address1 + three;
            next_pc <= dataout1;

        ELSIF (rti = '1') THEN
            written_data1 <= datain;
            memory_read3_sel <= '1';
            written_address1 <= written_address1 + one;
            written_address2 <= written_address1 + two;
            written_address3 <= written_address1 + three;
            next_pc <= dataout1;
            CCR <= dataout2(2 DOWNTO 0);

        END IF;
        WAIT;
    END PROCESS memory;

END ARCHITECTURE;