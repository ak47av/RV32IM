`timescale 1ns / 1ps

module booth_sv;
    parameter N = 32;
    logic clk, rst;
    logic signed [N-1:0] multiplicand, multiplier;
    logic signed [2*N-1:0] out;
    logic done;
    logic [7:0] [N-1:0] BR;
    logic [N-1:0] AC;
    logic [N:0] Q;
    logic [5:0] count;

    Booth4 #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .out(out),
        .BR(BR),
        .AC(AC),
        .Q(Q),
        .count(count),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;

        // Test cases
        multiplicand = -3; multiplier = -4; #(N*6);
        multiplicand = -345; multiplier = 97; #(N*6);

        $finish;
    end
endmodule
