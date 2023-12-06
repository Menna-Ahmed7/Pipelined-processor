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
        interrupt : IN STD_LOGIC
    );
END ENTITY;
ARCHITECTURE arch_processor OF processor IS
    COMPONENT alu_stage IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            src1, src2, write_back_data, result_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
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
            RST : IN STD_LOGIC;
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
            reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            src1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            src2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            free : OUT STD_LOGIC;
            protect : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT fetch IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            jz : IN STD_LOGIC;
            jz_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            rti : IN STD_LOGIC;
            ret : IN STD_LOGIC;
            memory_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT write_back IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            memory_read : IN STD_LOGIC;
            write_back : IN STD_LOGIC;
            dest_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT memory IS
        PORT (
            clk : IN STD_LOGIC;
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
            sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            prot : IN STD_LOGIC;

            free : IN STD_LOGIC;
            src1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT fetch_decode IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

            out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT register_file IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            we : IN STD_LOGIC;
            address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT decode_alu IS
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
            out_reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_out_instruction : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_free : OUT STD_LOGIC;
            out_protect : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT alu_memory IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            free : IN STD_LOGIC;
            protect : IN STD_LOGIC;
            src1_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            io_read : IN STD_LOGIC;
            push : IN STD_LOGIC;
            pop : IN STD_LOGIC;
            RTI : IN STD_LOGIC;
            RET : IN STD_LOGIC;
            call : IN STD_LOGIC;
            memory_read : IN STD_LOGIC;
            memory_write : IN STD_LOGIC;
            write_back : IN STD_LOGIC;
            reg_dest : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            result_alu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            flags_alu : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            EA : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

            out_write_back : OUT STD_LOGIC;
            out_reg_dest : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            out_result_alu : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            out_flags_alu : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            out_io_read : OUT STD_LOGIC;
            out_push : OUT STD_LOGIC;
            out_pop : OUT STD_LOGIC;
            out_RTI : OUT STD_LOGIC;
            out_RET : OUT STD_LOGIC;
            out_call : OUT STD_LOGIC;
            out_memory_read : OUT STD_LOGIC;
            out_memory_write : OUT STD_LOGIC;
            out_EA : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
            out_src1_data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            out_free : OUT STD_LOGIC;
            out_protect : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT memory_write_back IS
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            out_out_memory_read : IN STD_LOGIC;
            out_out_write_back : IN STD_LOGIC;
            out_out_reg_dest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_result_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            dataout : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_out_out_memory_read : OUT STD_LOGIC;
            out_out_out_write_back : OUT STD_LOGIC;
            out_out_out_reg_dest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            out_out_result_alu : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL in_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL out_registers : registers_block(0 TO 7)(31 DOWNTO 0);
    SIGNAL src2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL next_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL sp : STD_LOGIC_VECTOR(31 DOWNTO 0);

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
    SIGNAL protect : STD_LOGIC;
    SIGNAL free : STD_LOGIC;
    SIGNAL reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
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
    SIGNAL out_imm : STD_LOGIC;
    SIGNAL out_RTI : STD_LOGIC;
    SIGNAL out_RET : STD_LOGIC;
    SIGNAL out_call : STD_LOGIC;
    SIGNAL out_jz : STD_LOGIC;
    SIGNAL out_protect : STD_LOGIC;
    SIGNAL out_free : STD_LOGIC;
    SIGNAL out_reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_out_instruction : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL write_back_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL forward_unit_signal1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL forward_unit_signal2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL out_port : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_port : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL flags_alu : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL out_out_write_back : STD_LOGIC;
    SIGNAL out_out_reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
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
    SIGNAL out_out_memory_read : STD_LOGIC;
    SIGNAL out_out_memory_write : STD_LOGIC;
    SIGNAL out_EA : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL out_out_src1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dataout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_out_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL out_out_out_memory_read : STD_LOGIC;

    SIGNAL out_out_out_write_back : STD_LOGIC;
    SIGNAL out_out_out_reg_dest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL out_out_result_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_dataout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL src1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL src2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL reg_datain : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg_dataout1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg_dataout2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_CCR : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL final_CCR : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    reg_file_instance : register_file PORT MAP(clk, RST, out_out_out_write_back, src1, src2, out_out_out_reg_dest, reg_datain, src1_data, src2_data);

    fetch_instance : fetch PORT MAP(clk, RST, jz, jz_address, rti, ret, memory_pc, in_instruction, next_pc);

    fetch_decode_instance : fetch_decode PORT MAP(clk, RST, in_instruction, next_pc, out_instruction, out_pc);

    decode_instance : decode PORT MAP(clk, RST, out_instruction, alu_signal, memory_read, memory_write, write_back_signal, read_src1, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz, reg_dest, src1, src2, free, protect);
    decode_alu_instance : decode_alu PORT MAP(clk, RST, free, protect, out_pc, src2_data, src1_data, alu_signal, memory_read, memory_write, write_back_signal, read_src1, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz, reg_dest, out_instruction(7 DOWNTO 4), out_src2_data, out_src1_data, out_alu_signal, out_memory_read, out_memory_write, out_write_back, out_read_src1, out_io_read, out_io_write, out_push, out_pop, out_swap, out_imm, out_RTI, out_RET, out_call, out_jz, out_reg_dest, out_out_instruction, out_out_pc, out_free, out_protect);

    alu_instance : alu_stage PORT MAP(clk, RST, out_src1_data, out_src2_data, write_back_data, result_in, out_instruction, forward_unit_signal1, forward_unit_signal2, out_imm, out_io_write, out_alu_signal, out_port, result_alu, flags_alu);

    alu_memory_instance : alu_memory PORT MAP(clk, RST, out_free, out_protect, out_src1_data, out_io_read, out_push, out_pop, out_RTI, out_RET, out_call, out_memory_read, out_memory_write, out_write_back, out_reg_dest, result_alu, flags_alu, out_out_instruction & out_instruction, out_out_write_back, out_out_reg_dest, out_result_alu, out_flags_alu, out_out_io_read, out_out_push, out_out_pop, out_out_RTI, out_out_RET, out_out_call, out_out_memory_read, out_out_memory_write, out_EA, out_out_src1_data, out_out_free, out_out_protect);
    memory_instance : memory PORT MAP(clk, RST, out_EA, out_out_src1_data, out_out_pc, out_flags_alu(2 DOWNTO 0), out_out_memory_write, out_out_memory_read, out_out_rti, out_out_ret, out_out_call, out_out_pop, out_out_push, sp, out_out_protect, out_out_free, out_out_src1_data, memory_pc, dataout, out_CCR);
    memory_write_back_instance : memory_write_back PORT MAP(clk, RST, out_out_memory_read, out_out_write_back, out_out_reg_dest, out_result_alu, out_CCR, dataout, out_out_out_memory_read, out_out_out_write_back, out_out_out_reg_dest, out_out_result_alu, out_dataout, final_CCR);
    write_back_instance : write_back PORT MAP(clk, RST, out_out_out_memory_read, out_out_out_write_back, out_out_out_reg_dest, out_out_result_alu, out_dataout, reg_datain);

END ARCHITECTURE;