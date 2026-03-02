`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2025 23:41:35
// Design Name: 
// Module Name: coeff_bram
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

`include "../memories/BRAM.svh"

module coeff_bram
#(
    parameter int unsigned NUM_OF_COEFFS         = 26,
    parameter int unsigned WIDTH_OF_COEFFS       = 16,
    parameter string       COEFFICIENT_FILE_NAME = "",
    
    localparam int unsigned COEFF_NUM_WIDTH = $clog2(NUM_OF_COEFFS)
)
(
    input                            i_clk,
    
    input  [COEFF_NUM_WIDTH - 1 : 0] i_coeff_num,
    
    output [WIDTH_OF_COEFFS - 1 : 0] o_coeff
);
    
    memory_intr
    #(
        .MEMORY_WIDTH ( WIDTH_OF_COEFFS ),
        .MEMORY_DEPTH (  NUM_OF_COEFFS  )
    ) 
    mem_bus
    ( 
    
    );
    
    assign mem_bus.clk  = i_clk;
    assign mem_bus.addr = i_coeff_num;
    assign o_coeff      = mem_bus.dout;
    assign mem_bus.din  = '0;
    assign mem_bus.en   = 1'b1;
    assign mem_bus.rst  = 1'b0;
    assign mem_bus.we   = 1'b0;
    
    memory_intr mem ();
    
    BRAM
    #(
        .MEMORY_DEPTH     (     NUM_OF_COEFFS     ),
        .MEMORY_WIDTH     (    WIDTH_OF_COEFFS    ),
        .TYPE_OF_MEMORY   (     "LOW_LATENCY"     ), // "LOW_LATENCY"         // "HIGH_PERFOMANCE"
        .MEMORY_INIT_FILE ( COEFFICIENT_FILE_NAME )
    )
    (
        .mem_bus_a ( mem_bus.memModule ) ,
        .mem_bus_b (   mem   )
    );
    
endmodule : coeff_bram
