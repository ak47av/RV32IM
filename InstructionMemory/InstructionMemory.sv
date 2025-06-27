`timescale 1ns / 1ps

module InstructionMemory #(ADDR_WIDTH=5) (
    input logic [ADDR_WIDTH-1:0] addr,
    output logic [31:0] ins_out
    );
    
     always_comb begin
        case(addr)
            5'd0:  ins_out = 32'h01200093;
            5'd1:  ins_out = 32'hfc800113;
            5'd2:  ins_out = 32'h021101b3;
            5'd3:  ins_out = 32'h02111233;
            5'd4:  ins_out = 32'h021142b3;
            5'd5:  ins_out = 32'h02116333;
            5'd6:  ins_out = 32'h021153b3;
            5'd7:  ins_out = 32'h02117433;
            default: ins_out = 32'h00000013; // NOP (addi x0, x0, 0)
        endcase
    end
    
endmodule
