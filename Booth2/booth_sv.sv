`timescale 1ns / 1ps

module booth_sv;
    parameter N = 32;
    logic clk, rst;
    logic signed [N-1:0] multiplicand, multiplier;
    logic signed [2*N-1:0] out;
    logic done;

    Booth2 #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .out(out),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;

        // Test cases
        multiplicand = -3; multiplier = -4; #(N*11);
        multiplicand = -345; multiplier = 97; #(N*11);

        $finish;
    end
endmodule
