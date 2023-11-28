Library ieee;
Use ieee.std_logic_1164.all;

entity alu_stage IS
port (
src1,src2,imm,write_back_data,result_in:IN std_logic_vector(31 downto 0);
forward_unit_signal1,forward_unit_signal2:IN std_logic_vector (1 downto 0);
imm_signal: in std_logic ;
ALU_sig:IN std_logic_vector (3 downto 0);
result_alu: out std_logic_vector (31 downto 0);
flags_alu:out std_logic_vector (3 downto 0)
);
end entity;
Architecture arch_alu_stage of alu_stage IS
signal tmp:std_logic_vector(31 downto 0);
signal src1_alu,src2_alu:std_logic_vector(31 downto 0);

Component mux_3bits IS
port(
    IN1,IN2,IN3:IN std_logic_vector(31 downto 0);
    SEL:IN std_logic_vector (1 downto 0);
    
    SELECTED:OUT std_logic_vector (31 downto 0)
);
end component ;

Component alu IS
port(
    src1,src2:IN std_logic_vector(31 downto 0);
    ALU_signal:IN std_logic_vector (3 downto 0);
    result: out std_logic_vector (31 downto 0);
    flags:out std_logic_vector (3 downto 0)
);
end component ;

BEGIN
tmp<= src2 when imm_signal ='0' else
    imm when imm_signal ='1';
obj1: mux_3bits port map (
src1,result_in,write_back_data,forward_unit_signal1,src1_alu
);
obj2: mux_3bits port map (
tmp,result_in,write_back_data,forward_unit_signal2,src2_alu
);
obj3: alu port map (
src1_alu,src2_alu,ALU_sig,result_alu,flags_alu
);


END architecture;