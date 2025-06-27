`timescale 1ns / 1ps

module SRT_tb();
    
    parameter N = 32;
    logic rst, clk;
    logic unsigned [N-1:0] numerator, denominator;
    logic unsigned [N-1:0] quotient, remainder;
    logic [7:0] [N:0] BR;
    logic [N:0] R;
    logic [N-1:0] Q;
    logic [2:0] top3bits;
    logic [5:0] count;
    logic done;
    
    SRT2 #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .numerator(numerator),
        .denominator(denominator),
        .quotient(quotient),
        .remainder(remainder),
        .top3bits(top3bits),
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
        
        for (int i = 1; i < 5; i = i + 1) begin
            for (int j = 1; j < 5; j = j + 1) begin
                numerator = i; denominator = j;
                while(1) begin
                    #10; // Wait for result to settle
                    if(done === 0) begin 
                        continue;
                    end else begin
                        if (quotient !== i/j) begin
                            $error("Mismatch: %d \/ %d = %d, got %d", i, j, i/j, quotient);
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