
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu_stage IS
    PORT (
        clk: in std_logic;
        src1, src2, imm, write_back_data, result_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        forward_unit_signal1, forward_unit_signal2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        imm_signal,out_signal : IN STD_LOGIC;
        ALU_sig : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        out_port: out std_logic_vector (31 downto 0);
        result_alu : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        flags_alu : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_alu_stage OF alu_stage IS
    SIGNAL tmp : STD_LOGIC_VECTOR(31 DOWNTO 0);
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
            clk: in std_logic;
            src1, src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALU_signal : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            flags : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    out_port<= src2 when out_signal='1';
    tmp <= src2 WHEN imm_signal = '0' ELSE
        imm WHEN imm_signal = '1';
    obj1 : mux_3bits PORT MAP(
        src1, result_in, write_back_data, forward_unit_signal1, src1_alu
    );
    obj2 : mux_3bits PORT MAP(
        tmp, result_in, write_back_data, forward_unit_signal2, src2_alu
    );
    obj3 : alu PORT MAP( clk,
        src1_alu, src2_alu, ALU_sig, result_alu, flags_alu
    );
END ARCHITECTURE;