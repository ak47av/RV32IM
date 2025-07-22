`timescale 1ns / 1ps

// Contains the address of the next instruction in memory
module ProgramCounter(
    input logic [31:0] inPC,
    input logic clk,
    input logic rst,
    input logic ready,
    output logic [31:0] outPCPlus1,
    output logic [31:0] outPC
    );
    
    logic [31:0] REGISTER;      // Hold the value of the PC
    
    assign outPC = REGISTER;            // Output the PC
    assign outPCPlus1 = REGISTER + 1;   // Output the next instruction
    
    
    always @(posedge clk) begin
        if (rst) begin // Reset PC to 0x00
            REGISTER <= 0;
        end else if (ready) begin // Assign next instruction to PC only if ready
            REGISTER <= inPC;
        end else begin  // Debug
            // $display("[PC] Ready low, no update REGISTER=%h", REGISTER);
        end
    end
    
endmodule

