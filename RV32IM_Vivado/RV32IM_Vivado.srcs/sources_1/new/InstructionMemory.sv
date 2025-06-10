`timescale 1ns / 1ps


module InstructionMemory #(ADDR_WIDTH=5) (
    input logic [ADDR_WIDTH-1:0] addr,
    input logic clk,
    output logic [31:0] ins_out
    );
    
    always_comb begin
        case(addr)
            5'd0:  ins_out = 32'h3e800093;
            5'd1:  ins_out = 32'h39000113;
            5'd2:  ins_out = 32'h022081b3;
            // Add more instructions as needed
            default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        endcase
    end
    
endmodule
