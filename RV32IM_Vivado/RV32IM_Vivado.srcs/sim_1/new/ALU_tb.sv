`timescale 1ns / 1ps

module ALU_tb;

    logic clk, rst;
    logic [31:0] dataA, dataB;
    logic [4:0] sel;
    logic [31:0] dataD;
    logic ready;
    logic [31:0] A, B;

    ALU dut (
        .clk(clk),
        .rst(rst),
        .dataA(dataA),
        .dataB(dataB),
        .sel(sel),
        .dataD(dataD),
        .ready(ready)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Pulse the reset signal
    task reset();
        begin
            rst = 1;
            clk = 0;
            #10;
            rst = 0;
        end
    endtask
    
    // Test multiplication
    task run_mul_test(input [31:0] a, input [31:0] b, input [4:0] op, string name);
        begin
            dataA = a;
            dataB = b;
            sel = op;
            reset();
            wait(!ready);
            @(posedge clk);
            wait (ready);
            $display("[%s] A = %0h, B = %0h, output = 0x%08X", name, a, b, dataD);
            #10;
        end
    endtask
    
    // Test division
    task run_div_test(input [31:0] a, input [31:0] b, input [4:0] op, string name);
        begin
            dataA = a;
            dataB = b;
            sel = op;
            reset();
            wait(!ready);
            @(posedge clk);
            wait (ready);
            $display("[%s] A = %0h, B = %0h, output = 0x%08X", name, a, b, dataD);
            #10;
        end
    endtask
    

    initial begin
        reset();

        // Test cases
        A = 348; B = -352;
        run_mul_test(A, B, 5'h1E, "MUL   ");
        run_mul_test(A, B, 5'h1F, "MULH  ");
        run_mul_test(A, B, 5'h18, "MULHU ");
        run_mul_test(A, B, 5'h19, "MULHSU");
        
        run_div_test(A, B, 5'h12, "DIV  ");
        run_div_test(A, B, 5'h14, "REM  ");
        run_div_test(A, B, 5'h13, "DIVU  ");
        run_div_test(A, B, 5'h15, "REMU  ");

        $display("All tests finished.");
        $finish;
    end

endmodule
