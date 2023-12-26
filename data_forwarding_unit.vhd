LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY data_forwarding IS
    PORT (
        source1_reg_num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        source2_reg_num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        dest_before_reg_num1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        dest_before_before_reg_num1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

        dest_before_reg_num2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        dest_before_before_reg_num2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

        source1_signal : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        source2_signal : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

        alu_write_back : IN STD_LOGIC;
        memory_write_back : IN STD_LOGIC;

        swap_alu : IN STD_LOGIC;
        swap_memory : IN STD_LOGIC;

        read_src1 : IN STD_LOGIC;
        read_src2 : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE data_forwarding_arch OF data_forwarding IS
BEGIN

    source1_signal <= "001" WHEN source1_reg_num = dest_before_reg_num1 AND read_src1 = '1' AND alu_write_back = '1' ELSE
        "010" WHEN source1_reg_num = dest_before_reg_num2 AND read_src1 = '1' AND swap_alu = '1' ELSE
        "011" WHEN source1_reg_num = dest_before_before_reg_num1 AND read_src1 = '1' AND memory_write_back = '1'ELSE
        "100" WHEN source1_reg_num = dest_before_before_reg_num2 AND read_src1 = '1' AND swap_memory = '1'ELSE
        "000";

    -----------------------------------------------------------
    source2_signal <= "001" WHEN source2_reg_num = dest_before_reg_num1 AND read_src2 = '1' AND alu_write_back = '1' ELSE
        "010" WHEN source2_reg_num = dest_before_reg_num2 AND read_src2 = '1' AND swap_alu = '1' ELSE
        "011" WHEN source2_reg_num = dest_before_before_reg_num1 AND read_src2 = '1' AND memory_write_back = '1'ELSE
        "100" WHEN source2_reg_num = dest_before_before_reg_num2 AND read_src2 = '1' AND swap_memory = '1'ELSE
        "000";

END ARCHITECTURE;