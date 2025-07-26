#def generate_imem_from_file(input_file="ins.txt", output_file="InstructionMemory.sv", addr_width=8):
    #"""
    #Generate SystemVerilog InstructionMemory from a text file containing hex instructions.
    
    #Args:
        #input_file (str): Input text file with one hex instruction per line (e.g., "0x021101B3").
        #output_file (str): Output SystemVerilog filename.
        #addr_width (int): Address bus width (default: 5 bits = 32 entries).
    #"""
    ## Read instructions from file
    #with open(input_file, "r") as f:
        #instructions = [line.strip() for line in f if line.strip()]
    
    ## Generate SystemVerilog module
    #module_header = f"""
#`timescale 1ns / 1ps

#// Supports 2^ADDR_WIDTH instructions, in this case {2**addr_width} instructions
#module InstructionMemory #(ADDR_WIDTH={addr_width}) (
    #input logic [ADDR_WIDTH-1:0] addr,  // Supports 2^ADDR_WIDTH instructions, in this case 32 instructions
    #output logic [31:0] ins_out         // Output of the instruction
    #);
    
    #// Combinatorial memory logic used instead of using AMD proprietary IP for memory
    #always_comb begin
        #case(addr)"""

    #module_footer = """
            #default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        #endcase
    #end
    
#endmodule
#"""

    #with open(output_file, "w") as f:
        #f.write(module_header)
        
        #for i, ins in enumerate(instructions):
            #ins_clean = ins.lower().replace("0x", "").strip()  # Remove "0x" and whitespace
            #f.write(f"\n            {addr_width}'d{i}:  ins_out = 32'h{ins_clean};")
        
        #f.write(module_footer)
    
    #print(f"Generated {output_file} with {len(instructions)} instructions from {input_file}.")

## Run the script
#if __name__ == "__main__":
    #generate_imem_from_file(input_file="ins.txt")

# generate_ins_memory.py

def parse_instructions(filename):
    instructions = []
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            # Remove '0x' prefix if present and parse as hex
            if line.startswith('0x') or line.startswith('0X'):
                line = line[2:]
            instructions.append(int(line, 16))
    return instructions

def generate_sv(instructions, addr_width=8, output_file='InstructionMemory.sv'):
    num_words = 2**(addr_width - 2)
    lines = []

    lines.append(f'module InstructionMemory #(\n    parameter ADDR_WIDTH = {addr_width}\n) (\n    input logic [ADDR_WIDTH-1:0] addr,    // byte address input\n    output logic [31:0] ins_out\n);\n')
    lines.append(f'    logic [ADDR_WIDTH-3:0] word_addr; // word-aligned address\n')
    lines.append('    always_comb begin\n')
    lines.append('        word_addr = addr[ADDR_WIDTH-1:2];  // divide by 4 for instruction index\n\n        case (word_addr)')

    for i in range(min(len(instructions), num_words)):
        ins_hex = f'32\'h{instructions[i]:08X}'
        lines.append(f'            {addr_width-2}\'d{i}:  ins_out = {ins_hex};')

    lines.append('            default: ins_out = 32\'h00000013; // NOP (addi x0,x0,0)')
    lines.append('        endcase\n    end\n\nendmodule\n')

    with open(output_file, 'w') as f:
        f.write('\n'.join(lines))

    print(f"Generated {output_file} with {len(instructions)} instructions.")

if __name__ == "__main__":
    instructions = parse_instructions('ins.txt')
    generate_sv(instructions)
