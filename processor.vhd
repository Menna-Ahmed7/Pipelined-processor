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
            registers : IN registers_block(0 TO 7)(31 DOWNTO 0);
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
    COMPONENT fetch_decode IS
        PORT (
            clk : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

            out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT register_file IS
        PORT (

            registers : OUT registers_block(0 TO 7)(31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL in_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL src2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL next_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL sp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CCR : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL src1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL imm_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory_read : STD_LOGIC;
    SIGNAL memory_write : STD_LOGIC;
    SIGNAL write_back_signal : STD_LOGIC;
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
    SIGNAL out_port : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL jz_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    reg_file_instance : register_file PORT MAP(registers);

    fetch_instance : fetch PORT MAP(clk, registers, jz, jz_address, in_instruction, next_pc, rti, ret, memory_pc);

    fetch_decode_instance : fetch_decode PORT MAP(clk, in_instruction, next_pc, out_instruction, out_pc);

    decode_instance : decode PORT MAP(clk, out_instruction, registers, src2_data, src1_data, alu_signal, imm_value, memory_read, memory_write, write_back_signal, read_src1, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz, reg_dest);

    -- decode_alu_instance : PORT MAP decode_alu(clk, src2_data, src1_data, alu_signal, imm_value, memory_read, memory_write, write_back, read_src1, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz, reg_dest, out_instruction(7 DOWNTO 4), out_src2_data, out_src1_data, out_alu_signal, out_imm_value, out_memory_read, out_memory_write, out_write_back, out_read_src1, out_io_read, out_io_write, out_push, out_pop, out_swap, out_imm, out_RTI, out_RET, out_call, out_jz, out_reg_dest, out_out_instruction);

    -- alu_instance : PORT MAP alu_stage (clk, out_src1_data, out_src2_data, out_imm_value, //write_back_data, // result_in, // forward_unit_signal1, // forward_unit_signal2, out_imm, out_io_write, out_alu_signal, out_port, result_alu, flags_alu);
    -- alu_memory_instance : PORT MAP alu_memory (clk, out_io_read, out_io_write, out_push, out_pop, out_RTI, out_RET, out_call, out_memory_read, out_memory_write, out_write_back, out_reg_dest, result_alu, flags_alu, out_out_instruction & out_instruction, out_out_memory_read, out_out_write_back, out_out_reg_dest, out_result_alu);
    -- memory_instance : PORT MAP memory (clk, //EA, //datain, // pc, // CCR, // memory_write, memory_read, rti, ret, call, pop, push, sp, next_pc, dataout);
    -- memory_write_back_instance : PORT MAP memory_write_back (clk, out_out_memory_read, out_out_write_back, out_out_reg_dest, out_result_alu, dataout, out_out_out_memory_read, out_out_out_write_back, out_out_out_reg_dest, out_out_result_alu, out_dataout);
    -- write_back_instance : PORT MAP write_back (clk, out_out_out_memory_read, out_out_out_write_back, registers, out_out_out_reg_dest, data_alu, out_out_result_alu, out_registers);
    -- registers <= out_registers;

END ARCHITECTURE;