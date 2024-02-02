LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE std.STANDARD.NATURAL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
--Entity B
ENTITY alu IS
    PORT (
        
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        pop_flags : IN STD_LOGIC;
        memory_flags : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        src1, src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_signal : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        flags : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        iow_signal : IN STD_LOGIC;
        ior_signal : IN STD_LOGIC;
        out_port : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        in_port : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        imm_signal : IN STD_LOGIC;
        out_src1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_alu OF alu IS
    SIGNAL one : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL zero : STD_LOGIC_VECTOR(32 DOWNTO 0);
    -- SIGNAL temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp_result : STD_LOGIC_VECTOR (32 DOWNTO 0);
    SIGNAL temp : STD_LOGIC_VECTOR (32 DOWNTO 0);
    SIGNAL temp_src2 : STD_LOGIC_VECTOR (32 DOWNTO 0);
    SIGNAL temp_src1 : STD_LOGIC_VECTOR (32 DOWNTO 0);
    SIGNAL sign_imm : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL My_flags : STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN
    sign_imm <= (OTHERS => imm(15));
    -- temp_src2 <= src2(31) & src2;
    -- temp_src1 <= src1(31) & src1;
    temp_src2 <= '0' & src2;
    temp_src1 <= '0' & src1;
    zero <= (OTHERS => '0');
    one <= (0 => '1', OTHERS => '0');
    temp <= (OTHERS => '0');
    -- temp(to_integer(unsigned(temp_src2))) <= '1';
    temp_result <= NOT temp_src2 WHEN ALU_signal = "0001" ELSE
        zero - temp_src2 WHEN ALU_signal = "0010" ELSE
        temp_src2 + one WHEN ALU_signal = "0011" ELSE
        temp_src2 - one WHEN ALU_signal = "0100" ELSE
        temp_src1 + temp_src2 WHEN ALU_signal = "0111" ELSE
        temp_src1 - temp_src2 WHEN ALU_signal = "1000" ELSE
        temp_src1 AND temp_src2 WHEN ALU_signal = "1001" ELSE
        temp_src1 OR temp_src2 WHEN ALU_signal = "1010" ELSE
        temp_src1 XOR temp_src2 WHEN ALU_signal = "1011";
    -- temp_src1 or temp  when  ALU_signal="1011" ELSE
    -- temp_src2(0)&temp_src2(31 downto 1)  when  ALU_signal="1101" ELSE
    -- temp_src2(30 downto 0)&temp_src2(31)  when  ALU_signal="1100";
    alu_unit : PROCESS (clk, RST)
        VARIABLE carry : STD_LOGIC;
        VARIABLE temp : STD_LOGIC_VECTOR (31 DOWNTO 0);
        VARIABLE temp_carry : STD_LOGIC;
        VARIABLE temp_carry2 : STD_LOGIC;
    BEGIN
        IF (RST = '1') THEN
            result <= (OTHERS => '0');
            -- flags <= (OTHERS => '0');
            My_flags <= (OTHERS => '0');
        ELSIF clk'event AND clk = '0' THEN
            out_port <= src1 WHEN iow_signal = '1';
            result <= temp_result(31 DOWNTO 0);

            --------------------
            IF (ior_signal = '1') THEN
                result <= in_port;
            ELSIF (ALU_signal = "0000" AND imm_signal = '1') THEN
                result <= (sign_imm & imm);
            ELSIF (ALU_signal = "0101") THEN
                result <= src2;
            END IF;

            IF NOT (ALU_signal = "0001" OR ALU_signal = "1001" OR ALU_signal = "1010" OR ALU_signal = "1011") THEN
                carry := temp_result(32);
            END IF;

            -- flags(2) <= NOT flags(2) WHEN ALU_signal = "0010" AND ALU_signal = "0100" AND ALU_signal = "1000";
            IF temp_result(31 DOWNTO 0) = "00000000000000000000000000000000" AND alu_signal /= "0000" THEN

                My_flags(0) <= '1';
            ELSIF ALU_signal /= "0000" THEN

                My_flags(0) <= '0';
            END IF;
            IF (ALU_signal /= "0000") THEN
                IF temp_result(31) = '1' THEN
                    -- flags(1) <= '1';
                    My_flags(1) <= '1';
                ELSE
                    -- flags(1) <= '0';
                    My_flags(1) <= '0';
                END IF;
            END IF;

            ------------------------------------------------------
            ----bitset
            IF (ALU_signal = "1100") THEN
                temp := src1;
                FOR i IN 1 TO 31 LOOP
                    IF (src2 = i) THEN
                        -- flags(2) <= temp(i);
                        My_flags(2) <= temp(i);
                        temp(i) := '1';
                    END IF;
                END LOOP;
                result <= temp;
            END IF;
            ------------------------------------------------------
            ----RCR
            IF (ALU_signal = "1110") THEN
                temp := src1;
                IF (src2 = "0000000000000000000000000000000") THEN
                    result <= temp;
                END IF;
                IF (src2 > "0000000000000000000000000000000") THEN
                    temp_carry2 := My_flags(2);
                    FOR i IN 1 TO to_integer(unsigned(src2)) LOOP
                        temp_carry := temp(0);
                        temp := temp_carry2 & temp(31 DOWNTO 1);
                        temp_carry2 := temp_carry;
                    END LOOP;
                    result <= temp;
                END IF;
            END IF;
            ------------------------------------------------------
            ----RCl
            IF (ALU_signal = "1101") THEN
                temp := src1;
                IF (src2 = "0000000000000000000000000000000") THEN
                    result <= temp;
                END IF;
                IF (src2 > "0000000000000000000000000000000") THEN
                    temp_carry2 := My_flags(2);
                    FOR i IN 1 TO to_integer(unsigned(src2)) LOOP
                        temp_carry := temp(31);
                        temp := temp(30 DOWNTO 0) & temp_carry2;
                        temp_carry2 := temp_carry;
                    END LOOP;
                    result <= temp;
                END IF;
            END IF;
            ------------------------------------------------------
            -- flags(0) <= '1' WHEN temp_result(31 DOWNTO 0) = "00000000000000000000000000000000";
            -- flags(1) <= '1' WHEN temp_result(31) = '1';
            --not signal has no carry or sign flag
            IF (ALU_signal /= "0000") THEN
                IF ALU_signal = "0010" OR ALU_signal = "1000" OR ALU_signal = "0100" THEN
                    My_flags(2) <= NOT carry;
                ELSIF ALU_signal = "0011" OR ALU_signal = "0111" THEN
                    My_flags(2) <= carry;

                ELSIF ALU_signal = "1110" OR ALU_signal = "1101" THEN
                    -- flags(2) <= temp_carry2;
                    My_flags(2) <= temp_carry2;

                END IF;
            END IF;
            ------------------------------------------------------

            --0 ->zero flag
            --1 -> sign flag
            --2 -> carry flag
        END IF;
        IF (pop_flags = '1') THEN
            My_flags <= memory_flags;
        END IF;

        out_src1 <= src1;
    END PROCESS;

    flags <= memory_flags WHEN pop_flags = '1' ELSE
        My_flags;

END ARCHITECTURE;
