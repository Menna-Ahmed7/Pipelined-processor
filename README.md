# pipelined processor   <img src="https://projects.ce.pdn.ac.lk/data/categories/co502/thumbnail.jpg"  width="60"/>

##  Overview
*   A 5-stage  von Neumann pipelined processor.
*   The processor has a RISC-like instruction set architecture.
*   There are eight 4-byte general purpose registers from R0, to R7.
*   Another two specific registers, (PC) And (SP).
*   handles instruction, data And control hazards efficiently.

## ⛏️Built with   
  <img  src="https://www.shutterstock.com/image-illustration/programming-term-vhdl-very-high-600nw-571579909.jpg"  width="90" />

## Design

## ISA  
 
| Category | SubCategory | Instruction | Opcode |
| -------- | ----------- | ----------- | ------ |
| NOP      | \-          | NOP         | 00000  |
| ALU      | 1D          | NOT         | 00001  |
| ALU      | 1D          | NEG         | 00010  |
| ALU      | 1D          | INC         | 00011  |
| ALU      | 1D          | DEC         | 00100  |
| ALU      | 2S          | SWAP        | 00101  |
| ALU      | 2S,1D       | ADD         | 00111  |
| ALU      | 2S,1D       | SUB         | 01000  |
| ALU      | 2S,1D       | AND         | 01001  |
| ALU      | 2S,1D       | OR          | 01010  |
| ALU      | 2S,1D       | XOR         | 01011  |
| ALU      | 1D,1S,1IMM  | ADDI        | 01100  |
| ALU      | 2S          | CMP         | 01101  |
| ALU      | 1D, 1 IMM   | BITSET      | 01110  |
| ALU      | 1D,1IMM     | RCL         | 01111  |
| ALU      | 1D,1IMM     | RCR         | 10000  |
| BRANCH   | 1S          | JZ          | 10001  |
| BRANCH   | 1S          | JMP         | 10010  |
| BRANCH   | 1S          | CALL        | 10011  |
| BRANCH   | 0D          | RET         | 10100  |
| BRANCH   | 0D          | RTI         | 10101  |
| MEMORY   | 1S          | PUSH        | 10110  |
| MEMORY   | 1D          | POP         | 10111  |
| MEMORY   | 1D          | IN          | 11000  |
| MEMORY   | 1D          | OUT         | 11001  |
| MEMORY   | 1D,1IMM     | LDM         | 11010  |
| MEMORY   | 1D, 1EA     | LDD         | 11011  |
| MEMORY   | 1S, 1EA     | STD         | 11100  |
| MEMORY   | 1S          | PROTECT     | 11101  |
| MEMORY   | 1S          | FREE        | 11110  |

 
## Control Signals 

