`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 16:14:52
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input logic clk,
    input logic [4:0] rsi1,
    input logic [4:0] rsi2,
    input logic [4:0] rdi,
    input logic [31:0] rd,
    input logic write_enable,
    output logic [31:0] rs1,
    output logic [31:0] rs2
    );
    
    logic [31:0] x [31:0];
    
    assign x[0] = 0;
    
    always @(posedge clk) begin
        if(write_enable) x[rdi] <= rd;
        rs1 <= x[rsi1];
        rs2 <= x[rsi2];
    end
    
    
endmodule
