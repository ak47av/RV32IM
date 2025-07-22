`timescale 1ns / 1ps

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
    
    // 32-bit Registers from x1 to x31
    logic [31:0] x [1:31];
    
    // Write logic
    always_ff @(posedge clk) begin
        if (rst) begin
            // Initialize all registers to 0 when reset
            for (int i = 1; i < 32; i++) begin
                x[i] <= 32'd0;
            end
        end else begin
            // Write only WE and not x0
            if (write_enable && rdi != 5'd0) begin
                x[rdi] <= rd;
            end
        end
    end
    
    // Read logic
    always_comb begin
        // Return 0x00 if read from x0
        rs1 = (rsi1 == 5'd0) ? 32'd0 : x[rsi1];
        rs2 = (rsi2 == 5'd0) ? 32'd0 : x[rsi2];
    end
    
    
endmodule

