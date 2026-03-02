`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov. D. A.
// 
// Create Date: 17.08.2025 22:22:50
// Design Name: 
// Module Name: add
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

/*
 * Module to realize adder base on LUTs or DSP48E
 */

import math_pkg::adder_output_width_calculation;

module add
#(
    parameter REALIZATION  = "DSP48", // "DSP48" // "LUT"
    parameter INPUT1_WIDTH = 16,
    parameter INPUT2_WIDTH = 16,
    parameter OUTPUT_WIDTH = 17
)
(
    input                                i_clk,
    
    input                                i_input1_en,
    input                                i_input2_en,
    input                                i_output_en,
    
    input  signed [INPUT1_WIDTH - 1 : 0] i_sig1,
    input  signed [INPUT2_WIDTH - 1 : 0] i_sig2,
    
    output signed [OUTPUT_WIDTH - 1 : 0] o_sig
);
    
    logic signed [INPUT1_WIDTH - 1 : 0] r_sig1 = '0;
    logic signed [INPUT2_WIDTH - 1 : 0] r_sig2 = '0;
    
    localparam TRUE_OUTPUT_WIDTH = adder_output_width_calculation(INPUT1_WIDTH, INPUT2_WIDTH);
    (* use_dsp = "no"  *) logic signed [TRUE_OUTPUT_WIDTH - 1 : 0] r_add_output_lut = '0;
    
    (* use_dsp = "yes" *) logic signed [TRUE_OUTPUT_WIDTH - 1 : 0] r_add_output_dsp = '0;
    
    always_ff @(posedge i_clk) begin : latch_inputs
        if (i_input1_en) begin
            r_sig1 <= i_sig1;
        end
        if (i_input2_en) begin
            r_sig2 <= i_sig2;
        end
    end : latch_inputs
    
    if (REALIZATION == "LUT") begin
        always_ff @(posedge i_clk) begin : LUT_adder
            if (i_output_en) begin
                r_add_output_lut <= r_sig1 + r_sig2;
            end
        end : LUT_adder
        
        assign o_sig = OUTPUT_WIDTH'(r_add_output_lut);
    end
    else if (REALIZATION == "DSP48") begin
        always_ff @(posedge i_clk) begin : DSP_adder
            if (i_output_en) begin
                r_add_output_dsp <= r_sig1 + r_sig2;
            end
        end : DSP_adder
        
        assign o_sig = OUTPUT_WIDTH'(r_add_output_dsp);
    end
    
    
endmodule : add

// Template
/*
add
#(
    .REALIZATION  ( "DSP48" ), // "DSP48" // "LUT"
    .INPUT1_WIDTH (   16    ),
    .INPUT2_WIDTH (   16    ),
    .OUTPUT_WIDTH (   17    )
)
add_inst
(
    .i_clk       ( ),
                 
    .i_input1_en ( ),
    .i_input2_en ( ),
    .i_output_en ( ),
                 
    .i_sig1      ( ),
    .i_sig2      ( ),
                 
    .o_sig       ( )
);  
*/  