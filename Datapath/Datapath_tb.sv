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
    
    task print_registers;
    begin
        $display("Register file state:");
        $display("x[0] = 00000000 (hardwired)");
        for (int i = 1; i < 10; i++) begin
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
        while (dut.outPC != 32) begin
            @(posedge clk); // Wait for next clock edge
        
            if(dut.PC_changed) begin
                // Display PC, instruction, and register values
                $display("NextPC: %h | Fetch: %h | Decode: %h | Execute: %h",
                    dut.outPC, dut.ins, control_agg, dut.ALUoutput);
        
                // Print register file contents (assuming `print_registers()` is defined)
                print_registers();
            end
        end

        $display("Simulation complete.");
        $finish;
    end
    
endmodule
