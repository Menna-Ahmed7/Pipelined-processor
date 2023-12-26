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
        RST : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_processor OF processor IS
    COMPONENT alu_stage IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            pop_flags : IN STD_LOGIC;
            memory_flags : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            call : IN STD_LOGIC;
            jump : IN STD_LOGIC;
            jz : IN STD_LOGIC;
            src1, src2, write_back_data, result_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            forward_unit_signal1, forward_unit_signal2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            imm_signal, iow_signal, ior_signal : IN STD_LOGIC;
            ALU_sig : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            out_port : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            in_port : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            result_alu : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            flags_alu : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            flush : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT decode IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            interrupt : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            alu_signal : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
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
            jump : OUT STD_LOGIC;
            reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            reg_dest2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            src1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            src2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            free : OUT STD_LOGIC;
            protect : OUT STD_LOGIC;
            pop_flags : OUT STD_LOGIC;
            push_pc : OUT STD_LOGIC;
            get_pc_int : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT fetch IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            get_pc_int : IN STD_LOGIC;
            interrupt : IN STD_LOGIC;
            jz : IN STD_LOGIC;
            zeroFlag : IN STD_LOGIC;
            rti : IN STD_LOGIC;
            ret : IN STD_LOGIC;
            jump : IN STD_LOGIC;
            call : IN STD_LOGIC;
            memory_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            alu_pc : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            out_interrupt : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT write_back IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            memory_read : IN STD_LOGIC;
            write_back : IN STD_LOGIC;
            -- registers : INOUT registers_block(0 TO 7)(31 DOWNTO 0);
            dest_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            src1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT memory IS
        PORT (
            clk : IN STD_LOGIC;
            push_pc : IN STD_LOGIC;
            get_pc_int : IN STD_LOGIC;
            interrupt : IN STD_LOGIC;
            alu_flags : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            pop_flags : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            EA : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            memory_write : IN STD_LOGIC;
            memory_read : IN STD_LOGIC;
            rti : IN STD_LOGIC;
            ret : IN STD_LOGIC;
            call : IN STD_LOGIC;
            pop : IN STD_LOGIC;
            push : IN STD_LOGIC;
            prot : IN STD_LOGIC;
            free : IN STD_LOGIC;
            next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            flush2 : OUT STD_LOGIC;
            flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            out_pop_flags : OUT STD_LOGIC;
            out_get_int : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT fetch_decode IS
        PORT (
            clk : IN STD_LOGIC;
            interrupt : IN STD_LOGIC;
            flush : IN STD_LOGIC;
            flush2 : IN STD_LOGIC;
            in_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            RST : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_in_port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_interrupt : OUT STD_LOGIC

        );
    END COMPONENT;

    COMPONENT register_file IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            we : IN STD_LOGIC;
            swap : IN STD_LOGIC;
            address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            datain1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            datain2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT decode_alu IS
        PORT (
            clk : IN STD_LOGIC;
            push_pc : IN STD_LOGIC;
            get_pc_int : IN STD_LOGIC;
            interrupt : IN STD_LOGIC;
            pop_flags : IN STD_LOGIC;
            flush : IN STD_LOGIC;
            flush2 : IN STD_LOGIC;
            in_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
            jump : IN STD_LOGIC;
            reg_dest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            reg_dest2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_instruction : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
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
            out_jump : OUT STD_LOGIC;
            out_reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_reg_dest2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_out_instruction : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_free : OUT STD_LOGIC;
            out_protect : OUT STD_LOGIC;
            out_in_port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_pop_flags : OUT STD_LOGIC;
            out_interrupt : OUT STD_LOGIC;
            out_push_pc : OUT STD_LOGIC;
            out_get_pc_int : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT alu_memory IS
        PORT (
            clk : IN STD_LOGIC;
            push_pc : IN STD_LOGIC;
            get_pc_int : IN STD_LOGIC;
            interrupt : IN STD_LOGIC;
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
            out_pop_flags : OUT STD_LOGIC;
            out_interrupt : OUT STD_LOGIC;
            out_push_pc : OUT STD_LOGIC;
            out_get_pc_int : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT memory_write_back IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            ret : IN STD_LOGIC;
            rti : IN STD_LOGIC;
            flush2 : IN STD_LOGIC;
            swap : IN STD_LOGIC;
            src1_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            out_out_memory_read : IN STD_LOGIC;
            out_out_write_back : IN STD_LOGIC;
            out_out_reg_dest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_out_reg_dest2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_result_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            dataout : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_out_out_memory_read : OUT STD_LOGIC;
            out_out_out_write_back : OUT STD_LOGIC;
            out_out_out_reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_out_out_reg_dest2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_out_result_alu : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_src1_data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            out_swap : OUT STD_LOGIC;
            out_flush2 : OUT STD_LOGIC;
            out_ret : OUT STD_LOGIC;
            out_rti : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL in_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL out_registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL src2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL next_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);

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
    SIGNAL jump : STD_LOGIC;
    SIGNAL protect : STD_LOGIC;
    SIGNAL free : STD_LOGIC;
    SIGNAL reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL reg_dest2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL jz_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL out_src2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_src1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_alu_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL out_imm_value : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_memory_read : STD_LOGIC;
    SIGNAL out_memory_write : STD_LOGIC;
    SIGNAL out_write_back : STD_LOGIC;
    SIGNAL out_read_src1 : STD_LOGIC;
    SIGNAL out_io_read : STD_LOGIC;
    SIGNAL out_io_write : STD_LOGIC;
    SIGNAL out_push : STD_LOGIC;
    SIGNAL out_pop : STD_LOGIC;
    SIGNAL out_swap : STD_LOGIC;
    SIGNAL out_out_swap : STD_LOGIC;
    SIGNAL out_out_out_swap : STD_LOGIC;
    SIGNAL out_imm : STD_LOGIC;
    SIGNAL out_RTI : STD_LOGIC;
    SIGNAL out_RET : STD_LOGIC;
    SIGNAL out_call : STD_LOGIC;
    SIGNAL out_jz : STD_LOGIC;
    SIGNAL out_jump : STD_LOGIC;
    SIGNAL out_protect : STD_LOGIC;
    SIGNAL out_free : STD_LOGIC;
    SIGNAL out_reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_reg_dest2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_out_instruction : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL write_back_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL forward_unit_signal1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL forward_unit_signal2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL result_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL flags_alu : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL out_out_write_back : STD_LOGIC;
    SIGNAL out_out_reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_out_reg_dest2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_result_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_flags_alu : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL out_out_io_read : STD_LOGIC;
    SIGNAL out_out_io_write : STD_LOGIC;
    SIGNAL out_out_push : STD_LOGIC;
    SIGNAL out_out_pop : STD_LOGIC;
    SIGNAL out_out_RTI : STD_LOGIC;
    SIGNAL out_out_RET : STD_LOGIC;
    SIGNAL out_out_free : STD_LOGIC;
    SIGNAL out_out_protect : STD_LOGIC;
    SIGNAL out_out_call : STD_LOGIC;
    SIGNAL out_out_jz : STD_LOGIC;
    SIGNAL out_out_jump : STD_LOGIC;
    SIGNAL out_out_memory_read : STD_LOGIC;
    SIGNAL out_out_memory_write : STD_LOGIC;
    SIGNAL out_EA : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL out_out_src1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_out_out_src1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dataout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_out_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_out_out_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_out_out_memory_read : STD_LOGIC;

    SIGNAL out_out_out_write_back : STD_LOGIC;
    SIGNAL out_out_out_reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_out_out_reg_dest2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_out_result_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_dataout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL src1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL src2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL reg_datain1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg_datain2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg_dataout1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg_dataout2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_CCR : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL final_CCR : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_in_port : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_out_in_port : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL flush : STD_LOGIC;
    SIGNAL flush2 : STD_LOGIC;
    SIGNAL out_flush2 : STD_LOGIC;
    SIGNAL out_flush : STD_LOGIC;
    SIGNAL out_out_out_ret : STD_LOGIC;
    SIGNAL out_out_out_rti : STD_LOGIC;
    SIGNAL pop_flags : STD_LOGIC;
    SIGNAL out_pop_flags : STD_LOGIC;
    SIGNAL out_out_pop_flags : STD_LOGIC;
    SIGNAL temp_pop_flags : STD_LOGIC;
    SIGNAL memory_flags : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL out_interrupt : STD_LOGIC;
    SIGNAL push_pc : STD_LOGIC;
    SIGNAL get_pc_int : STD_LOGIC;
    SIGNAL out_out_interrupt : STD_LOGIC;
    SIGNAL out_push_pc : STD_LOGIC;
    SIGNAL out_get_pc_int : STD_LOGIC;

    SIGNAL out_out_out_interrupt : STD_LOGIC;
    SIGNAL out_out_push_pc : STD_LOGIC;
    SIGNAL out_out_get_pc_int : STD_LOGIC;
    SIGNAL in_interrupt : STD_LOGIC;
    SIGNAL fetch_get_pc_int : STD_LOGIC;

BEGIN
    reg_file_instance : register_file PORT MAP(clk, RST, out_out_out_write_back, out_out_out_swap, src1, src2, out_out_out_reg_dest, out_out_out_reg_dest2, reg_datain1, reg_datain2, src1_data, src2_data);

    fetch_instance : fetch PORT MAP(clk, RST, fetch_get_pc_int, interrupt, out_out_jz, out_flags_alu(0), out_out_out_rti, out_out_out_ret, out_out_jump, out_out_call, memory_pc, in_instruction, next_pc, out_result_alu, in_interrupt);

    fetch_decode_instance : fetch_decode PORT MAP(clk, in_interrupt, out_flush, out_flush2, in_port, RST, in_instruction, next_pc, out_instruction, out_pc, out_in_port, out_interrupt);

    decode_instance : decode PORT MAP(clk, RST, out_interrupt, out_instruction, alu_signal, memory_read, memory_write, write_back_signal, read_src1, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz, jump, reg_dest, reg_dest2, src1, src2, free, protect, pop_flags, push_pc, get_pc_int);

    decode_alu_instance : decode_alu PORT MAP(clk, push_pc, get_pc_int, out_interrupt, pop_flags, out_flush, out_flush2, out_in_port, RST, free, protect, out_pc, src2_data, src1_data, alu_signal, memory_read, memory_write, write_back_signal, read_src1, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz, jump, reg_dest, reg_dest2, out_instruction(7 DOWNTO 4), out_src2_data, out_src1_data, out_alu_signal, out_memory_read, out_memory_write, out_write_back, out_read_src1, out_io_read, out_io_write, out_push, out_pop, out_swap, out_imm, out_RTI, out_RET, out_call, out_jz, out_jump, out_reg_dest, out_reg_dest2, out_out_instruction, out_out_pc, out_free, out_protect, out_out_in_port, out_pop_flags, out_out_interrupt, out_push_pc, out_get_pc_int);

    alu_instance : alu_stage PORT MAP(clk, RST, temp_pop_flags, memory_flags, out_call, out_jump, out_jz, out_src1_data, out_src2_data, write_back_data, result_in, out_instruction, forward_unit_signal1, forward_unit_signal2, out_imm, out_io_write, out_io_read, out_alu_signal, out_port, out_out_in_port, result_alu, flags_alu, flush);

    alu_memory_instance : alu_memory PORT MAP(clk, out_push_pc, out_get_pc_int, out_out_interrupt, out_pop_flags, RST, flush, out_out_pc, out_flush2, out_swap, out_free, out_protect, out_src1_data, out_io_read, out_push, out_pop, out_RTI, out_RET, out_call, out_jz, out_jump, out_memory_read, out_memory_write, out_write_back, out_reg_dest, out_reg_dest2, result_alu, flags_alu, out_out_instruction & out_instruction, out_out_write_back, out_out_reg_dest, out_out_reg_dest2, out_result_alu, out_flags_alu, out_out_io_read, out_out_push, out_out_pop, out_out_rti, out_out_ret, out_out_call, out_out_jz, out_out_jump, out_out_memory_read, out_out_memory_write, out_EA, out_out_src1_data, out_out_free, out_out_protect, out_out_swap, out_flush, out_out_out_pc, out_out_pop_flags, out_out_out_interrupt, out_out_push_pc, out_out_get_pc_int);

    memory_instance : memory PORT MAP(clk, out_out_push_pc, out_out_get_pc_int, out_out_out_interrupt, out_flags_alu, out_out_pop_flags, RST, out_EA, out_out_src1_data, out_out_out_pc, out_flags_alu(2 DOWNTO 0), out_out_memory_write, out_out_memory_read, out_out_rti, out_out_ret, out_out_call, out_out_pop, out_out_push, out_out_protect, out_out_free, memory_pc, dataout, out_CCR, flush2, memory_flags, temp_pop_flags, fetch_get_pc_int);

    memory_write_back_instance : memory_write_back PORT MAP(clk, RST, out_out_ret, out_out_rti, flush2, out_out_swap, out_out_src1_data, out_out_memory_read, out_out_write_back, out_out_reg_dest, out_out_reg_dest2, out_result_alu, out_CCR, dataout, out_out_out_memory_read, out_out_out_write_back, out_out_out_reg_dest, out_out_out_reg_dest2, out_out_result_alu, out_dataout, final_CCR, out_out_out_src1_data, out_out_out_swap, out_flush2, out_out_out_ret, out_out_out_rti);

    write_back_instance : write_back PORT MAP(clk, RST, out_out_out_memory_read, out_out_out_write_back, out_out_out_reg_dest, out_out_result_alu, out_dataout, out_out_out_src1_data, reg_datain1, reg_datain2);

END ARCHITECTURE;