`timescale 1ns / 1ps

module ProgramCounter(
    input logic [31:0] inPC,
    input logic clk,
    input logic rst,
    input logic ready,
    output logic [31:0] outPCPlus1,
    output logic [31:0] outPC
    );
    
    logic [31:0] REGISTER;
    
    assign outPC = REGISTER;
    assign outPCPlus1 = REGISTER + 1;
    
//    always @(posedge clk) begin
//        if(rst) REGISTER <= 0;
//        else if (ready) REGISTER <= inPC;
//    end
    
    always @(posedge clk) begin
    if (rst) begin
        REGISTER <= 0;
        //$display("[PC] Reset REGISTER to 0");
    end else if (ready) begin
        REGISTER <= inPC;
        //$display("[PC] Updated REGISTER to %h at time %0t", inPC, $time);
    end else begin
       // $display("[PC] Ready low, no update REGISTER=%h", REGISTER);
    end
end
    
endmodule
