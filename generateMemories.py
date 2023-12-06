import random 
  
file_path = "data.txt" 
file_path2 = "instruction.txt" 
  
num_words = 4096  
  
with open(file_path, "w") as file: 
     for i in range(num_words): 
         hex_val = format(0, '016X') 
         file.write(hex_val) 
         if i < num_words - 1: 
           file.write('\n') 

with open(file_path2, "w") as file: 
     for i in range(num_words): 
         hex_val = format(0, '016X') 
         file.write(hex_val) 
         if i < num_words - 1: 
           file.write('\n') 
  
print(f"File '{file_path}' generated successfully.")
print(f"File '{file_path2}' generated successfully.")