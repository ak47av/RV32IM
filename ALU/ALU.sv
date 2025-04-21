`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 16:42:51
// Design Name: 
// Module Name: ALU
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


module ALU(
    input logic [31:0] dataA,
    input logic [31:0] dataB,
    input logic [3:0] sel,
    output logic [31:0] dataD
    );
    
    always @(*) begin
        case(sel)
            'h0: dataD = dataA + dataB;         // ADD  - Addition
            'h1: dataD = dataA << dataB[4:0];   // SLL  - Shift left logical
            'h2: dataD = $signed(dataA) < $signed(dataB) ? 1:0; // SLT  - Set lesser than
            'h3: dataD = $unsigned(dataA) < $unsigned(dataB) ? 1:0;    // SLTU - Set lesser than unsigned
            'h4: dataD = dataA ^ dataB;         // XOR - logical XOR
            'h5: dataD = dataA >> dataB[4:0];   // SRL - Shift Right Logical
            'h6: dataD = dataA || dataB;        // OR - logical OR
            'h7: dataD = dataA && dataB;        // AND - logical AND 
            'h8: dataD = dataA - dataB;         // SUB - Subtraction
            'h9: dataD = dataA != dataB ? 1:0;  // NEQ - not equal to
            'hA: dataD = dataA == dataB ? 1:0;  // EQ - equal to
            'hB: dataD = $signed(dataA) >= $signed(dataB) ? 1:0;     // GE - Greater than signed
            'hC: dataD = $unsigned(dataA) >= $unsigned(dataB) ? 1:0; // GEU - Greater than unsgined
            'hD: dataD = dataA >>> dataB[4:0];   // SRA - Shift right arithmetic 
            'hE: dataD = 0; // unused
            'hF: dataD = 0; // unused
        endcase
    end
    
    
endmodule
