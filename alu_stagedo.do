force -freeze sim:/alu_stage/imm 00000000000000000000000000000100 0
force -freeze sim:/alu_stage/write_back_data 00000000000000000000000000000101 0
force -freeze sim:/alu_stage/result_in 00000000000000000000000000000110 0
force -freeze sim:/alu_stage/src1 00000000000000000000000000000010 0
force -freeze sim:/alu_stage/src2 00000000000000000000000000000011 0
run
force -freeze sim:/alu_stage/imm_signal 0 0
run
force -freeze sim:/alu_stage/forward_unit_signal2 00 0
force -freeze sim:/alu_stage/forward_unit_signal1 00 0
run
force -freeze sim:/alu_stage/imm_signal 1 0
run
force -freeze sim:/alu_stage/forward_unit_signal1 01 0
run
force -freeze sim:/alu_stage/forward_unit_signal1 10 0
run
force -freeze sim:/alu_stage/forward_unit_signal2 01 0
run
force -freeze sim:/alu_stage/forward_unit_signal2 10 0
run
force -freeze sim:/alu_stage/forward_unit_signal2 00 0
force -freeze sim:/alu_stage/forward_unit_signal1 00 0
force -freeze sim:/alu_stage/imm_signal 0 0
force -freeze sim:/alu_stage/ALU_sig 0000 0
run
force -freeze sim:/alu_stage/ALU_sig 0001 0
run
force -freeze sim:/alu_stage/ALU_sig 0010 0
run
force -freeze sim:/alu_stage/ALU_sig 0011 0
run
force -freeze sim:/alu_stage/ALU_sig 0100 0
run



