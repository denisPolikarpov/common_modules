`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Polikarpov D. A.
// 
// Create Date: 02.03.2026 20:09:01
// Module Name: clk_gen
// Project Name: common_module
// Description: 
// * Generate clock signal
// Dependencies: 
// * counter.sv
// * comporator.sv
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - First version of module
// Additional Comments:
// * 
//////////////////////////////////////////////////////////////////////////////////


module clk_gen
#(
    parameter int unsigned MAIN_CLK_FREQ = 120000000,
    parameter int unsigned REQ_CLK_FREQ  = 20000000
)
(
    input  logic i_clk,
                 i_enable,
    output logic o_gen_clk
);
    // -----------------------------------------------
    // Declarations
    localparam int unsigned CLK_RATIO = MAIN_CLK_FREQ / REQ_CLK_FREQ;
    localparam int unsigned CN_WIDTH  = $clog2(CLK_RATIO);
    logic [CN_WIDTH - 1 : 0] cn_output;
    
    logic half_period;
    // -----------------------------------------------
    // Basic logic
    counter
    #(
        .COUNTER_WIDTH      (     CN_WIDTH    ),
        .FINAL_VALUE_SOURCE (   "PARAMETER"   ), // "PARAMETER"  // "PORT"
        .FINAL_VALUE        (  CLK_RATIO - 1  )  
    )
    counter_inst
    (
        .i_clk,
        .i_reset       (   ~i_enable   ),
        .i_enable      (    i_enable   ),
        .i_final_value (       '0      ),
        .o_value       (   cn_output   )
    );
    
    comporator
    #(
        .INPUT_WIDTH        (  CN_WIDTH + 1 ),
        .OPPERATION_TYPE    (     "GEQ"     ),  // "GT"  // "GEQ"  // "LT"  // "LEQ"  // "EQ"
        .CONSTANT_OR_SIGNAL (   "CONSTANT"  ),  // "CONSTANT"  // "SIGNAL"
        .COMPARE_CONSTANT   ( CLK_RATIO / 2 ),
        .REGISTER_OUTPUT    (   "REGISTER"  )   // "REGISTER"  // "NO-REGISTER"
    )
    comporator_inst
    (
        .i_clk,
        .i_signal          ( {1'b0, cn_output} ),
        .i_compare_with    (         '0        ),
        .o_compare_results (    half_period    )
    );
    // -----------------------------------------------
    // Assign block
    assign o_gen_clk = half_period;
    
endmodule : clk_gen
/*
    clk_gen
    #(
        .MAIN_CLK_FREQ ( 120000000 ),
        .REQ_CLK_FREQ  ( 20000000  )
    )
    clk_gen_inst
    (
        .i_clk     ( ),
        .i_enable  ( ),
        .o_gen_clk ( )
    );
*/