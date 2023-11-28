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
        address : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        datain1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        datain2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        memory_write : IN STD_LOGIC;
        memory_read : IN STD_LOGIC;
        rti : IN STD_LOGIC;
        ret : IN STD_LOGIC;
        call : IN STD_LOGIC;
        pop : IN STD_LOGIC;
        push : IN STD_LOGIC;
        -- pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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

BEGIN
    -- memory stage
    memory_instance_1 : memory_access PORT MAP(ram, memory_write, memory_read, written_address, written_data(31 DOWNTO 16), dataout(31 DOWNTO 16));
    memory_instance_2 : memory_access PORT MAP(ram, memory_write, memory_read, written_address + one, written_data(15 DOWNTO 0), dataout(15 DOWNTO 0));

    memory : PROCESS
    BEGIN
        --data mux
        IF (call = '1') THEN
            written_data <= pc;
        ELSE
            written_data <= datain;
        END IF;

        --address mux selecto
        address_sel <= ret OR rti OR call OR push OR pop;

        --address mux
        IF (address_sel = '1') THEN
            written_address <= sp(11 DOWNTO 0);
        ELSE
            written_address <= address (11 DOWNTO 0);
        END IF;
        WAIT;
    END PROCESS memory;

END ARCHITECTURE;