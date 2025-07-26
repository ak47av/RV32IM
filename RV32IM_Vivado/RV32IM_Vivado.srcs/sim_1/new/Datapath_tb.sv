`timescale 1ns / 1ps

module Datapath_tb;
    
    // Clock and reset
    logic clk;
    logic rst;
   
    // Instantiate the DUT
    Datapath dut (
        .clk(clk),
        .rst(rst)
    );
    
    // To help debug control signals
    logic [9:0] control_agg;
    always_comb begin
        control_agg = {
            dut.ALUselect,     // 5 bits
            dut.regwen,        // 1 bit
            dut.IMMselect,     // 3 bits
            dut.bsel           // 1 bit
        };
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end
    
    // Task to print the first 11 registers registers for viewing their contents
    task print_registers;
    begin
        $display("Register file state:");
        $display("x[0] = 00000000 (hardwired)");
        for (int i = 1; i <= 11; i++) begin
            $display("x[%0d] = %h", i, dut.registers.x[i]);
        end
    end
    endtask
    

    // Test sequence
    initial begin
        $display("Starting Datapath simulation...");

        // Reset sequence
        rst = 1;
        #15;
        rst = 0;

        // Loop until PC reaches 32
        while (dut.outPC <= 'h70) begin
            @(posedge clk); // Wait for next clock edge
        
            if(dut.PC_changed) begin
                // Display PC, instruction, and register values
//                $display("NextPC: %h | Fetch: %h | Decode: %h | Execute: %h",
//                    dut.outPC, dut.ins, control_agg, dut.ALUoutput);
                $display("PC:%h | NextPC: %h | Instruction: %h",
                    dut.prev_outPC, dut.outPC, dut.ins);
                // Print register file contents (assuming `print_registers()` is defined)
                print_registers();
            end
        end

        $display("Simulation complete.");
        $finish;
    end
    
endmodule
