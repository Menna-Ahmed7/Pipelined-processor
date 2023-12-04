USE work.reg.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY decode IS
  PORT (
    clk : IN STD_LOGIC;
    instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- registers : IN registers_block(0 TO 7)(31 DOWNTO 0);
    -- src2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- src1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
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
    src2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch_decode OF decode IS
  COMPONENT control_unit IS
    PORT (

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
      jz : OUT STD_LOGIC
    );
  END COMPONENT;
  SIGNAL read_src2 : STD_LOGIC;
  SIGNAL reg_dest_selector : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
  control : control_unit PORT MAP(instruction(15 DOWNTO 11), alu_signal, memory_read, memory_write, write_back, read_src1, read_src2, reg_dest_selector, io_read, io_write, push, pop, swap, imm, RTI, RET, call, jz);

  deocode_unit : PROCESS (clk)

  BEGIN
    IF clk'event AND clk = '0' THEN
      src1 <= instruction(10 DOWNTO 8);
      --mux to choose src2 
      IF (read_src2 = '1') THEN
        src2 <= instruction(7 DOWNTO 5);
      ELSE
        src2 <= instruction(4 DOWNTO 2);
      END IF;

      --mux to choose reg distination
      IF (reg_dest_selector = "01") THEN
        reg_dest <= instruction(10 DOWNTO 8);
      ELSIF (reg_dest_selector = "10") THEN
        reg_dest <= instruction(7 DOWNTO 5);
      ELSIF (reg_dest_selector = "11") THEN
        reg_dest <= instruction(4 DOWNTO 2);
      ELSE
        reg_dest <= (OTHERS => '0');
      END IF;
      -- src1_data <= registers(to_integer(unsigned(src1)));
      -- src2_data <= registers(to_integer(unsigned(src2)));
    END IF;
  END PROCESS;
END ARCHITECTURE;