`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 14:54:53
// Design Name: 
// Module Name: JSplitter
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


module JSplitter(
    input  logic [31:0] ins,
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [7:0] imm19_12,
    output logic imm11,
    output logic [9:0] imm10_1,
    output logic imm20
    );
    
    assign {imm20, imm10_1, imm11, imm19_12, rd, opcode} = ins;
    
endmodule
