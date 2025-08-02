`timescale 1ns / 1ps

module DataMemory_tb;

    parameter ADDRESS_WIDTH = 8;

    // Testbench signals
    logic clk;
    logic rst;
    logic [ADDRESS_WIDTH-1:0] addr;
    logic [31:0] write_data;
    logic [31:0] read_data;
    logic [ADDRESS_WIDTH-1:0] debug_addr;
    logic [7:0] debug_data;
    logic [31:0] data_out;
    logic [3:0] write_enable;

    // Instantiate the DUT
    DataMemory #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .byte_write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data),
        .debug_addr(debug_addr),
        .debug_data(debug_data)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Task: Write 32-bit word
    task write_word(input [ADDRESS_WIDTH-1:0] address, input [31:0] data);
        begin
            @(negedge clk);
            write_enable = 4'b0011;
            addr = address;
            write_data = data;
            @(negedge clk);
            write_enable = 4'b0000;
        end
    endtask

    // Task: Read 32-bit word using normal read output
    task read_word(input [ADDRESS_WIDTH-1:0] address, output [31:0] data_out);
        begin
            //@(negedge clk);
            addr = address;
            write_enable = 0;
            @(posedge clk); // wait one cycle for read_data to update
            data_out = read_data;
        end
    endtask

    // Task: Debug-read 4 bytes
    task debug_read_word(input [ADDRESS_WIDTH-1:0] address);
        begin
            $display("🔍 Debug read at addr %0d:", address);
            for (int i = 0; i < 4; i++) begin
                debug_addr = address + i;
                @(posedge clk);
                $display("    Byte [%0d] = 0x%02x", address + i, debug_data);
            end
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        addr = 0;
        write_enable = 0;
        write_data = 0;
        debug_addr = 0;

        #20;
        rst = 0;

        // === Write to memory ===
        write_word(8'd12, 32'hCAFEBABE);  // Write to addr 12
        write_word(8'd20, 32'hDEADBEEF);  // Write to addr 20

        @(posedge clk);  // Give time for write to complete

        // === Debug read (byte-wise) ===
        debug_read_word(8'd12);  // Expect BE BA FE CA
        debug_read_word(8'd20);  // Expect EF BE AD DE

        // === Normal read (word-wise) ===
        

        read_word(8'd12, data_out);
        $display("Read @ 12 = 0x%08x", data_out);
        if (data_out !== 32'hCAFEBABE) $display("ERROR: Expected 0xCAFEBABE");

        read_word(8'd20, data_out);
        $display("Read @ 20 = 0x%08x", data_out);
        if (data_out !== 32'hDEADBEEF) $display("ERROR: Expected 0xDEADBEEF");

        $display("✅ Test completed");
        $finish;
    end

endmodule
