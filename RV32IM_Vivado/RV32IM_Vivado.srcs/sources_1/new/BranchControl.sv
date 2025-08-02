`timescale 1ns / 1ps

module BranchControl(
    input logic clk,
    input logic [3:0] brsel,
    input logic [31:0] immediate,
    input logic [31:0] PC,
    input logic [31:0] ALUoutput,
    input logic [31:0] rs1,
    output logic [31:0] PCnext,
    output logic hasJumped,
    output logic hasBranched,
    output logic [31:0] returnAddress
    );
    
    logic [31:0] jalrNext, jalNext, branchNext;
    assign jalrNext = (rs1 + immediate) & ~(32'b1);
    assign jalNext = immediate + PC;
    assign branchNext = immediate + PC;
    
    // check if branch instruction
    logic isBranch;
    assign isBranch = brsel[2] | brsel[1] | brsel[0];
    
    assign hasBranched = ALUoutput[0] & isBranch;
    assign hasJumped = brsel[3];
    
    logic isJalr;
    assign isJalr = (brsel[3] & ~brsel[0]); 
    assign PCnext = isJalr ? jalrNext : 
                            (isBranch) ? branchNext : jalNext;
    //assign PCNext = jalNext;
    
    //write back to rd if jmp;
    assign returnAddress = PC + 4;
    
    always @(posedge clk) begin
//        $display("[BR] immediate: %0h | PC: %0h", immediate, PC);
//        $display("[BR] JalrNext: %0h | isJalr: %0h", jalrNext, isJalr);
//        $display("[BR] PCNext: %0h | hasBranched: %0h | hasJumped: %0h", PCnext, hasBranched, hasJumped);
    end
    
endmodule
