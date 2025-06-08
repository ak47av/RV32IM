`timescale 1ns / 1ps

module USplitter(
    input [31:0] ins,
    output [6:0] opcode,
    output [4:0] rd,
    output [19:0] imm31_12
    );
    
    assign {imm31_12, rd, opcode} = ins;
    
endmodule
