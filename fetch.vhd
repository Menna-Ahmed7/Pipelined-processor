USE work.my_pkg.ALL;
USE std.env.finish;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.reg.ALL;
ENTITY fetch IS
    PORT (
        clk : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        jz : IN STD_LOGIC;
        zeroFlag : IN STD_LOGIC;
        rti : IN STD_LOGIC;
        ret : IN STD_LOGIC;
        jump : IN STD_LOGIC;
        call : IN STD_LOGIC;
        memory_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_pc : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_fetch OF fetch IS

    COMPONENT instruction_memory
        PORT (
            clk : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL one : STD_LOGIC_VECTOR(31 DOWNTO 0) := (0 => '1', OTHERS => '0');
    SIGNAL two : STD_LOGIC_VECTOR(31 DOWNTO 0) := (1 => '1', OTHERS => '0');
    SIGNAL pc : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rti_ret : STD_LOGIC;
BEGIN

    memory_instance : instruction_memory PORT MAP(clk, RST, pc(11 DOWNTO 0), instruction);
    rti_ret <= ret OR rti;

    fetch_unit : PROCESS (clk, RST) IS
        CONSTANT constant_value : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111111";
    BEGIN
        IF pc >= "00000000000000000001000000000000" THEN
            finish;
        END IF;

        IF RST = '1' THEN
            pc <= (OTHERS => '0');

        ELSIF clk'event AND clk = '0' THEN

            IF (call = '1' OR jump = '1' OR (jz='1' and zeroFlag='1') ) THEN
                pc <= alu_pc;
                next_pc <= alu_pc;

            ELSE
                pc <= pc + one;
                next_pc <= pc + one;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;