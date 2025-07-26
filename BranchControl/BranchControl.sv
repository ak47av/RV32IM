`timescale 1ns / 1ps

module BranchControl(
    input logic clk,
    input logic [3:0] brsel,
    input logic [31:0] immediate,
    input logic [31:0] PC,
    input logic [31:0] ALUoutput,
    output logic [31:0] PCnext,
    output logic hasBranched
    );
    
    assign PCnext = immediate + PC;
    
    // check if branch instruction
    logic isBranch;
    assign isBranch = brsel[2] | brsel[1] | brsel[0];
    
    assign hasBranched = ALUoutput[0] & isBranch;
    
    always @(posedge clk) begin
        $display("[BR] immediate: %0h | PC: %0h", immediate, PC);
        $display("[BR] PCNext: %0h | hasBranched: %0h", PCnext, hasBranched);
    end
    
endmodule
