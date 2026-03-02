`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 10:23:27
// Design Name: 
// Module Name: BRAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BRAM
#(
    parameter  int unsigned MEMORY_DEPTH     = 256,
    parameter  int unsigned MEMORY_WIDTH     = 16,
    parameter  string       TYPE_OF_MEMORY   = "HIGH_PERFOMANCE", // "LOW_LATENCY"         // "HIGH_PERFOMANCE"
    parameter  string       MEMORY_INIT_FILE = "",
    localparam int unsigned ADDRESS_WIDTH    = $clog2(MEMORY_DEPTH) 
)
(
    memory_intr.memModule mem_bus_a,
    memory_intr.memModule mem_bus_b
);
    logic [MEMORY_WIDTH - 1 : 0] memory [MEMORY_DEPTH - 1 : 0];
    logic [MEMORY_WIDTH - 1 : 0] readA_value   = '0,
                                 readA_value_z = '0,
                                 readB_value   = '0,
                                 readB_value_z = '0;
    
    initial begin
        if (MEMORY_INIT_FILE == "") begin
            for (int i = 0; i < MEMORY_DEPTH; i++) begin
                memory[i] <= '0;
            end
        end
        else begin
            $readmemh(MEMORY_INIT_FILE, memory, 0, MEMORY_DEPTH - 1);
        end
    end
    
    always_ff @(posedge mem_bus_a.clk) begin : memory_logic_a
        if (mem_bus_a.en) begin
            mem_bus_a.dout <= memory[mem_bus_a.addr];
        
            if (|{mem_bus_a.we}) begin : writeA
                memory[mem_bus_a.addr] <= mem_bus_a.din;
            end : writeA
        end
    end : memory_logic_a
    
    always_ff @(posedge mem_bus_b.clk) begin : memory_logic_b
        if (mem_bus_b.en) begin
            mem_bus_b.dout <= memory[mem_bus_b.addr];
            
            if (|{mem_bus_b.we}) begin
                memory[mem_bus_b.addr] <= mem_bus_b.din;
            end
        end
    end : memory_logic_b
    
    generate
        if (TYPE_OF_MEMORY == "HIGH_PERFOMANCE") begin
            always_ff @(posedge mem_bus_a.clk) begin : delay_a
                if (mem_bus_a.rst) begin
                    readA_value_z <= '0;
                end
                else begin
                    readA_value_z <= readA_value;
                end
            end : delay_a
            
            assign mem_bus_a.dout = readA_value_z;
            
            always_ff @(posedge mem_bus_b.clk) begin : delay_b
                if (mem_bus_b.rst) begin
                    readB_value_z <= '0;
                end
                else begin
                    readB_value_z <= readB_value;
                end
            end : delay_b
            
            assign mem_bus_b.dout = readB_value_z;
        end
        else if (TYPE_OF_MEMORY == "LOW_LATENCY") begin
            assign mem_bus_a.dout = readA_value;
            assign mem_bus_b.dout = readB_value;
        end
    endgenerate
    
endmodule : BRAM
