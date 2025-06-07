`timescale 1ns / 1ps


module InstructionMemory #(ADDR_WIDTH=5) (
    input logic [ADDR_WIDTH-1:0] addr,
    input logic clk,
    output logic [31:0] ins_out
    );
    
    //logic  [31:0] memory [2**ADDR_WIDTH-1:0];
    //logic [31:0] ins_out;
    
    //assign ins_out = memory[addr];
    
    always_comb begin
        case(addr)
            5'd0:  ins_out = 32'h3e800093;
            5'd1:  ins_out = 32'h7d008113;
            5'd2:  ins_out = 32'hc1810193; 
            5'd3:  ins_out = 32'h83018213;
            5'd4:  ins_out = 32'h3e820293;
            // Add more instructions as needed
            default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        endcase
    end
    
//    always_ff @(posedge clk) begin
//        out <= ins_out;
//    end
    
endmodule
