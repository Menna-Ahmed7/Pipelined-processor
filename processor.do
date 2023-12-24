add wave -position end  sim:/processor/CLK
add wave -position end  sim:/processor/RST
add wave -position end  sim:/processor/next_pc
add wave -position end  sim:/processor/out_port
add wave -position end  sim:/processor/in_port
add wave -position end  sim:/processor/result_alu
add wave -position end  sim:/processor/final_CCR
add wave -position end  sim:/processor/dataout
add wave -position end  sim:/processor/reg_file_instance/registers
add wave -position end  sim:/processor/memory_instance/memory_instance/ram
add wave -position end  sim:/processor/alu_instance/obj3/ALU_signal
add wave -position end  sim:/processor/out_alu_signal
force -freeze sim:/processor/forward_unit_signal1 00 0
force -freeze sim:/processor/forward_unit_signal2 00 0
force -freeze sim:/processor/RST 0 0
force -freeze sim:/processor/clk 1 1, 0 {51 ps} -r 100
force -freeze sim:/processor/in_port 10#7 0
