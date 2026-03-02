`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 10:17:50
// Design Name: 
// Module Name: CIC_filter
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


module CIC_filter
#(
    parameter FILTER_ORDER          = 10,
    parameter INPUT_WIDTH           = 16,
    parameter COEFFICIENT_WIDTH     = 28,
    parameter OUTPUT_WIDTH          = 32,
    parameter COEFFICIENT_FILE_NAME = ""
)
(
    input                                i_clk,
    
    input                                i_en,
    input  signed [INPUT_WIDTH  - 1 : 0] i_sig,
    
    output                               o_valid,
    output signed [OUTPUT_WIDTH - 1 : 0] o_sig
    
);
    // Additional parameters calculations
    localparam NUM_OF_COEFF   = FILTER_ORDER;
    localparam NUM_OF_DELAYS  = FILTER_ORDER;
    // Coefficient bram
    logic signed [COEFFICIENT_WIDTH - 1 : 0] coeffs = '0;
    
    memory_intr
    #( 
        .MEMORY_WIDTH ( COEFFICIENT_WIDTH ),
        .MEMORY_DEPTH (    NUM_OF_COEFF   )
    )
    mem_bus_coeff 
    ( 
    
    );

    assign mem_bus_coeff.clk = i_clk;

    BRAM
    #(
        .MEMORY_DEPTH     (      NUM_OF_COEFF     ),
        .MEMORY_WIDTH     (   COEFFICIENT_WIDTH   ),
        .TYPE_OF_MEMORY   (     "LOW_LATENCY"     ), // "LOW_LATENCY"         // "HIGH_PERFOMANCE"
        .MEMORY_INIT_FILE ( COEFFICIENT_FILE_NAME )
    )
    BRAM_coeff_inst
    (
        .memBusA ( mem_bus_coeff )
    );

    memory_intr
    #( 
        .MEMORY_WIDTH (  INPUT_WIDTH  ),
        .MEMORY_DEPTH ( NUM_OF_DELAYS )
    )
    mem_bus_data
    (
    
    );
    
    assign mem_bus_data.clk = i_clk;
    assign mem_bus_data.din = i_sig;
    
    BRAM
    #(
        .MEMORY_DEPTH     ( NUM_OF_DELAYS ),
        .MEMORY_WIDTH     (  INPUT_WIDTH  ),
        .TYPE_OF_MEMORY   ( "LOW_LATENCY" ), // "LOW_LATENCY"         // "HIGH_PERFOMANCE"
        .MEMORY_INIT_FILE (       ""      )
    )
    BRAM_data_inst
    (
        .memBusA ( mem_bus_data )
    );

endmodule : CIC_filter
