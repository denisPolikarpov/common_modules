`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 08.03.2026 18:26:44
// Module Name: RS_latch
// Project Name: common_module
// Description: 
// * Standart RS latch
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RS_latch
#(
    parameter bit INITIAL_VALUE = 1'b0
)
(
    input  logic i_clk,
                 i_R,
                 i_S,
    output logic o_Q
);
    logic iternal_reg = INITIAL_VALUE;
    
    always_ff @(posedge i_clk) begin
        if (i_R) begin
            iternal_reg <= '0;
        end
        if (i_S) begin
            iternal_reg <= '1;
        end
    end
    
    assign o_Q = iternal_reg;
    
endmodule : RS_latch
/*
    RS_latch 
    #(
        .INITIAL_VALUE ( 1'b0 )
    )
    RS_latch_inst
    (
        .i_clk ( ),
        .i_R   ( ),
        .i_S   ( ),
        .o_Q   ( )
    );
*/