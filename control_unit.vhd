
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY control_unit IS
    PORT (
        RST : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        alu_signal : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        memory_read : OUT STD_LOGIC;
        memory_write : OUT STD_LOGIC;
        write_back : OUT STD_LOGIC;
        read_src1 : OUT STD_LOGIC;
        read_src2 : OUT STD_LOGIC;
        reg_dest_selector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
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
        free : OUT STD_LOGIC;
        protect : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch_control_unit OF control_unit IS
    SIGNAL instruction_32bit : STD_LOGIC := '0';
BEGIN
    PROCESS (opcode, RST) IS
    BEGIN
        memory_read <= '0';
        memory_write <= '0';
        write_back <= '0';
        read_src1 <= '0';
        read_src2 <= '0';
        reg_dest_selector <= "00";
        io_read <= '0';
        io_write <= '0';
        push <= '0';
        pop <= '0';
        swap <= '0';
        imm <= '0';
        RTI <= '0';
        RET <= '0';
        call <= '0';
        jz <= '0';
        jump <= '0';
        free <= '0';
        protect <= '0';
        alu_signal <= (OTHERS => '0');
        IF (RST = '0') THEN
            IF (instruction_32bit = '1') THEN
                instruction_32bit <= '0';
            ELSE
                --not
                IF opcode = "00001" THEN
                    write_back <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "0001";
                    --neg
                ELSIF opcode = "00010" THEN
                    write_back <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "0010";

                    --inc
                ELSIF opcode = "00011" THEN
                    write_back <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "0011";
                    --dec
                ELSIF opcode = "00100" THEN
                    write_back <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "0100";

                    --swap
                ELSIF opcode = "00101" THEN
                    write_back <= '1';
                    swap <= '1';
                    read_src1 <= '1';
                    read_src2 <= '1';
                    reg_dest_selector <= "01";
                    alu_signal <= "0101";

                    --add
                ELSIF opcode = "00111" THEN
                    write_back <= '1';
                    read_src1 <= '1';
                    read_src2 <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "0111";

                    --sub
                ELSIF opcode = "01000" THEN
                    write_back <= '1';
                    read_src1 <= '1';
                    read_src2 <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "1000";

                    --and
                ELSIF opcode = "01001" THEN
                    write_back <= '1';
                    read_src1 <= '1';
                    read_src2 <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "1001";

                    --or
                ELSIF opcode = "01010" THEN
                    write_back <= '1';
                    read_src1 <= '1';
                    read_src2 <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "1010";

                    --xor
                ELSIF opcode = "01011" THEN
                    write_back <= '1';
                    read_src1 <= '1';
                    read_src2 <= '1';
                    reg_dest_selector <= "11";
                    alu_signal <= "1011";

                    --addi
                ELSIF opcode = "01100" THEN
                    write_back <= '1';
                    read_src1 <= '1';
                    imm <= '1';
                    reg_dest_selector <= "10";
                    alu_signal <= "0111";
                    instruction_32bit <= '1';
                    --cmp
                ELSIF opcode = "01101" THEN
                    read_src1 <= '1';
                    read_src2 <= '1';
                    alu_signal <= "1000";

                    --bitset
                ELSIF opcode = "01110" THEN
                    write_back <= '1';
                    imm <= '1';
                    reg_dest_selector <= "10";
                    alu_signal <= "1100";

                    --rcl
                ELSIF opcode = "01111" THEN
                    write_back <= '1';
                    imm <= '1';
                    reg_dest_selector <= "10";
                    alu_signal <= "1101";
                    instruction_32bit <= '1';
                    --rcr
                ELSIF opcode = "10000" THEN
                    write_back <= '1';
                    imm <= '1';
                    reg_dest_selector <= "10";
                    alu_signal <= "1110";
                    instruction_32bit <= '1';
                    --jz
                ELSIF opcode = "10001" THEN
                    jz <= '1';
                    read_src1 <= '1';

                    --jmp
                ELSIF opcode = "10010" THEN
                    read_src1 <= '1';
                    jump <= '1';

                    --call
                ELSIF opcode = "10011" THEN
                    read_src1 <= '1';
                    call <= '1';
                    memory_write <= '1';

                    --ret
                ELSIF opcode = "10100" THEN
                    memory_read <= '1';
                    ret <= '1';

                    --rti
                ELSIF opcode = "10101" THEN
                    memory_read <= '1';
                    rti <= '1';

                    --push
                ELSIF opcode = "10110" THEN
                    memory_write <= '1';
                    read_src1 <= '1';
                    push <= '1';

                    --pop
                ELSIF opcode = "10111" THEN
                    memory_read <= '1';
                    pop <= '1';
                    reg_dest_selector <= "01";
                    write_back <= '1';

                    --in
                ELSIF opcode = "11000" THEN
                    write_back <= '1';
                    io_read <= '1';
                    reg_dest_selector <= "01";

                    --out
                ELSIF opcode = "11001" THEN
                    io_write <= '1';
                    read_src1 <= '1';

                    --  ldm
                ELSIF opcode = "11010" THEN
                    write_back <= '1';
                    reg_dest_selector <= "01";
                    imm <= '1';
                    instruction_32bit <= '1';
                    --lld
                ELSIF opcode = "11011" THEN
                    write_back <= '1';
                    memory_read <= '1';
                    reg_dest_selector <= "01";
                    instruction_32bit <= '1';
                    --std
                ELSIF opcode = "11100" THEN
                    read_src1 <= '1';
                    instruction_32bit <= '1';
                    memory_write <= '1';
                    --protect
                ELSIF opcode = "11101" THEN
                    read_src1 <= '1';

                    protect <= '1';
                    --free
                ELSIF opcode = "11110" THEN
                    read_src1 <= '1';
                    free <= '1';
                    memory_write <= '1';

                END IF;
            END IF;

        END IF;

    END PROCESS;
END ARCHITECTURE;