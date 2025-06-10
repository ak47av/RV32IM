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
    
    logic [8:0] control_agg;

always_comb begin
    control_agg = {
        dut.ALUselect,     // 4 bits
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
        for (int i = 0; i < 6; i++) begin
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

        // Run a few cycles
        repeat (40) begin
            @(posedge clk);
            // Optionally monitor internal state
            $display("PC: %h | Fetch: %h | Decode: %h | rs1: %0d | imm: %0h | rd: %0d | Execute: %h",
         dut.outPC, dut.ins, control_agg, dut.rsi1, dut.immediateValue, dut.rdi, dut.ALUoutput);

            print_registers();  
        end

        $display("Simulation complete.");
        $finish;
    end
    
endmodule
