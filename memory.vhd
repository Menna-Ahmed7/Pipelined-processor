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
        push_pc : IN STD_LOGIC;
        get_pc_int : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        alu_flags : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        pop_flags : IN STD_LOGIC;
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
        prot : IN STD_LOGIC;
        free : IN STD_LOGIC;
        next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        flush2 : OUT STD_LOGIC;
        flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        out_pop_flags : OUT STD_LOGIC;
        out_get_int : OUT STD_LOGIC
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
    SIGNAL sp : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111111";

BEGIN
    one <= (0 => '1', OTHERS => '0');
    two <= (1 => '1', OTHERS => '0');
    three <= (0 => '1', 1 => '1', OTHERS => '0');

    -- memory stage
    memory_instance : data_memory PORT MAP(clk, RST, we1, re1, written_address, written_data, dataout);

    memory : PROCESS (clk, RST)
        VARIABLE temp : STD_LOGIC;
        VARIABLE temp_sp : STD_LOGIC_VECTOR(11 DOWNTO 0);
        VARIABLE address : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF (RST = '1') THEN
            protect <= (OTHERS => '0');
        ELSIF clk'event AND clk = '0' THEN
            temp_sp := sp(11 DOWNTO 0);
            out_CCR <= CCR;
            we1 <= '0';
            re1 <= '0';

            written_address <= EA(11 DOWNTO 0);
            address := EA(11 DOWNTO 0);
            written_data <= datain;
            --address mux selector
            temp := ret OR rti OR call OR push OR pop OR pop_flags OR push_pc OR interrupt;
            --address mux if free
            IF (free = '1') THEN
                written_address <= datain(11 DOWNTO 0);
                address := datain(11 DOWNTO 0);
                written_data <= (OTHERS => '0');
                protect(to_integer(unsigned(datain))) <= '0';
            END IF;

            IF (prot = '1') THEN
                protect(to_integer(unsigned(datain))) <= '1';
                --call
            ELSIF (call = '1') THEN
                written_data <= pc;
                sp <= sp - two;
                temp_sp := sp(11 DOWNTO 0) - one;
                --interupt
            ELSIF (interrupt = '1') THEN
                written_data <= "0000000000000000000000000000" & alu_flags;
                sp <= sp - two;
                temp_sp := sp(11 DOWNTO 0) - one;
                --push_pc
            ELSIF (push_pc = '1') THEN
                written_data <= pc - two;
                sp <= sp - two;
                temp_sp := sp(11 DOWNTO 0) - one;
                --get_pc_int
            ELSIF (get_pc_int = '1') THEN
                written_address <= two;
                --push
            ELSIF (push = '1') THEN
                written_data <= datain;
                sp <= sp - two;
                temp_sp := sp(11 DOWNTO 0) - one;
                -- pop
            ELSIF (pop = '1') THEN
                sp <= sp + two;
                temp_sp := sp(11 DOWNTO 0) + one;
                --ret
            ELSIF (ret = '1') THEN
                sp <= sp + two;
                temp_sp := sp(11 DOWNTO 0) + one;
                --rti
            ELSIF (rti = '1') THEN
                sp <= sp + two;
                temp_sp := sp(11 DOWNTO 0) + one;
                --pop_flags
            ELSIF (pop_flags = '1') THEN
                sp <= sp + two;
                temp_sp := sp(11 DOWNTO 0) + one;
            END IF;

            --address mux
            IF (temp = '1') THEN
                written_address <= temp_sp(11 DOWNTO 0);
                address := temp_sp(11 DOWNTO 0);
            END IF;

            IF (ret = '1' OR rti = '1') THEN
                flush2 <= '1';
            ELSE
                flush2 <= '0';
            END IF;

        END IF;
        IF (memory_write = '1' AND (protect(to_integer(unsigned(address))) = '1' OR protect(to_integer(unsigned(address + one))) = '1')) THEN
            we1 <= '0';
        ELSIF (push_pc = '1' OR interrupt = '1') THEN
            we1 <= '1';
        ELSE
            we1 <= memory_write;
        END IF;

        IF (pop_flags = '1' OR get_pc_int = '1') THEN
            re1 <= '1';
        ELSE
            re1 <= memory_read;
        END IF;

    END PROCESS memory;

    next_pc <= dataout - one WHEN rti = '1'
        ELSE
        dataout WHEN get_pc_int = '1'
        ELSE
        dataout;

    flags <= dataout(3 DOWNTO 0);
    out_pop_flags <= pop_flags WHEN clk = '1';
    out_get_int <= get_pc_int;
END ARCHITECTURE;