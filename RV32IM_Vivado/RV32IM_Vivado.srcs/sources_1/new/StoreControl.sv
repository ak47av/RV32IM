`timescale 1ns / 1ps

module StoreControl(
    input clk,
    input logic [1:0] ssel,
    input logic [31:0] storeWord,
    output logic [3:0] byte_enable_mask,
    output logic [31:0] storeOut
    );
    
    always_comb begin
        case(ssel)
            2'b00: begin    // do nothing
                byte_enable_mask = 4'b0000;
                storeOut = 32'b0;
            end
            2'b01: begin    // Store byte
                byte_enable_mask = 4'b0001;
                storeOut = storeWord & 32'h000000FF;
            end
            2'b10: begin    // Store half-word
                byte_enable_mask = 4'b0011;
                storeOut = storeWord & 32'h0000FFFF;
            end
            2'b11: begin    // store word
                byte_enable_mask = 4'b1111;
                storeOut = storeWord;
            end
            default: begin  // do nothing
                byte_enable_mask = 4'b0000;
                storeOut = 32'b0;
            end
        endcase 
    end
    
    always @(posedge clk) begin
//        $display("[ST] storeOut:%0h ", storeOut);
    end
    
endmodule
