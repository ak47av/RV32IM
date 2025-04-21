`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 17:15:38
// Design Name: 
// Module Name: WordAddressableMemory
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


module WordAddressableMemory #(parameter IN=9, parameter OUT=19) (
    input logic [IN-1:0] index,
    output logic [OUT-1:0] out
    );
    
    logic [OUT-1:0] memory [2**IN];
    
    assign out = memory[index];
    
endmodule
