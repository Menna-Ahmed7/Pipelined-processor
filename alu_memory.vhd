LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;
ENTITY alu_memory IS
    PORT (
        clk : IN STD_LOGIC;
        pop_flags : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        flush : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        flush2 : IN STD_LOGIC;
        swap : IN STD_LOGIC;
        free : IN STD_LOGIC;
        protect : IN STD_LOGIC;
        src1_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        io_read : IN STD_LOGIC;
        push : IN STD_LOGIC;
        pop : IN STD_LOGIC;
        RTI : IN STD_LOGIC;
        RET : IN STD_LOGIC;
        call : IN STD_LOGIC;
        jz : IN STD_LOGIC;
        jump : IN STD_LOGIC;
        memory_read : IN STD_LOGIC;
        memory_write : IN STD_LOGIC;
        write_back : IN STD_LOGIC;
        reg_dest : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        reg_dest2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        result_alu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        flags_alu : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        EA : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
        out_write_back : OUT STD_LOGIC;
        out_reg_dest : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        out_reg_dest2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        out_result_alu : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_flags_alu : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        out_io_read : OUT STD_LOGIC;
        out_push : OUT STD_LOGIC;
        out_pop : OUT STD_LOGIC;
        out_RTI : OUT STD_LOGIC;
        out_RET : OUT STD_LOGIC;
        out_call : OUT STD_LOGIC;
        out_jz : OUT STD_LOGIC;
        out_jump : OUT STD_LOGIC;
        out_memory_read : OUT STD_LOGIC;
        out_memory_write : OUT STD_LOGIC;
        out_EA : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
        out_src1_data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_free : OUT STD_LOGIC;
        out_protect : OUT STD_LOGIC;
        out_swap : OUT STD_LOGIC;
        out_flush : OUT STD_LOGIC;
        out_pc : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_pop_flags : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch_alu_memory OF alu_memory IS
BEGIN
    decode_alu_p : PROCESS (clk, RST)
    BEGIN

        IF RST = '1' OR flush2 = '1' THEN
            out_write_back <= '0';
            out_reg_dest <= (OTHERS => '0');
            out_reg_dest2 <= (OTHERS => '0');
            out_result_alu <= (OTHERS => '0');
            out_io_read <= '0';
            out_push <= '0';
            out_pop <= '0';
            out_RTI <= '0';
            out_RET <= '0';
            out_call <= '0';
            out_jz <= '0';
            out_jump <= '0';
            out_memory_read <= '0';
            out_memory_write <= '0';
            out_EA <= (OTHERS => '0');
            out_src1_data <= (OTHERS => '0');
            out_flags_alu <= (OTHERS => '0');
            out_pc <= (OTHERS => '0');
            out_free <= '0';
            out_protect <= '0';
            out_swap <= '0';
            out_flush <= '0';
            out_pop_flags <= '0';

        ELSIF clk'event AND clk = '1'THEN
            out_write_back <= write_back;
            out_reg_dest <= reg_dest;
            out_reg_dest2 <= reg_dest2;
            out_result_alu <= result_alu;
            out_io_read <= io_read;
            out_push <= push;
            out_pop <= pop;
            out_RTI <= RTI;
            out_RET <= RET;
            out_call <= call;
            out_jz <= jz;
            out_jump <= jump;
            out_memory_read <= memory_read;
            out_memory_write <= memory_write;
            out_EA <= EA;
            out_src1_data <= src1_data;
            out_flags_alu <= flags_alu;
            out_free <= free;
            out_protect <= protect;
            out_swap <= swap;
            out_flush <= flush;
            out_pc <= pc;
            out_pop_flags <= pop_flags;
        END IF;
    END PROCESS;

END ARCHITECTURE;