`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 17:29:38
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input logic [31:0] inPC,
    input logic clk,
    input logic rst,
    output logic [31:0] outPCPlus1,
    output logic [31:0] outPC
    );
    
    logic [31:0] REGISTER;
    
    assign outPC = REGISTER;
    assign outPCPlus1 = REGISTER + 1;
    
    always @(posedge clk) begin
        if(!rst) REGISTER <= 0;
        else REGISTER <= inPC;
    end
    
endmodule
