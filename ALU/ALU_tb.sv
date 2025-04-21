`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 16:20:22
// Design Name: 
// Module Name: ALU_tb
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


`timescale 1ns/1ps

module ALU_tb;

    logic [31:0] dataA;
    logic [31:0] dataB;
    logic [3:0]  sel;
    logic [31:0] dataD;

    // Instantiate the ALU
    ALU uut (
        .dataA(dataA),
        .dataB(dataB),
        .sel(sel),
        .dataD(dataD)
    );

    task test(input [3:0] s, input [31:0] a, input [31:0] b, input [31:0] expected);
        begin
            sel = s;
            dataA = a;
            dataB = b;
            #1;
            if (dataD !== expected)
                $display("FAILED: sel=%h, A=%0d, B=%0d -> D=%0d (expected %0d)", s, a, b, dataD, expected);
            else
                $display("PASSED: sel=%h, A=%0d, B=%0d -> D=%0d", s, a, b, dataD);
        end
    endtask

    initial begin
        // Test ADD
        test(4'h0, 10, 20, 30);

        // Test SLL
        test(4'h1, 8, 2, 32);

        // Test SLT
        test(4'h2, -5, 3, 1);
        test(4'h2, 5, -3, 0);

        // Test SLTU
        test(4'h3, 32'hFFFFFFFE, 5, 0);
        test(4'h3, 3, 5, 1);

        // Test XOR
        test(4'h4, 32'hF0F0F0F0, 32'h0F0F0F0F, 32'hFFFFFFFF);

        // Test SRL
        test(4'h5, 32'h80000000, 1, 32'h40000000);

        // Test OR
        test(4'h6, 1, 0, 1);
        test(4'h6, 0, 0, 0);

        // Test AND
        test(4'h7, 1, 1, 1);
        test(4'h7, 1, 0, 0);

        // Test SUB
        test(4'h8, 20, 5, 15);

        // Test NEQ
        test(4'h9, 5, 5, 0);
        test(4'h9, 5, 4, 1);

        // Test EQ
        test(4'hA, 10, 10, 1);
        test(4'hA, 10, 11, 0);

        // Test GE (signed)
        test(4'hB, -2, -3, 1);
        test(4'hB, -3, -2, 0);

        // Test GEU (unsigned)
        test(4'hC, 32'hFFFFFFFE, 1, 1);
        test(4'hC, 1, 32'hFFFFFFFE, 0);

        // Test SRA
        test(4'hD, 32'hF0000000, 4, 32'hFF000000); // should preserve sign

        // Unused
        test(4'hE, 0, 0, 0);
        test(4'hF, 123, 456, 0);

        $finish;
    end

endmodule

