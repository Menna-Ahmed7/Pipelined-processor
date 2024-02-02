import re
import binascii
import random 

def initializewithzeros(file_path,file_path2):
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

#initializing file with zeros
file_path = "data.txt" 
file_path2 = "instruction.txt" 
initializewithzeros(file_path,file_path2)


file = open('program.txt','r')
content=file.readlines()
file.close()
instructions=[]
for line in content:
    line = re.sub(r'#.*', '', line)
    line = line.strip()
    if line != '':
        inst_regex = re.compile(r'(([a-zA-z]+)\s*([a-zA-z0-9]*),?\s*([a-zA-z0-9]*),?\s*([a-zA-z0-9]*))|((".ORG")\s*([0-9]*)\s*\s*)', re.IGNORECASE)
        x = inst_regex.search(line.upper())
        # print('lll', x)
        if x:
                groups = x.groups()
                operation, src_register, dest_register1, dest_register2 = groups[1:5]
                if operation.upper() == '.ORG':
                        instructions.append((operation, src_register if src_register else '', '', ''))
                else:
                        instructions.append((operation, src_register if src_register else '', dest_register1 if dest_register1 else '', dest_register2 if dest_register2 else ''))

def binaryToDecimal(binary):
    # converting the string to binary using binascii
    decimal = int(binary, base=2)
    return decimal
instruction_set={'NOP':{'opcode':'00000','no_of_operands':0},
'NOT':{'opcode':'00001','no_of_operands':1},
'NEG':{'opcode':'00010','no_of_operands':1},
'INC':{'opcode':'00011','no_of_operands':1},
'DEC':{'opcode':'00100','no_of_operands':1},
'SWAP':{'opcode':'00101','no_of_operands':2},
'ADD':{'opcode':'00111','no_of_operands':3},
'SUB':{'opcode':'01000','no_of_operands':3},
'AND':{'opcode':'01001','no_of_operands':3},
'OR':{'opcode':'01010','no_of_operands':3},
'XOR':{'opcode':'01011','no_of_operands':3},
'ADDI':{'opcode':'01100','no_of_operands':3},
'CMP':{'opcode':'01101','no_of_operands':2},
'BITSET':{'opcode':'01110','no_of_operands':2},
'RCL':{'opcode':'01111','no_of_operands':2},
'RCR':{'opcode':'10000','no_of_operands':2},
'JZ':{'opcode':'10001','no_of_operands':1},
'JMP':{'opcode':'10010','no_of_operands':1},
'CALL':{'opcode':'10011','no_of_operands':1},
'RET':{'opcode':'10100','no_of_operands':0},
'RTI':{'opcode':'10101','no_of_operands':0},
'PUSH':{'opcode':'10110','no_of_operands':1},
'POP':{'opcode':'10111','no_of_operands':1},
'IN':{'opcode':'11000','no_of_operands':1},
'OUT':{'opcode':'11001','no_of_operands':1},
'LDM':{'opcode':'11010','no_of_operands':2},
'LDD':{'opcode':'11011','no_of_operands':2},
'STD':{'opcode':'11100','no_of_operands':2},
'PROTECT':{'opcode':'11101','no_of_operands':1},
'FREE':{'opcode':'11110','no_of_operands':1},
'ORG':{'opcode':'11111','no_of_operands':1}
}

registers={
'R0':'000',
'R1':'001',
'R2':'010',
'R3':'011',
'R4':'100',
'R5':'101',
'R6':'110',
'R7':'111',

}
#----------Reading Program Instructions----------

with open('instruction.txt', 'r', encoding='utf-8') as file: 
    data = file.readlines() 


