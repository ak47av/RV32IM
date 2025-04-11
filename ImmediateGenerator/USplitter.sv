`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 14:51:49
// Design Name: 
// Module Name: USplitter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module USplitter(
    input [31:0] ins,
    output [6:0] opcode,
    output [4:0] rd,
    output [19:0] imm31_12
    );
    
    assign {imm31_12, rd, opcode} = ins;
    
endmodule
