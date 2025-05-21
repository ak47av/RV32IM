`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2025 14:04:36
// Design Name: 
// Module Name: SRT_sv
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


module SRT_sv();
    
    parameter N = 32;
    logic rst, clk;
    logic signed [N-1:0] numerator, denominator;
    logic signed [N-1:0] quotient, remainder;
    logic [N:0] BR [15:0];
    logic [N:0] R;
    logic [N+1:0] Q;
    logic [3:0] top4bits;
    logic [5:0] count;
    logic done;
    
    SRT4 #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .numerator(numerator),
        .denominator(denominator),
        .quotient(quotient),
        .remainder(remainder),
        .top4bits(top4bits),
        .BR(BR),
        .R(R),
        .Q(Q),
        .count(count),
        .done(done)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        #5 rst = 0;
        
        for (int i = 1; i < 10; i = i + 1) begin
            for (int j = 1; j < 5; j = j + 1) begin
                numerator = i; denominator = j;
                while(1) begin
                    #10; // Wait for result to settle
                    if(done === 0) begin 
                        continue;
                    end else begin
                        if (quotient !== i/j) begin
                            $error("Mismatch: %d / %d = %d, got %d", i, j, i/j, quotient);
                        end
                        if (remainder !== i%j) begin
                            $error("Mismatch: %d \% %d = %d, got %d", i, j, i%j, remainder);
                        end
                        break;
                    end
                end
            end        
        end
        
        #1000; $finish;
        
    end
    
endmodule