| Instruction | ALU-Signal | Memory-Read | Memory-Write | Write-Back | Read-Source1 | Read-Source2 | Register-destination-selector | IOW | IOR | Push | Pop | swap | immediate | RTI | RET | CALL | JZ | free | protect |
| ----------- | ---------- | ----------- | ------------ | ---------- | ------------ | ------------ | ----------------------------- | --- | --- | ---- | --- | ---- | --------- | --- | --- | ---- | -- | ---- | ------- |
| NOP         | 0000       | 0           | 0            | 0          | 0            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| NOT         | 0001       | 0           | 0            | 1          | 0            | 0            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| NEG         | 0010       | 0           | 0            | 1          | 0            | 0            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| INC         | 0011       | 0           | 0            | 1          | 0            | 0            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| DEC         | 0100       | 0           | 0            | 1          | 0            | 0            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| swap        | 0101       | 0           | 0            | 1          | 1            | 1            | 11                            | 0   | 0   | 0    | 0   | 1    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| ADD         | 0111       | 0           | 0            | 1          | 1            | 1            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| SUB         | 1000       | 0           | 0            | 1          | 1            | 1            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| AND         | 1001       | 0           | 0            | 1          | 1            | 1            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| OR          | 1010       | 0           | 0            | 1          | 1            | 1            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| XOR         | 1011       | 0           | 0            | 1          | 1            | 1            | 11                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| ADDI        | 0111       | 0           | 0            | 1          | 1            | 0            | 10                            | 0   | 0   | 0    | 0   | 0    | 1         | 0   | 0   | 0    | 0  | 0    | 0       |
| CMP         | 1000       | 0           | 0            | 0          | 1            | 1            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| BITSET      | 1100       | 0           | 0            | 1          | 0            | 0            | 10                            | 0   | 0   | 0    | 0   | 0    | 1         | 0   | 0   | 0    | 0  | 0    | 0       |
| RCL         | 1101       | 0           | 0            | 1          | 0            | 0            | 10                            | 0   | 0   | 0    | 0   | 0    | 1         | 0   | 0   | 0    | 0  | 0    | 0       |
| RCR         | 1110       | 0           | 0            | 1          | 0            | 0            | 10                            | 0   | 0   | 0    | 0   | 0    | 1         | 0   | 0   | 0    | 0  | 0    | 0       |
| JZ          | 0000       | 0           | 0            | 0          | 1            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 1  | 0    | 0       |
| JMP         | 0000       | 0           | 0            | 0          | 1            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| CALL        | 0000       | 0           | 1            | 0          | 1            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 1    | 0  | 0    | 0       |
| RET         | 0000       | 1           | 0            | 0          | 0            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 1   | 0    | 0  | 0    | 0       |
| RTI         | 0000       | 1           | 0            | 0          | 0            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 1   | 0   | 0    | 0  | 0    | 0       |
| PUSH        | 0000       | 0           | 1            | 0          | 1            | 0            | xx                            | 0   | 0   | 1    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| POP         | 0000       | 1           | 0            | 1          | 0            | 0            | 01                            | 0   | 0   | 0    | 1   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| IN          | 0000       | 0           | 0            | 1          | 0            | 0            | 01                            | 0   | 1   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| OUT         | 0000       | 0           | 0            | 0          | 1            | 0            | xx                            | 1   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| LDM         | 0000       | 0           | 0            | 1          | 0            | 0            | 01                            | 0   | 0   | 0    | 0   | 0    | 1         | 0   | 0   | 0    | 0  | 0    | 0       |
| LDD         | 0000       | 1           | 0            | 1          | 0            | 0            | 01                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| STD         | 0000       | 0           | 1            | 0          | 1            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 0       |
| PROTECT     | 0000       | 0           | 0            | 0          | 1            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 0    | 1       |
| FREE        | 0000       | 0           | 0            | 0          | 1            | 0            | xx                            | 0   | 0   | 0    | 0   | 0    | 0         | 0   | 0   | 0    | 0  | 1    | 0       |


## Documentation
*  [TA Documentation](https://docs.google.com/document/d/1NzsI2fDJsi1E8828_TZ3FRXXH-PkuSAhBtgeXXxag0s/edit)
*  [Architecture_Project_F23](https://special-vest-753.notion.site/Arch-b26d926f424b4d1b9beca01b71f7ace1?pvs=4)

## Contributors  
<table  align='center'> 
<tr>
    <td align="center">
        <a href="https://github.com/Menna-Ahmed7">
            <img src="https://avatars.githubusercontent.com/u/110634473?v=4" width="100;"alt="Menna-Ahmed7"/>
            <br />
            <sub><b>Menna</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/EmanElbedwihy">
            <img src="https://avatars.githubusercontent.com/u/120182209?v=4" width="100;" alt="EmanElbedwihy"/>
            <br />
            <sub><b>Eman</b></sub>
        </a>
    </td>
        <td align="center">
        <a href="https://github.com/nesma-shafie">
            <img src="https://avatars.githubusercontent.com/u/120175134?v=4" width="100;" alt="nesma-shafie"/>
            <br />
            <sub><b>Nesma</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Sara-Gamal1">
            <img src="https://avatars.githubusercontent.com/u/106556638?v=4" width="100;" alt="Sara-Gamal1"/>
            <br />
            <sub><b>Sara</b></sub>
        </a>
    </td></tr>
</table>


  