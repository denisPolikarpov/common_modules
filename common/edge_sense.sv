`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 02.03.2026 18:24:23
// Design Name: 
// Module Name: edge_sense
// Project Name: common_module
// Target Devices: 
// Tool Versions: 
// Description: 
// * Module can detect edges of 1-bit signal.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module edge_sense
#(
    parameter EDGE_TO_DETECT = "BOTH" // "RISING" // "FALLING" // "BOTH"
)
(
    input  logic i_clk,
    input  logic i_signal,
    output logic o_detect
);
    // -----------------------------------------------
    // Declarations
    logic signal_delayed = '0;
    // -----------------------------------------------
    // Basic logic
    always_ff @(posedge i_clk) begin : delay
        signal_delayed <= i_signal;
    end : delay
    // -----------------------------------------------
    // Assign block
    if (EDGE_TO_DETECT == "RISING") begin
        assign o_detect = (~signal_delayed) && i_signal ? 1'b1 : 1'b0;
    end
    else if (EDGE_TO_DETECT == "FALLING") begin
        assign o_detect = signal_delayed && (~i_signal) ? 1'b1 : 1'b0;
    end
    else if (EDGE_TO_DETECT == "BOTH") begin
        assign o_detect = signal_delayed ^ i_signal ? 1'b1 : 1'b0;
    end
endmodule : edge_sense
