`timescale 1ns / 1ps

// 256x8 memory or 64x32 memory
module DataMemory #(parameter ADDRESS_WIDTH = 8) (
    input  logic clk,
    input  logic rst,
    input  logic [31:0] ALUoutput,
    input  logic [3:0] byte_write_enable,    // write enable mask for bytes
    input  logic [31:0] write_data,
    output logic [31:0] read_data,
    input  logic [ADDRESS_WIDTH-1:0] debug_addr, 
    output logic [7:0] debug_data 
);

    logic [7:0] memory [(2**ADDRESS_WIDTH)-1:0];
    logic [ADDRESS_WIDTH-1:0] addr;
    
    assign addr = ALUoutput[ADDRESS_WIDTH-1:0];
    assign debug_data = memory[debug_addr]; // Debug output

    // READ
    always_comb begin
        read_data[7:0]   = memory[addr];
        read_data[15:8]  = memory[addr+1];
        read_data[23:16] = memory[addr+2];
        read_data[31:24] = memory[addr+3];
    end

    // WRITE
    always_ff @(posedge clk) begin
        if(rst) begin
            for(int i=0; i<2**ADDRESS_WIDTH ;i++) begin
                memory[i] <= 0;
            end
        end else begin
            if(byte_write_enable[0]) memory[addr]   <= write_data[7:0];
            if(byte_write_enable[1]) memory[addr+1] <= write_data[15:8];
            if(byte_write_enable[2]) memory[addr+2] <= write_data[23:16];
            if(byte_write_enable[3]) memory[addr+3] <= write_data[31:24];

            // Debug message
//            $display("[%0t ns] WRITE @ %0d = 0x%h", $time, addr, write_data);
//            $display("[%0t ns] READ @ %0d = 0x%h", $time, addr, read_data);
        end
    end
    
//    always_ff @(posedge clk) begin
//    $display("[MEM DEBUG] @%0t ns | READ addr=%0d -> %02x %02x %02x %02x",
//        $time,
//        addr,
//        memory[addr+3],
//        memory[addr+2],
//        memory[addr+1],
//        memory[addr]
//    );
//    end


endmodule

