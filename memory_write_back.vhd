LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.reg.ALL;
ENTITY memory_write_back IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        out_out_memory_read : IN STD_LOGIC;
        out_out_write_back : IN STD_LOGIC;
        out_out_reg_dest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_result_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CCR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        dataout : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_out_out_memory_read : OUT STD_LOGIC;
        out_out_out_write_back : OUT STD_LOGIC;
        out_out_out_reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_out_result_alu : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_memory_write_back OF memory_write_back IS
BEGIN
    memory_write_back_pipeline : PROCESS (clk, RST)
    BEGIN
        IF RST = '1' THEN
            out_out_out_memory_read <= '0';
            out_out_out_write_back <= '0';
            out_out_out_reg_dest <= (OTHERS => '0');
            out_out_result_alu <= (OTHERS => '0');
            out_dataout <= (OTHERS => '0');
            out_CCR <= "000";

        ELSIF clk'event AND clk = '1' THEN
            out_CCR <= CCR;
            out_out_out_memory_read <= out_out_memory_read;
            out_out_out_write_back <= out_out_write_back;
            out_out_out_reg_dest <= out_out_reg_dest;
            out_out_result_alu <= out_result_alu;
            out_dataout <= dataout;
        END IF;
    END PROCESS;
END ARCHITECTURE;