`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2025 22:22:50
// Design Name: 
// Module Name: mult_postadd
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
 * Module to exploit  multiplier + postadder function of DSP48
 */

import math_pkg::adder_output_width_calculation;
import math_pkg::mult_output_width_calculation;

(* use_dsp = "yes" *)
module mult_postadd
#(
    parameter INPUT1_WIDTH = 16, // To preadder
    parameter INPUT2_WIDTH = 16, // To preadder
    parameter INPUT3_WIDTH = 16, // To multiplier
    parameter OUTPUT_WIDTH = 33
)
(
    input                                i_clk,
    
    input                                i_input_en,
    input                                i_output_mult_en,
    input                                i_output_postadder_en,
    
    input  signed [INPUT1_WIDTH - 1 : 0] i_sig1,
    input  signed [INPUT2_WIDTH - 1 : 0] i_sig2,
    input  signed [INPUT3_WIDTH - 1 : 0] i_sig3,
    
    output signed [OUTPUT_WIDTH - 1 : 0] o_sig
);

    logic signed [INPUT1_WIDTH - 1 : 0] r_sig1   = '0;
    logic signed [INPUT2_WIDTH - 1 : 0] r_sig2   = '0;
    logic signed [INPUT3_WIDTH - 1 : 0] r_sig3_1 = '0;
    logic signed [INPUT3_WIDTH - 1 : 0] r_sig3_2 = '0;
    
    localparam MULT_OUTPUT_WIDTH = mult_output_width_calculation(INPUT1_WIDTH, INPUT2_WIDTH);
    logic signed [MULT_OUTPUT_WIDTH - 1 : 0] r_mult_output = '0;
    
    localparam POSTADDER_OUTPUT_WIDTH = adder_output_width_calculation(MULT_OUTPUT_WIDTH, INPUT3_WIDTH);
    logic signed [POSTADDER_OUTPUT_WIDTH - 1 : 0] r_postadder_output = '0;
    
    always_ff @(posedge i_clk) begin : input_latch
        if (i_input_en) begin
            r_sig1 <= i_sig1;
            r_sig2 <= i_sig2;
            r_sig3_1 <= i_sig3;
        end
        if (i_output_mult_en) begin
            r_sig3_2 <= r_sig3_1;
        end
    end : input_latch
    
    always_ff @(posedge i_clk) begin : mult
        if (i_output_mult_en) begin
            r_mult_output <= r_sig1 * r_sig2;
        end
    end : mult
    
    always_ff @(posedge i_clk) begin : postadder
        if (i_output_postadder_en) begin
            r_postadder_output <= r_mult_output + r_sig3_1;
        end
    end : postadder
    
    assign o_sig = OUTPUT_WIDTH'(r_postadder_output);

endmodule : mult_postadd