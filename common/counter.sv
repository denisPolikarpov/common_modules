`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Polikarpov D. A.
// 
// Create Date: 23.08.2025 10:23:27
// Module Name: BRAM
// Project Name: common_module
// Description: 
// * Basic counter
// Dependencies: 
// * comporator.sv
// Revision:
// Revision 0.01 - File Created
//          0.02 - First version of module
//          0.03 - Parameter final value
//          0.04 - Port final value
//          0.04 - Final value pulse
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module counter
#(
    parameter int unsigned COUNTER_WIDTH      = 8,
    parameter              FINAL_VALUE_SOURCE = "PORT", // "PARAMETER"  // "PORT"
    parameter int unsigned FINAL_VALUE        = 2**8 - 1
)
(
    input  logic                         i_clk,
                                         i_reset,
                                         i_enable,
           logic [COUNTER_WIDTH - 1 : 0] i_final_value,
    output logic [COUNTER_WIDTH - 1 : 0] o_value,
           logic                         o_final_value_reached
);
    // -----------------------------------------------
    // Declarations
    // Counter value output
    logic [COUNTER_WIDTH - 1 : 0] cn = '0;
    
    logic final_value_reached,   // Reset when counter reached it's final value
          counter_reset;         // Counter reset signal
    
    // -----------------------------------------------
    // Basic logic
    assign counter_reset = i_reset || final_value_reached;
    
    always_ff @(posedge i_clk) begin : counter_logic
        if (counter_reset) begin
            cn <= '0;
        end
        else begin
            if (i_enable) begin
                cn <= cn + 1'b1;
            end
        end
    end : counter_logic
    
    if (FINAL_VALUE_SOURCE == "PARAMETER") begin
        comporator
        #(
            .INPUT_WIDTH        ( COUNTER_WIDTH ),
            .OPPERATION_TYPE    (      "EQ"     ),  // "GT"  // "GEQ"  // "LT"  // "LEQ"  // "EQ"
            .CONSTANT_OR_SIGNAL (   "CONSTANT"  ),  // "CONSTANT"  // "SIGNAL"
            .COMPARE_CONSTANT   (  FINAL_VALUE  ),
            .REGISTER_OUTPUT    ( "NO-REGISTER" )   // "REGISTER"  // "NO-REGISTER"
        )
        comporator_parameter_final_value
        (
            .i_clk,
            .i_signal          (          cn         ),
            .i_compare_with    (          '0         ),
            .o_compare_results ( final_value_reached )
        );
    end
    else if (FINAL_VALUE_SOURCE == "PORT") begin
        comporator
        #(
            .INPUT_WIDTH        ( COUNTER_WIDTH ),
            .OPPERATION_TYPE    (      "EQ"     ),  // "GT"  // "GEQ"  // "LT"  // "LEQ"  // "EQ"
            .CONSTANT_OR_SIGNAL (    "SIGNAL"   ),  // "CONSTANT"  // "SIGNAL"
            .COMPARE_CONSTANT   (  FINAL_VALUE  ),
            .REGISTER_OUTPUT    ( "NO-REGISTER" )   // "REGISTER"  // "NO-REGISTER"
        )
        comporator_port_final_value
        (
            .i_clk,
            .i_signal          (          cn         ),
            .i_compare_with    (    i_final_value    ),
            .o_compare_results ( final_value_reached )
        );
    end
    // -----------------------------------------------
    // Assign block
    assign o_value = cn;
    assign o_final_value_reached = final_value_reached;
    
endmodule : counter
/*
    counter
    #(
        .COUNTER_WIDTH      (      8      ),
        .FINAL_VALUE_SOURCE ( "PARAMETER" ), // "PARAMETER"  // "PORT"
        .FINAL_VALUE        (   2**8 - 1  )
    )
    counter_inst
    (
        .i_clk                 ( ),
        .i_reset               ( ),
        .i_enable              ( ),
        .i_final_value         ( ),
        .o_value               ( ),
        .o_final_value_reached ( )
    );
*/