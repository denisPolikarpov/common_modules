`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 02.03.2026 20:09:01
// Design Name: 
// Module Name: comporator
// Project Name: common_module
// Target Devices: 
// Tool Versions: 
// Description: 
// * general comporator
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - First version of module
// Additional Comments:
// * Module can compare signal with constant or with another signal (CONSTANT_OR_SIGNAL)
// * Compare operation can be different (OPPERATION_TYPE "GT"  - ">",
// *                                                     "GEQ" - ">=",
// *                                                     "LT"  - "<",
// *                                                     "LEQ" - "<=",
// *                                                     "EQ"  - "==")
//////////////////////////////////////////////////////////////////////////////////


module comporator
#(
    parameter int unsigned INPUT_WIDTH        = 16,
    parameter              OPPERATION_TYPE    = "GT",      // "GT"  // "GEQ"  // "LT"  // "LEQ"  // "EQ"
    parameter              CONSTANT_OR_SIGNAL = "SIGNAL",  // "CONSTANT"  // "SIGNAL"
    parameter              COMPARE_CONSTANT   = 0,
    parameter              REGISTER_OUTPUT    = "REGISTER" // "REGISTER"  // "NO-REGISTER"
)
(
    input  logic                              i_clk,
    input  logic signed [INPUT_WIDTH - 1 : 0] i_signal,
    input  logic signed [INPUT_WIDTH - 1 : 0] i_compare_with,
    output logic                              o_compare_results
);
    // -----------------------------------------------
    // Declarations
    logic compare_results;
    logic signed [INPUT_WIDTH - 1 : 0] compare_with;
    
    if (CONSTANT_OR_SIGNAL == "CONSTANT") begin
        assign compare_with = COMPARE_CONSTANT;
    end
    else if (CONSTANT_OR_SIGNAL == "SIGNAL") begin
        assign compare_with = i_compare_with;
    end
    // -----------------------------------------------
    // Compare logic
    if (OPPERATION_TYPE == "GT") begin
        assign compare_results = i_signal > compare_with ? 1'b1 : 1'b0;
    end
    else if (OPPERATION_TYPE == "GEQ") begin
        assign compare_results = i_signal >= compare_with ? 1'b1 : 1'b0;
    end
    else if (OPPERATION_TYPE == "LT") begin
        assign compare_results = i_signal < compare_with ? 1'b1 : 1'b0;
    end
    else if (OPPERATION_TYPE == "LEQ") begin
        assign compare_results = i_signal <= compare_with ? 1'b1 : 1'b0;
    end
    else if (OPPERATION_TYPE == "EQ") begin
        assign compare_results = i_signal == compare_with ? 1'b1 : 1'b0;
    end
    // -----------------------------------------------
    // Output logic
    if (REGISTER_OUTPUT == "REGISTER") begin
        always_ff @(posedge i_clk) begin : register
            o_compare_results <= compare_results;
        end : register
    end
    else if (REGISTER_OUTPUT == "NO-REGISTER") begin
        assign o_compare_results = compare_results;
    end
endmodule : comporator
/*
    comporator
    #(
        .INPUT_WIDTH        (     16     ),
        .OPPERATION_TYPE    (    "GT"    ),  // "GT"  // "GEQ"  // "LT"  // "LEQ"  // "EQ"
        .CONSTANT_OR_SIGNAL (  "SIGNAL"  ),  // "CONSTANT"  // "SIGNAL"
        .COMPARE_CONSTANT   (      0     ),
        .REGISTER_OUTPUT    ( "REGISTER" )   // "REGISTER"  // "NO-REGISTER"
    )
    comporator_inst
    (
        .i_clk             ( ),
        .i_signal          ( ),
        .i_compare_with    ( ),
        .o_compare_results ( )
    );
*/