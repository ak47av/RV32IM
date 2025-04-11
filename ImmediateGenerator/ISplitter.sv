`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 14:38:42
// Design Name: 
// Module Name: ISplitter
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


module ISplitter(
    input logic [31:0] ins,
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [11:0] imm11_0
    );
    
    assign {imm11_0, rs1, funct3, rd, opcode} = ins;
    
endmodule
