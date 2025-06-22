module DIV_REM_tb();
    logic clk, rst;
    logic [1:0] op;
    logic [31:0] numerator, denominator;
    logic [31:0] quotient, remainder;
    logic done;

    SRT2 uut (.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #10 rst = 0;

        // Test DIV (signed division)
        op = 2'b00;
        numerator = 20; denominator = 5;
        wait(done);
        assert(quotient === 4) else begin
            $display("[DIV] FAIL: 20 / 5 = %0d (Expected: 4)", quotient);
            $finish;
        end
        $display("[DIV] PASS: 20 / 5 = %0d", quotient);

        rst = 1;
        #10 rst = 0;
        numerator = -20; denominator = 5;
        wait(done);
        assert(quotient === -4) else begin
            $display("[DIV] FAIL: -20 / 5 = %0d (Expected: -4)", quotient);
            $finish;
        end
        $display("[DIV] PASS: -20 / 5 = %0d", quotient);

        rst = 1;
        #10 rst = 0;
        // Test DIVU (unsigned division)
        op = 2'b01;
        numerator = 32'hFFFFFFF0; denominator = 16;
        wait(done);
        assert(quotient === 32'h0FFFFFFF) else begin
            $display("[DIVU] FAIL: 0xFFFFFFF0 / 16 = 0x%0h (Expected: 0x0FFFFFFF)", quotient);
            $finish;
        end
        $display("[DIVU] PASS: 0xFFFFFFF0 / 16 = 0x%0h", quotient);

        rst = 1;
        #10 rst = 0;
        // Test REM (signed remainder)
        op = 2'b10;
        numerator = -7; denominator = 3;
        wait(done);
        assert(remainder === -1) else begin
            $display("[REM] FAIL: -7 %% 3 = %0d (Expected: -1)", remainder);
            $finish;
        end
        $display("[REM] PASS: -7 %% 3 = %0d", remainder);

        rst = 1;
        #10 rst = 0;
        // Test REMU (unsigned remainder)
        op = 2'b11;
        numerator = 7; denominator = 3;
        wait(done);
        assert(remainder === 1) else begin
            $display("[REMU] FAIL: 7 %% 3 = %0d (Expected: 1)", remainder);
            $finish;
        end
        $display("[REMU] PASS: 7 %% 3 = %0d", remainder);
        
        #100;

        $display("All tests passed!");
        $finish;
    end
endmodule