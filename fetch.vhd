USE work.my_pkg.ALL;

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
        jz_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        rti : IN STD_LOGIC;
        ret : IN STD_LOGIC;
        memory_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        next_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE arch_fetch OF fetch IS

    COMPONENT instruction_memory
        PORT (
            clk : IN STD_LOGIC;

            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

        );
    END COMPONENT;
    SIGNAL one : STD_LOGIC_VECTOR(31 DOWNTO 0) := (0 => '1', OTHERS => '0');
    SIGNAL two : STD_LOGIC_VECTOR(31 DOWNTO 0) := (1 => '1', OTHERS => '0');
    SIGNAL pc : STD_LOGIC_VECTOR(31 DOWNTO 0) := (1 => '1', OTHERS => '0');
    SIGNAL rti_ret : STD_LOGIC;
BEGIN

    memory_instance : instruction_memory PORT MAP(clk, pc(11 DOWNTO 0), instruction);
    rti_ret <= ret OR rti;
    fetch_unit : PROCESS (clk, RST) IS
    BEGIN
        IF RST = '1' THEN
            pc <= (1 => '1', OTHERS => '0');

        ELSIF clk'event AND clk = '1' THEN
            ---ret or rti
            IF rti_ret = '1' THEN
                pc <= memory_pc;
                next_pc <= memory_pc;

                --jump or call
            ELSIF instruction = "10010" OR instruction = "10011" THEN
                -- pc <= registers(to_integer(unsigned(instruction(22 DOWNTO 20))));
                -- next_pc <= registers(to_integer(unsigned(instruction(22 DOWNTO 20))));

                --jz
            ELSIF jz = '1' THEN
                pc <= jz_address;
                next_pc <= jz_address;

                --ret or rti  ---save 3 location with nop
            ELSIF instruction = "10100" OR instruction = "10101" THEN
                pc <= (OTHERS => '0');
                next_pc <= (OTHERS => '0');

            ELSE

                pc <= pc + one;
                next_pc <= pc + one;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;