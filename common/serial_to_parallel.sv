`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 07.03.2026 17:20:24
// Module Name: serial_to_parallel
// Project Name: common_module
// Description: 
// * Module transforms serial data to parallel
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - File version of module
// Additional Comments:
// * On each clk sycle, then i_enable is HIGH, data is latched in iternal shift register
//////////////////////////////////////////////////////////////////////////////////


module serial_to_parallel
#(
    parameter int unsigned OUTPUT_WIDTH = 16,
    parameter              BIT_ORDER    = "MSB"   // "MSB"  // "LSB"
)
(
    input  logic                        i_clk,
                                        i_serial,
                                        i_reset,
                                        i_enable,
    output logic [OUTPUT_WIDTH - 1 : 0] o_parallel_data
);
    // ----------------------------------------------------------------------------------------------
    // Declarations
    logic [OUTPUT_WIDTH - 1 : 0] iternal_register = '0;
    // ----------------------------------------------------------------------------------------------
    // Basic logic
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            iternal_register <= '0;
        end
        else begin
            if (i_enable) begin
                if (BIT_ORDER == "MSB") begin
                    iternal_register[0]                    <= i_serial;
                    iternal_register[OUTPUT_WIDTH - 1 : 1] <= iternal_register[OUTPUT_WIDTH - 2 : 0];
                end
                else if (BIT_ORDER == "LSB") begin
                    iternal_register[OUTPUT_WIDTH - 1]     <= i_serial;
                    iternal_register[OUTPUT_WIDTH - 2 : 0] <= iternal_register[OUTPUT_WIDTH - 1 : 1];
                end
            end
        end
    end
    // ----------------------------------------------------------------------------------------------
    // Assign block
    assign o_parallel_data = iternal_register;
    
endmodule : serial_to_parallel
/*
    serial_to_parallel
    #(
        .OUTPUT_WIDTH (   16  ),
        .BIT_ORDER    ( "MSB" )   // "MSB"  // "LSB"
    )
    serial_to_parallel_inst
    (
        .i_clk           ( ),
        .i_serial        ( ),
        .i_reset         ( ),
        .i_enable        ( ),
        .o_parallel_data ( )
    );
*/