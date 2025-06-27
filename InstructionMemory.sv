
`timescale 1ns / 1ps

module InstructionMemory #(ADDR_WIDTH=5) (
    input logic [ADDR_WIDTH-1:0] addr,
    input logic clk,
    output logic [31:0] ins_out
    );
    
    always_comb begin
        case(addr)
            5'd0:  ins_out = 32'he3600093;
            5'd1:  ins_out = 32'h2a600113;
            5'd2:  ins_out = 32'h021141b3;
            5'd3:  ins_out = 32'h02116233;
            5'd4:  ins_out = 32'h021152b3;
            5'd5:  ins_out = 32'h02117333;
            default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        endcase
    end
    
endmodule
