`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 23.08.2025 10:23:27
// Module Name: BRAM
// Project Name: Memories
// Target Devices: Zynq, Artix, etc.
// Description: 
// * Module discribe Xilinx BRAM primitive
// Dependencies: 
// * BRAM_memory_intr.sv
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BRAM
#(
    parameter  int unsigned MEMORY_DEPTH     = 512,
    parameter  int unsigned MEMORY_WIDTH     = 16,
    parameter               TYPE_OF_MEMORY   = "HIGH_PERFOMANCE",   // "LOW_LATENCY"         // "HIGH_PERFOMANCE"
    parameter               MEMORY_INIT_FILE = "",
    localparam int unsigned ADDRESS_WIDTH    = $clog2(MEMORY_DEPTH) 
)
(
    BRAM_memory_intr.mem mem_bus_a,
    BRAM_memory_intr.mem mem_bus_b
);
    // -----------------------------------------------------------------------------------------------------------
    // Defenitions
    (* ram_style="block" *)
    logic [MEMORY_WIDTH - 1 : 0] memory [MEMORY_DEPTH - 1 : 0];
    logic [MEMORY_WIDTH - 1 : 0] readA_value   = '0,
                                 readA_value_z = '0,
                                 readB_value   = '0,
                                 readB_value_z = '0;
    // -----------------------------------------------------------------------------------------------------------
    // Init value logic
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
    // -----------------------------------------------------------------------------------------------------------
    // Read or write logic
    always_ff @(posedge mem_bus_a.clk) begin : memory_logic_a
        if (mem_bus_a.en) begin
            if (&{mem_bus_a.we}) begin : writeA
                memory[mem_bus_a.addr] <= mem_bus_a.din;
            end : writeA
            else begin
                readA_value <= memory[mem_bus_a.addr];
            end
        end
    end : memory_logic_a
    
    always_ff @(posedge mem_bus_b.clk) begin : memory_logic_b
        if (mem_bus_b.en) begin
            if (&{mem_bus_b.we}) begin
                memory[mem_bus_b.addr] <= mem_bus_b.din;
            end
            else begin
                readB_value <= memory[mem_bus_b.addr];
            end
        end
    end : memory_logic_b
    
    // -----------------------------------------------------------------------------------------------------------
    // Output aditional logic
    if (TYPE_OF_MEMORY == "HIGH_PERFOMANCE") begin
        always_ff @(posedge mem_bus_a.clk) begin : delay_a
            if (mem_bus_a.rst) begin
                readA_value_z <= '0;
            end
            else if (mem_bus_a.en) begin
                readA_value_z <= readA_value;
            end
        end : delay_a
        
        assign mem_bus_a.dout = readA_value_z;
        
        always_ff @(posedge mem_bus_b.clk) begin : delay_b
            if (mem_bus_b.rst) begin
                readB_value_z <= '0;
            end
            else if (mem_bus_b.en) begin
                readB_value_z <= readB_value;
            end
        end : delay_b
        
        assign mem_bus_b.dout = readB_value_z;
    end
    else if (TYPE_OF_MEMORY == "LOW_LATENCY") begin
        assign mem_bus_a.dout = readA_value;
        assign mem_bus_b.dout = readB_value;
    end
    
endmodule : BRAM
/*
    BRAM
    #(
        .MEMORY_DEPTH     (        512        ),
        .MEMORY_WIDTH     (         16        ),
        .TYPE_OF_MEMORY   ( "HIGH_PERFOMANCE" ),   // "LOW_LATENCY"         // "HIGH_PERFOMANCE"
        .MEMORY_INIT_FILE (         ""        )
    )
    BRAM_inst
    (
        .mem_bus_a ( ),
        .mem_bus_b ( )
    );
*/