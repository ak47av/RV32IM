`timescale 1ns / 1ns

module booth_sv;
    parameter N = 8;
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

        $display("Starting Booth Multiplier Verification");
        // The multiplier can handle only half of the range
        // 8 bit cannot handle -128, it can handle only -64 to 64
        for (int i = -(2**(N-2))+1; i < 2**(N-2); i = i + 1) begin
            for (int j = -(2**(N-2))+1; j < 2**(N-2); j = j + 1) begin
                multiplicand = i; multiplier = j;
                while(1) begin
                    #10; // Wait for result to settle
                    if(done === 0) begin 
                        continue;
                    end else begin
                        if (out !== i*j) begin
                            $error("Mismatch: %d * %d = %d, got %d", i, j, i*j, out);
                        end
                        break;
                    end
                end
            end        
        end

        $display("Test Completed");
        
        #1000; $finish;
    end
endmodule
