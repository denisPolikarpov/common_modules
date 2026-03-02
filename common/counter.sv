`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 10:23:27
// Design Name: 
// Module Name: BRAM
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

module counter
#(
    parameter int unsigned COUNTER_WIDTH = 8 
)
(
    input  logic                         i_clk,
    input  logic                         i_reset,
    input  logic                         i_enable,
    output logic [COUNTER_WIDTH - 1 : 0] o_value
);
    // -----------------------------------------------
    // Declarations
    logic [COUNTER_WIDTH - 1 : 0] cn = '0;
    // -----------------------------------------------
    // 
    always_ff @(posedge i_clk) begin : counter_logic
        if (i_reset) begin
            cn <= '0;
        end
        else begin
            if (i_enable) begin
                cn <= cn + 1'b1;
            end
        end
    end : counter_logic
    // -----------------------------------------------
    assign o_value = cn;
    
endmodule : counter
/*
    counter
    #(
        .COUNTER_WIDTH ( 8 )   
    )
    counter_inst
    (
        .i_clk    ( ),
        .i_reset  ( ),
        .i_enable ( ),
        .o_value  ( )
    );
*/