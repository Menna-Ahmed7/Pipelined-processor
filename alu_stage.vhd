
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu_stage IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        src1, src2, write_back_data, result_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        forward_unit_signal1, forward_unit_signal2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        imm_signal, iow_signal : IN STD_LOGIC;
        ALU_sig : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        out_port : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        result_alu : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        flags_alu : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_alu_stage OF alu_stage IS
    SIGNAL tmp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tmp_imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL src1_alu, src2_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);

    COMPONENT mux_3bits IS
        PORT (
            IN1, IN2, IN3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

            SELECTED : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT alu IS
        PORT (
            clk : IN STD_LOGIC;
            src1, src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALU_signal : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            flags : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            iow_signal : IN STD_LOGIC;
            out_port : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    tmp_imm <= "0000000000000000" & imm;
    tmp <= src2 WHEN imm_signal = '0' ELSE
        tmp_imm WHEN imm_signal = '1';
    obj1 : mux_3bits PORT MAP(
        src1, result_in, write_back_data, forward_unit_signal1, src1_alu
    );
    obj2 : mux_3bits PORT MAP(
        tmp, result_in, write_back_data, forward_unit_signal2, src2_alu
    );
    obj3 : alu PORT MAP(
        clk,
        src1_alu, src2_alu, ALU_sig, result_alu, flags_alu, iow_signal, out_port
    );
END ARCHITECTURE;