for inst in instructions:
    i=0
    operation, src_register, dest_register1, dest_register2 = inst
    key = operation.upper()
    length=len([part for part in inst if part != ''])-1
    #try and except checks if instruction is in instruction_set
    try:
        opcode_info = instruction_set[key]
        no_of_operands = opcode_info['no_of_operands']
        #checking on number of operands
        if length != no_of_operands and key!='.ORG':  
            raise ValueError(f"Operation: {operation} has {length} operands, but expected {no_of_operands} according to instruction_set.")
         # Check if registers are valid and are numbers
        for register in [src_register,]:
            if (register not in registers and register!='' and not register.isdigit()and key!='.ORG') :
                raise ValueError(f"Invalid register: {register} in operation {operation}")
        # print(f"Operation: {operation}, Destination Register: {src_register}, Source Register 1: {dest_register1}, Source Register 2: {dest_register2}")
    except KeyError:
        raise ValueError(f"Operation: {operation} not found in instruction_set.")
    

#----------Creating Instruction Set----------
i=0
for inst in instructions:
        operation, destination, source1, source2 = inst
        key = operation.upper()
        length=len([part for part in inst if part != ''])-1
        opcode_str=instruction_set[key]['opcode']
        #ORG
        if operation=='ORG':
                i=int(destination, 16)-1
        #NOP
        elif binaryToDecimal(opcode_str) == binaryToDecimal('00000'):
               data[i]=opcode_str+'000'+'000'+'00000'+'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('00100'): #NOT  NEG  INC   DEC
                data[i]=opcode_str+'000'+'000'+registers[destination]+'00'+'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('00101'):  #SWAP
                data[i]=opcode_str+registers[destination]+registers[source1]+'00000'+'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('01011'):  #ADD SUB AND OR XOR
                data[i]=opcode_str+registers[source1]+registers[source2]+registers[destination]+'00'+'\n'
        elif binaryToDecimal(opcode_str) == binaryToDecimal('01100'):  #ADDI
                data[i]=opcode_str+registers[source1]+'000'+registers[destination]+'00'+'\n'
                binary_src2=source2[-16:].zfill(16)
                i=i+1
                data[i]=format(int(binary_src2,16), '016b') +'\n'
        elif binaryToDecimal(opcode_str) == binaryToDecimal('01101'):  #CMP
                data[i]=opcode_str+registers[destination]+registers[source1]+'000'+'00'+'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('10000'):  #BITSET  RCL   RCR
                data[i]=opcode_str+registers[destination]+'000'+registers[destination]+'00'+'\n'
                binary_src1=source1[-16:].zfill(16)
                i=i+1
                data[i]=format(int(binary_src1,16), '016b') +'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('10011'):  #JZ  JMP   CALL
                data[i]=opcode_str+registers[destination]+'00000000'+'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('10101'):  #RET RTI
                data[i]=opcode_str+'00000000000'+'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('11001'):  #PUSH POP IN OUT
                data[i]=opcode_str+registers[destination]+'00000000'+'\n'
        elif binaryToDecimal(opcode_str) == binaryToDecimal('11010'):  #LDM
                data[i]=opcode_str+registers[destination]+'00000000'+'\n'
                binary_src1=source1[-16:].zfill(16)
                i=i+1
                print(source1)
                data[i]=format(int(binary_src1,16), '016b') +'\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('11100'):  #LDD STD             
                binary_str=format(int(source1,16), '020b')
                #getting Least signifucant 20 bits whatever size of input
                binary_str=binary_str[-20:].zfill(20)
                data[i]=opcode_str+registers[destination]+binary_str[0:4].zfill(4)+'0000'+'\n'
                i=i+1
                data[i]=binary_str[4:20].zfill(16) + '\n'
        elif binaryToDecimal(opcode_str) <= binaryToDecimal('11110'):  #PROTECT FREE             
                data[i]=opcode_str+registers[destination]+'00000000'+'\n'
        i=i+1

        
with open('instruction.txt', 'w', encoding='utf-8') as file: 
    file.writelines(data) 


        





# for inst in instructions:
#     operation, src_register, dest_register1, dest_register2 = inst
#     try:
#         index = instruction_set.index( operation.upper())
#         print(f"Operation: {operation}, Source Register: {src_register}, Dest Register 1: {dest_register1}, Dest Register 2: {dest_register2}, Index: {index}")
#     except ValueError:
#         print(f"Operation: {operation} not found in instruction_set.")



