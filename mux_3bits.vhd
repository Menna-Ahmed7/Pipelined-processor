Library ieee;
Use ieee.std_logic_1164.all;

entity mux_3bits IS
port (
IN1,IN2,IN3:IN std_logic_vector(31 downto 0);
SEL:IN std_logic_vector (1 downto 0);

SELECTED:OUT std_logic_vector (31 downto 0)
);
end entity;

Architecture arch_mux_3bits of mux_3bits IS
begin 


SELECTED <= IN1 WHEN sel="00" ELSE
    IN2 WHEN SEL="01" else
    IN3 WHEN SEL="10";
    

end Architecture;
