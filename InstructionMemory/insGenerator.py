def generate_imem_from_file(input_file="ins.txt", output_file="InstructionMemory.sv", addr_width=8):
    """
    Generate SystemVerilog InstructionMemory from a text file containing hex instructions.
    
    Args:
        input_file (str): Input text file with one hex instruction per line (e.g., "0x021101B3").
        output_file (str): Output SystemVerilog filename.
        addr_width (int): Address bus width (default: 5 bits = 32 entries).
    """
    # Read instructions from file
    with open(input_file, "r") as f:
        instructions = [line.strip() for line in f if line.strip()]
    
    # Generate SystemVerilog module
    module_header = f"""
`timescale 1ns / 1ps

// Supports 2^ADDR_WIDTH instructions, in this case {2**addr_width} instructions
module InstructionMemory #(ADDR_WIDTH={addr_width}) (
    input logic [ADDR_WIDTH-1:0] addr,  // Supports 2^ADDR_WIDTH instructions, in this case 32 instructions
    output logic [31:0] ins_out         // Output of the instruction
    );
    
    // Combinatorial memory logic used instead of using AMD proprietary IP for memory
    always_comb begin
        case(addr)"""

    module_footer = """
            default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        endcase
    end
    
endmodule
"""

    with open(output_file, "w") as f:
        f.write(module_header)
        
        for i, ins in enumerate(instructions):
            ins_clean = ins.lower().replace("0x", "").strip()  # Remove "0x" and whitespace
            f.write(f"\n            {addr_width}'d{i}:  ins_out = 32'h{ins_clean};")
        
        f.write(module_footer)
    
    print(f"Generated {output_file} with {len(instructions)} instructions from {input_file}.")

# Run the script
if __name__ == "__main__":
    generate_imem_from_file(input_file="ins.txt")