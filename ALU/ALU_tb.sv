`timescale 1ns / 1ps

module ALU_tb;

    logic clk, rst;
    logic [31:0] dataA, dataB;
    logic [4:0] sel;
    logic [31:0] dataD;
    logic ready;

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

    task reset();
        begin
            rst = 1;
            clk = 0;
            #10;
            rst = 0;
        end
    endtask

    task run_mul_test(input [31:0] a, input [31:0] b, input [4:0] op, string name);
        begin
            dataA = a;
            dataB = b;
            sel = op;
            wait(!ready);
            @(posedge clk);
            wait (ready);
            $display("[%s] A = %0h, B = %0h, dataD = 0x%08X", name, a, b, dataD);
            #10;
        end
    endtask
    
    task run_div_test(input [31:0] a, input [31:0] b, input [4:0] op, string name);
        begin
            dataA = a;
            dataB = b;
            sel = op;
            wait(!ready);
            @(posedge clk);
            wait (ready);
            $display("[%s] A = %0h, B = %0h, dataD = 0x%08X", name, a, b, dataD);
            #10;
        end
    endtask
    

    initial begin
        reset();

        // Test cases
        //run_mul_test(-32'sd2, 32'sd3, 5'h1E, "MUL   ");       // 3 * 5 = 15 -> lower 32 bits
        //run_mul_test(-32'sd2, 32'sd3, 5'h11, "MULHSU");      // -2 * 3 = -6 -> upper 32 bits
        //run_mul_test(-32'sd2, 32'sd3, 5'h1F, "MULH  "); // -2 * -3 = 0
        //run_mul_test(-32'sd4, -32'sd3, 5'h10, "MULHU "); // -2 * -3 = 0xfffffffb
        
        //run_div_test(-32'sd56, 32'sd18, 5'h12, "DIV  ");
        //run_div_test(-32'sd56, 32'sd18, 5'h14, "REM  ");
        //run_div_test(-32'sd56, 32'sd18, 5'h13, "DIVU  ");
        //run_div_test(-32'sd56, 32'sd18, 5'h15, "REMU  ");

        $display("All tests finished.");
        $finish;
    end

endmodule
