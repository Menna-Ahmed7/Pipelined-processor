USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;
ENTITY memory IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        EA : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CCR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        memory_write : IN STD_LOGIC;
        memory_read : IN STD_LOGIC;
        rti : IN STD_LOGIC;
        ret : IN STD_LOGIC;
        call : IN STD_LOGIC;
        pop : IN STD_LOGIC;
        push : IN STD_LOGIC;
        sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        prot : IN STD_LOGIC;
        free : IN STD_LOGIC;
        src1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_memory OF memory IS

    COMPONENT data_memory
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
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
    SIGNAL we1 : STD_LOGIC;
    SIGNAL re1 : STD_LOGIC;
    SIGNAL protect : STD_LOGIC_VECTOR(0 TO 4095) := (OTHERS => '0');

BEGIN
    one <= (0 => '1', OTHERS => '0');
    two <= (1 => '1', OTHERS => '0');
    three <= (0 => '1', 1 => '1', OTHERS => '0');

    -- memory stage
    memory_instance : data_memory PORT MAP(clk, RST, we1, re1, written_address, written_data, dataout);

    memory : PROCESS (clk, RST)
        VARIABLE temp : STD_LOGIC;
        VARIABLE address : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF (RST = '1') THEN
            protect <= (OTHERS => '0');
        ELSIF clk'event AND clk = '0' THEN
            out_CCR <= CCR;
            we1 <= '0';
            re1 <= '0';

            written_address <= EA(11 DOWNTO 0);
            address := EA(11 DOWNTO 0);
            written_data <= datain;
            --address mux selector
            temp := ret OR rti OR call OR push OR pop;

            --address mux
            IF (temp = '1') THEN
                written_address <= sp(11 DOWNTO 0);
                address := sp(11 DOWNTO 0);
            END IF;
            --address mux if free
            IF (free = '1') THEN
                written_address <= src1(11 DOWNTO 0);
                address := src1(11 DOWNTO 0);
                written_data <= (OTHERS => '0');
            END IF;

            IF (prot = '1') THEN
                protect(to_integer(unsigned(src1))) <= '1';

            ELSIF (free = '1') THEN
                protect(to_integer(unsigned(src1))) <= '0';

            ELSIF (call = '1') THEN
                written_data <= pc;

            ELSIF (push = '1') THEN
                written_data <= datain;

            ELSIF (ret = '1') THEN
                next_pc <= dataout;

            ELSIF (rti = '1') THEN
                next_pc <= dataout;

            END IF;

        END IF;
        IF (memory_write = '1' AND (protect(to_integer(unsigned(address))) = '1' OR protect(to_integer(unsigned(address + one))) = '1')) THEN
            we1 <= '0';
        ELSE
            we1 <= memory_write;
        END IF;
        re1 <= memory_read;
    END PROCESS memory;

END ARCHITECTURE;