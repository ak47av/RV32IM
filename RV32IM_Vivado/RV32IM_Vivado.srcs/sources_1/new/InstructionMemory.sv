
`timescale 1ns / 1ps

// Supports 2^ADDR_WIDTH instructions, in this case 256 instructions
module InstructionMemory #(ADDR_WIDTH=8) (
    input logic [ADDR_WIDTH-1:0] addr,  // Supports 2^ADDR_WIDTH instructions, in this case 32 instructions
    output logic [31:0] ins_out         // Output of the instruction
    );
    
    // Combinatorial memory logic used instead of using AMD proprietary IP for memory
    always_comb begin
        case(addr)
            8'd0:  ins_out = 32'h00400113;
            8'd1:  ins_out = 32'h00010163;
            8'd2:  ins_out = 32'h00500193;
            8'd3:  ins_out = 32'h00009163;
            8'd4:  ins_out = 32'h00500193;
            8'd5:  ins_out = 32'h00114163;
            8'd6:  ins_out = 32'h00500193;
            8'd7:  ins_out = 32'h00116163;
            8'd8:  ins_out = 32'h00500193;
            8'd9:  ins_out = 32'h0020d163;
            8'd10:  ins_out = 32'h00500193;
            8'd11:  ins_out = 32'h0020f163;
            8'd12:  ins_out = 32'h00500193;
            default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        endcase
    end
    
endmodule

