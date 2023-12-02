
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY control_unit IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
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
        jz : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch_control_unit OF control_unit IS

BEGIN
    PROCESS (opcode) IS
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
        alu_signal <= opcode(3 DOWNTO 0);

        --not
        IF opcode = "00001" THEN
            write_back <= '1';
            reg_dest_selector <= "11";

            --neg
        ELSIF opcode = "00010" THEN
            write_back <= '1';
            reg_dest_selector <= "11";

            --inc
        ELSIF opcode = "00011" THEN
            write_back <= '1';
            reg_dest_selector <= "11";

            --dec
        ELSIF opcode = "00100" THEN
            write_back <= '1';
            reg_dest_selector <= "11";

            --swap1
        ELSIF opcode = "00101" THEN
            write_back <= '1';
            swap <= '1';
            read_src1 <= '1';
            read_src2 <= '1';
            reg_dest_selector <= "11";

            --swap2
        ELSIF opcode = "00110" THEN
            write_back <= '1';
            swap <= '1';
            reg_dest_selector <= "01";

            --add
        ELSIF opcode = "00111" THEN
            write_back <= '1';
            read_src1 <= '1';
            read_src2 <= '1';
            reg_dest_selector <= "11";

            --sub
        ELSIF opcode = "01000" THEN
            write_back <= '1';
            read_src1 <= '1';
            read_src2 <= '1';
            reg_dest_selector <= "11";

            --and
        ELSIF opcode = "01001" THEN
            write_back <= '1';
            read_src1 <= '1';
            read_src2 <= '1';
            reg_dest_selector <= "11";

            --or
        ELSIF opcode = "01010" THEN
            write_back <= '1';
            read_src1 <= '1';
            read_src2 <= '1';
            reg_dest_selector <= "11";

            --xor
        ELSIF opcode = "01011" THEN
            write_back <= '1';
            read_src1 <= '1';
            read_src2 <= '1';
            reg_dest_selector <= "11";

            --addi
        ELSIF opcode = "01100" THEN
            write_back <= '1';
            read_src1 <= '1';
            imm <= '1';
            reg_dest_selector <= "10";
            --cmp
        ELSIF opcode = "01101" THEN
            read_src1 <= '1';
            read_src2 <= '1';

            --bitset
        ELSIF opcode = "01110" THEN
            write_back <= '1';
            imm <= '1';
            reg_dest_selector <= "10";

            --rcl
        ELSIF opcode = "01111" THEN
            write_back <= '1';
            imm <= '1';
            reg_dest_selector <= "10";

            --rcr
        ELSIF opcode = "10000" THEN
            write_back <= '1';
            imm <= '1';
            reg_dest_selector <= "10";

            --jz
        ELSIF opcode = "10001" THEN
            jz <= '1';

            --jmp
        ELSIF opcode = "10010" THEN
            read_src1 <= '1';

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

            --lld
        ELSIF opcode = "11011" THEN
            write_back <= '1';
            memory_read <= '1';
            reg_dest_selector <= "01";

            --std
        ELSIF opcode = "11100" THEN
            write_back <= '1';
            read_src1 <= '1';

            --protect
        ELSIF opcode = "11101" THEN

            --free
        ELSE

        END IF;
    END PROCESS;
END ARCHITECTURE;
