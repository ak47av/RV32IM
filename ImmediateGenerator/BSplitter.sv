`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 14:58:17
// Design Name: 
// Module Name: BSplitter
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


module BSplitter(
    input logic [31:0] ins,
    output logic [6:0] opcode,
    output logic imm11,
    output logic [3:0] imm4_1,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [5:0] imm10_5,
    output logic imm12
    );
    
    assign {imm12, imm10_5, rs2, rs1, funct3, imm4_1, imm11, opcode} = ins;
    
endmodule
