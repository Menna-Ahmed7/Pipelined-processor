LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;
ENTITY decode_alu IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        free : IN STD_LOGIC;
        protect : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        src2_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        src1_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_signal : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        memory_read : IN STD_LOGIC;
        memory_write : IN STD_LOGIC;
        write_back : IN STD_LOGIC;
        read_src1 : IN STD_LOGIC;
        io_read : IN STD_LOGIC;
        io_write : IN STD_LOGIC;
        push : IN STD_LOGIC;
        pop : IN STD_LOGIC;
        swap : IN STD_LOGIC;
        imm : IN STD_LOGIC;
        RTI : IN STD_LOGIC;
        RET : IN STD_LOGIC;
        call : IN STD_LOGIC;
        jz : IN STD_LOGIC;
        reg_dest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_instruction : IN STD_LOGIC_VECTOR(3 DOWNTO 0); ------------------------------help 
        out_src2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_src1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_alu_signal : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        out_memory_read : OUT STD_LOGIC;
        out_memory_write : OUT STD_LOGIC;
        out_write_back : OUT STD_LOGIC;
        out_read_src1 : OUT STD_LOGIC;
        out_io_read : OUT STD_LOGIC;
        out_io_write : OUT STD_LOGIC;
        out_push : OUT STD_LOGIC;
        out_pop : OUT STD_LOGIC;
        out_swap : OUT STD_LOGIC;
        out_imm : OUT STD_LOGIC;
        out_RTI : OUT STD_LOGIC;
        out_RET : OUT STD_LOGIC;
        out_call : OUT STD_LOGIC;
        out_jz : OUT STD_LOGIC;
        out_reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_out_instruction : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_free : OUT STD_LOGIC;
        out_protect : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch_decode_alu OF decode_alu IS
BEGIN
    decode_alu_p : PROCESS (clk, RST)
    BEGIN
        IF RST = '1' THEN
            out_out_instruction <= (OTHERS => '0');
            out_reg_dest <= (OTHERS => '0');
            out_jz <= '0';
            out_call <= '0';
            out_RET <= '0';
            out_RTI <= '0';
            out_imm <= '0';
            out_swap <= '0';
            out_pop <= '0';
            out_push <= '0';
            out_io_write <= '0';
            out_io_read <= '0';
            out_read_src1 <= '0';
            out_write_back <= '0';
            out_memory_write <= '0';
            out_memory_read <= '0';

            out_alu_signal <= (OTHERS => '0');
            out_src2_data <= (OTHERS => '0');
            out_src1_data <= (OTHERS => '0');

            out_pc <= (OTHERS => '0');
            out_free <= '0';
            out_protect <= '0';
        ELSIF clk'event AND clk = '1'THEN
            out_out_instruction <= out_instruction;
            out_reg_dest <= reg_dest;
            out_jz <= jz;
            out_call <= call;
            out_RET <= RET;
            out_RTI <= RTI;
            out_imm <= imm;
            out_swap <= swap;
            out_pop <= pop;
            out_push <= push;
            out_io_write <= io_write;
            out_io_read <= io_read;
            out_read_src1 <= read_src1;
            out_write_back <= write_back;
            out_memory_write <= memory_write;
            out_memory_read <= memory_read;

            out_alu_signal <= alu_signal;
            out_src2_data <= src2_data;
            out_src1_data <= src1_data;

            out_pc <= pc;
            out_free <= free;
            out_protect <= protect;
        END IF;
    END PROCESS;

END ARCHITECTURE;