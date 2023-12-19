LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE std.STANDARD.NATURAL;
USE ieee.numeric_std.ALL;
--Entity B
ENTITY alu IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        src1, src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_signal : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        flags : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        iow_signal : IN STD_LOGIC;
        ior_signal : IN STD_LOGIC;
        out_port : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        in_port : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        imm_signal : IN STD_LOGIC
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
BEGIN
    sign_imm <= (OTHERS => imm(15));
    temp_src2 <= src2(31) & src2;
    temp_src1 <= src1(31) & src1;
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
    BEGIN
        IF (RST = '1') THEN
            result <= (OTHERS => '0');
            flags <= (OTHERS => '0');
        ELSIF clk'event AND clk = '0' THEN
            out_port <= src1 WHEN iow_signal = '1';
            result <= in_port WHEN ior_signal = '1';
            result <= temp_result(31 DOWNTO 0);
            result <= (sign_imm & imm) WHEN ALU_signal = "0000" AND imm_signal = '1';
            result <= src2 WHEN ALU_signal = "0101";
            -- flags(2) <= temp_result(32);
            carry := temp_result(32);
            -- flags(2) <= NOT flags(2) WHEN ALU_signal = "0010" AND ALU_signal = "0100" AND ALU_signal = "1000";
            IF temp_result(31 DOWNTO 0) = "00000000000000000000000000000000" THEN
                flags(0) <= '1';
            ELSE
                flags(0) <= '0';
            END IF;

            IF temp_result(31) = '1' THEN
                flags(1) <= '1';
            ELSE
                flags(1) <= '0';
            END IF;
            -- flags(0) <= '1' WHEN temp_result(31 DOWNTO 0) = "00000000000000000000000000000000";
            -- flags(1) <= '1' WHEN temp_result(31) = '1';
            --not signal has no carry or sign flag
            IF ALU_signal = "0001" OR ALU_signal = "1001" OR ALU_signal = "1010" OR ALU_signal = "1011" OR ALU_signal = "0100" OR ALU_signal = "0011"THEN
                flags(2) <= '0';
            ELSIF ALU_signal = "0010" OR ALU_signal = "1000" THEN
                flags(2) <= NOT carry;
            ELSE
                flags(2) <= temp_result(32);

                --0 ->zero flag
                --1 -> sign flag
                --2 -> carry flag
            END IF;
        END IF;

    END PROCESS;
END ARCHITECTURE;