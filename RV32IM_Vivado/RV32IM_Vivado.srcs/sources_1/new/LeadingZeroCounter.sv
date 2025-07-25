`timescale 1ns / 1ps

// Refer to Stack overflow: https://stackoverflow.com/questions/2368680/count-leading-zero-in-single-cycle-datapath
module LeadingZeroCounter(
    input logic [31:0] in,
    output logic [4:0] out
    );
    
    logic [15:0] val16;
    logic [7:0] val8;
    logic [3:0] val4;
    
    // Calculate normalization shift amount
    always_comb begin
        out[4] = (in[31:16] == 16'b0);
        val16 = out[4] ? in[15:0] : in[31:16];
        out[3] = (val16[15:8] == 8'b0);
        val8 = out[3] ? val16[7:0] : val16[15:8];
        out[2] = (val8[7:4] == 4'b0);
        val4 = out[2] ? val8[3:0] : val8[7:4];
        out[1] = (val4[3:2] == 2'b0);
        out[0] = out[1] ? ~val4[1] : ~val4[3];
    end
    
endmodule
