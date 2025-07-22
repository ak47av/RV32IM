`timescale 1ns / 1ps

// Supports 2^ADDR_WIDTH instructions, in this case 32 instructions
module InstructionMemory #(ADDR_WIDTH=5) (
    input logic [ADDR_WIDTH-1:0] addr,  // Supports 2^ADDR_WIDTH instructions, in this case 32 instructions
    output logic [31:0] ins_out         // Output of the instruction
    );
    
    // Combinatorial memory logic used instead of using AMD proprietary IP for memory
    always_comb begin
        case(addr)
            5'd0:  ins_out = 32'hea000093;
            5'd1:  ins_out = 32'h15c00113;
            5'd2:  ins_out = 32'h02116233;
            5'd3:  ins_out = 32'h02117333;
            5'd4:  ins_out = 32'h021141b3;
            5'd5:  ins_out = 32'h021152b3;
            5'd6:  ins_out = 32'h021103b3;
            5'd7:  ins_out = 32'h02111433;
            5'd8:  ins_out = 32'h021134b3;
            5'd9:  ins_out = 32'h02112533;
            default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        endcase
    end
    
endmodule
