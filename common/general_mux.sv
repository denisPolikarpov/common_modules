`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 08.03.2026 11:51:42
// Module Name: general_mux
// Project Name: common_module
// Description: 
// * Standart synchronous mux
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - First version of module
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module general_mux
#(
    parameter  int unsigned INPUT_WIDTH       = 16,
    parameter  int unsigned NUM_OF_SIGNALS    = 4,
    localparam int unsigned CTRL_SIGNAL_WIDTH = $clog2(NUM_OF_SIGNALS)
)
(
    input  logic                             i_clk,
           logic [CTRL_SIGNAL_WIDTH - 1 : 0] i_ctrl,
           logic [INPUT_WIDTH       - 1 : 0] i_signals [NUM_OF_SIGNALS - 1 : 0],
    output logic [INPUT_WIDTH       - 1 : 0] o_signal
);

    always_ff @(posedge i_clk) begin : mux
        o_signal <= i_signals[i_ctrl];
    end : mux
    
endmodule : general_mux
/*
    general_mux
    #(
        .INPUT_WIDTH    ( 16 ),
        .NUM_OF_SIGNALS (  4 )
    )
    general_mux_inst
    (
        .i_clk     ( ),
        .i_ctrl    ( ),
        .i_signals ( ),
        .o_signal  ( )
    );
*/