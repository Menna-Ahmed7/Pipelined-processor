
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

USE work.reg.ALL;
USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY processor IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        interrupt : IN STD_LOGIC
    );
END ENTITY;
ARCHITECTURE arch_processor OF processor IS
    COMPONENT alu_stage IS
        PORT (
            clk : IN STD_LOGIC;
            src1, src2, imm, write_back_data, result_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            forward_unit_signal1, forward_unit_signal2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            imm_signal, iow_signal : IN STD_LOGIC;
            ALU_sig : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            out_port : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            result_alu : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            flags_alu : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT decode IS
        PORT (
            clk : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            registers : IN registers_block(0 TO 7)(31 DOWNTO 0);
            src2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            src1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            alu_signal : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            imm_value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            memory_read : OUT STD_LOGIC;
            memory_write : OUT STD_LOGIC;
            write_back : OUT STD_LOGIC;
            read_src1 : OUT STD_LOGIC;
            io_read : OUT STD_LOGIC;
            io_write : OUT STD_LOGIC;
            push : OUT STD_LOGIC;
            pop : OUT STD_LOGIC;
            swap : OUT STD_LOGIC;
            imm : OUT STD_LOGIC;
            RTI : OUT STD_LOGIC;
            RET : OUT STD_LOGIC;
            call : OUT STD_LOGIC;
            jz : OUT STD_LOGIC;
            reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT fetch IS
        PORT (
            clk : IN STD_LOGIC;
            registers : IN register_array(0 TO 7)(31 DOWNTO 0);
            jz : IN STD_LOGIC;
            jz_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => 'Z');
            next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            rti : IN STD_LOGIC;
            ret : IN STD_LOGIC;
            memory_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT write_back IS
        PORT (
            clk : IN STD_LOGIC;
            memory_read : IN STD_LOGIC;
            registers : IN registers_block(0 TO 7)(31 DOWNTO 0);
            dest_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_registers : OUT registers_block(0 TO 7)(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT memory IS
        PORT (
            clk : IN STD_LOGIC;
            EA : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCR : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            memory_write : IN STD_LOGIC;
            memory_read : IN STD_LOGIC;
            rti : IN STD_LOGIC;
            ret : IN STD_LOGIC;
            call : IN STD_LOGIC;
            pop : IN STD_LOGIC;
            push : IN STD_LOGIC;
            sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT register_file IS
        PORT (
            registers : OUT registers_block(0 TO 7)(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL src2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL src1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL imm_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory_read : STD_LOGIC;
    SIGNAL memory_write : STD_LOGIC;
    SIGNAL write_back : STD_LOGIC;
    SIGNAL read_src1 : STD_LOGIC;
    SIGNAL io_read : STD_LOGIC;
    SIGNAL io_write : STD_LOGIC;
    SIGNAL push : STD_LOGIC;
    SIGNAL pop : STD_LOGIC;
    SIGNAL swap : STD_LOGIC;
    SIGNAL imm : STD_LOGIC;
    SIGNAL RTI : STD_LOGIC;
    SIGNAL RET : STD_LOGIC;
    SIGNAL call : STD_LOGIC;
    SIGNAL jz : STD_LOGIC;
    SIGNAL reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
    fetch_instance : PORT MAP fetch(clk, registers, jz, jz_address, instruction, next_pc, rti, ret, memory_pc);
    decode_instance : PORT MAP decode(clk, instruction, registers, src2_data, src1_data, alu_signal, imm_value, memory_read, memory_write, write_back, read_src1, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz, reg_dest);
    alu_instance : PORT MAP alu_stage (clk, src1, src2, imm, write_back_data, result_in, forward_unit_signal1, forward_unit_signal2, imm_signal, iow_signal, ALU_sig, out_port, result_alu, flags_alu);
    memory_instance : PORT MAP memory (clk, EA, datain, pc, CCR, memory_write, memory_read, rti, ret, call, pop, push, sp, next_pc, dataout);
    write_back_instance : PORT MAP write_back (clk, memory_read, registers, dest_address, data_alu, data_memory, out_registers);

END COMPONENT;

processor_p : PROCESS (clk)

END PROCESS;