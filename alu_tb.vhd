


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ALU_tb IS
END ENTITY;

ARCHITECTURE arch_ALU_tb OF ALU_tb IS

component alu_stage
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
end component;


SIGNAL src1_tb, src2_tb,imm_tb,  write_back_data_tb,result_in_tb : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL forward_unit_signal1_tb, forward_unit_signal2_tb : STD_LOGIC_VECTOR (1 DOWNTO 0);
SIGNAl imm_signal_tb: STD_LOGIC;
SIGNAl out_signal_tb: STD_LOGIC; 
SIGNAl  out_port_tb:  std_logic_vector (31 downto 0);
SIGNAl ALU_sig_tb:  STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAl result_alu_tb :  STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAl flags_alu_tb :  STD_LOGIC_VECTOR (3 DOWNTO 0);
signal clk: std_logic :='0';


BEGIN

obj: alu_stage PORT MAP(
    clk,
    src1_tb, src2_tb, imm_tb, write_back_data_tb,result_in_tb,
    forward_unit_signal1_tb, forward_unit_signal2_tb,
    imm_signal_tb, out_signal_tb, ALU_sig_tb,  out_port_tb, result_alu_tb ,flags_alu_tb 
);

PROCESS
BEGIN
-- Test case NOT
src1_tb<="00000000000000000000000000000000";
src2_tb<="00000000000000000000000000000000";
imm_tb<="00000000000000000000000000000000";
ALU_sig_tb<="0001";
write_back_data_tb<="00000000000000000000000000000000";
result_in_tb<="00000000000000000000000000000000";
forward_unit_signal1_tb<="00";
forward_unit_signal2_tb<="00";
imm_signal_tb<='0';
out_signal_tb<='0';
wait for 10 ns;
assert (result_alu_tb = "11111111111111111111111111111111" and flags_alu_tb ="0010")  severity error;


-- Test case zero-src2 -> (0-9)
src1_tb<="00000000000000000000000000000000";
src2_tb<="00000000000000000000000000001001";
imm_tb<="00000000000000000000000000000000";
ALU_sig_tb<="0010";
write_back_data_tb<="00000000000000000000000000000000";
result_in_tb<="00000000000000000000000000000000";
forward_unit_signal1_tb<="00";
forward_unit_signal2_tb<="00";
imm_signal_tb<='0';
out_signal_tb<='0';
wait for 10 ns;
assert (result_alu_tb = "11111111111111111111111111111001" and flags_alu_tb ="0110")  severity error;
-- -- Test case 2
-- AALU <= "11110000";
-- BALU <= "10110000";
-- S <="0001";
-- Cin <= '0';
-- wait for 10 ns;
-- assert (F = "10100000" and Cout ='1') severity error;

-- -- Test case 3
-- AALU <= "11110000";
-- BALU <= "10110000";
-- S <="0010";
-- Cin <= '0';
-- wait for 10 ns;
-- assert (F = "00111111" and Cout ='1') severity error;



END PROCESS;

END ARCHITECTURE;