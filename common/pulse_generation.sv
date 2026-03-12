`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 11.03.2026 18:50:37
// Module Name: pulse_generation
// Project Name: common_module
// Description: 
// * Generate pulse 
// Dependencies: 
// * counter.sv
// * edge_sense.sv
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pulse_generation
#(
    parameter int unsigned PULSE_WIDTH    = 6,
    parameter              EDGE_DETECTION = "RISING" // "RISING" // "FALLING" // "BOTH"
)
(
    input  logic i_clk,
                 i_signal,
    output logic o_pulse
);
    // ----------------------------------------------------------------------------------------------
    // Declarations
    localparam COUNTER_WIDTH = $clog2(PULSE_WIDTH + 1);
    wire edge_detcted,
         counter_finished;
    // ----------------------------------------------------------------------------------------------
    // RS-latch
    RS_latch 
    #(
        .INITIAL_VALUE (  1'b0  ),
        .SYNC_OR_ASYNC ( "ASYNC" )    // "SYNC"  // "ASYNC"
    )
    RS_latch_inst
    (
        .i_clk (        '0        ),
        .i_R   ( counter_finished ),
        .i_S   (   edge_detcted   ),
        .o_Q   (      o_pulse     )
    );
    // ----------------------------------------------------------------------------------------------
    // Detect EDGE
    edge_sense
    #(
        .EDGE_TO_DETECT ( EDGE_DETECTION ) // "RISING" // "FALLING" // "BOTH"
    )
    edge_sense_inst
    (
        .i_clk,
        .i_signal (   i_signal   ),
        .o_detect ( edge_detcted )
    );
    // ----------------------------------------------------------------------------------------------
    // Counter
    counter
    #(
        .COUNTER_WIDTH      ( COUNTER_WIDTH ),
        .START_VALUE_SOURCE (  "PARAMETER"  ),  // "PARAMETER"  // "PORT"
        .START_VALUE        (       0       ),
        .FINAL_VALUE_SOURCE (     "PORT"    ),  // "PARAMETER"  // "PORT"
        .FINAL_VALUE        (  PULSE_WIDTH  )
    )
    counter_inst
    (
        .i_clk,
        .i_reset               (        '0        ),
        .i_enable              (      o_pulse     ),
        .i_start_value         (        '0        ),
        .i_final_value         (  PULSE_WIDTH + 1 ),
        .o_value               (                  ),
        .o_final_value_reached ( counter_finished )
    );
endmodule : pulse_generation
/*
    pulse_generation
    #(
        .PULSE_WIDTH    (     6    ),
        .EDGE_DETECTION ( "RISING" )  // "RISING" // "FALLING" // "BOTH"
    )
    pulse_generation_inst
    (
        .i_clk    ( ),
        .i_signal ( ),
        .o_pulse  ( )
    );
*/