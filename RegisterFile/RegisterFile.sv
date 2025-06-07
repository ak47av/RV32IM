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
    input logic rst,
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
    
    // Write logic
    always_ff @(posedge clk) begin
        if (rst) begin
            // Initialize all registers to 0
            for (int i = 0; i < 32; i++) begin
                x[i] <= 32'd0;
            end
        end else begin
            if (write_enable && rdi != 5'd0) begin
                x[rdi] <= rd;
            end
        end
    end
    
    // Read logic
    always_comb begin
        rs1 = (rsi1 == 5'd0) ? 32'd0 : x[rsi1];
        rs2 = (rsi2 == 5'd0) ? 32'd0 : x[rsi2];
    end
    
    
endmodule
