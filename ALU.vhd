LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE std.STANDARD.NATURAL;
USE ieee.numeric_std.ALL;
--Entity B
ENTITY alu IS
    PORT (
        src1, src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_signal : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        CCR : INOUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_alu OF alu IS
    SIGNAL one : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL zero : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL final_result : STD_LOGIC_VECTOR(32 DOWNTO 0);
BEGIN
    alu_unit : PROCESS (src1, src2, ALU_signal)
    BEGIN
        zero <= (OTHERS => '0');
        one <= (0 => '1', OTHERS => '0');
        -- temp <= (to_integer(unsigned(src2)) => '1', OTHERS => '0');
        -- FOR i IN 0 TO 31 LOOP
        --     IF (i = to_integer(unsigned(src2))) THEN
        --         src1(i) <= '1';
        --     END IF;
        -- END LOOP;
        src2 <= resize(signed(src2), 33);
        final_result <= NOT src2 WHEN ALU_signal = "0001" ELSE
            zero - src2 WHEN ALU_signal = "0010" ELSE
            src2 + one WHEN ALU_signal = "0011" ELSE
            src2 - one WHEN ALU_signal = "0100" ELSE
            src2 + src1 WHEN ALU_signal = "0111" ELSE
            src1 - src2 WHEN ALU_signal = "1000" ELSE
            src1 AND src2 WHEN ALU_signal = "1001" ELSE
            src1 OR src2 WHEN ALU_signal = "1010" ELSE
            src1 XOR src2 WHEN ALU_signal = "1011";
        -- src1 OR te        src1((31 - unsigned(src2)      
        -- src1((31 - to_integer(unsigned(src2))) DOWNTO 0) & src1((31 - to_integer(unsigned(src2)) + 1) TO 31) WHEN ALU_signal = "1101" ELSE
        -- src1(0 TO (to_integer(unsigned(src2)) - 1)) & src1(31 DOWNTO to_integer(unsigned(src2))) WHEN ALU_signal = "1110" ;

        IF (result(31) = '0') THEN
            CCR(1) <= '0';
        ELSE
            CCR(1) <= '1';
        END IF;
        IF (result = zero(31 DOWNTO 0)) THEN
            CCR(0) <= '1';
        ELSE
            CCR(0) <= '0';
        END IF;
    END PROCESS;
    CCR(2) <= final_result(32);
    result <= final_result(31 DOWNTO 0);
END ARCHITECTURE;