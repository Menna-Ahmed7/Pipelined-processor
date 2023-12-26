LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY data_forwarding IS
    PORT (
        source1_reg_num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        source2_reg_num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        dest_before_reg_num : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        dest_before_before_reg_num : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

        source1_signal : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        source2_signal : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

        alu_write_back : IN STD_LOGIC;
        memory_write_back : IN STD_LOGIC;

        read_src1 : IN STD_LOGIC;
        read_src2 : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE data_forwarding_arch OF data_forwarding IS
BEGIN

    source1_signal <= "01" WHEN source1_reg_num = dest_before_reg_num AND read_src1 = '1' AND alu_write_back = '1' ELSE
        "10" WHEN source1_reg_num = dest_before_before_reg_num AND read_src1 = '1' AND memory_write_back = '1'ELSE
        "00";

    source2_signal <= "01" WHEN source2_reg_num = dest_before_reg_num AND read_src2 = '1' AND alu_write_back = '1' ELSE
        "10" WHEN source2_reg_num = dest_before_before_reg_num AND read_src2 = '1' AND memory_write_back = '1' ELSE
        "00";

END ARCHITECTURE;