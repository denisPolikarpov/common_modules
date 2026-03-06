`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Polikarpov D. A.
// 
// Create Date: 02.03.2026 19:40:46
// Design Name: 
// Module Name: parallel_to_serial
// Project Name: common_module
// Target Devices: 
// Tool Versions: 
// Description: 
// * Module transforms parallel data to serial
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - File version of module
// Additional Comments:
// * Then i_latch is HIGH, data of i_parallel_data pin is latched.
// * After each tile then i_shift is HIGH new data bit is set to output
// * Module allows to choose direction of bits (MSB - from most significant,
// *                                            LSB - from least significant)
//////////////////////////////////////////////////////////////////////////////////


module parallel_to_serial
#(
    parameter int unsigned INPUT_WIDTH = 16,
    parameter              BIT_ORDER   = "LSB" // "MSB" // "LSB"
)
(
    input  logic                       i_clk,
    input  logic [INPUT_WIDTH - 1 : 0] i_parallel_data,
    input  logic                       i_latch,
    input  logic                       i_shift,
    output logic                       o_serial_data
);
    // -----------------------------------------------
    // Declarations
    logic [INPUT_WIDTH - 1 : 0] iternal_register = '0;
    // -----------------------------------------------
    // Basic logic
    always_ff @(posedge i_clk) begin
        if (i_latch) begin
            iternal_register <= i_parallel_data;
        end
        else begin
            if (i_shift) begin
                if (BIT_ORDER == "MSB") begin
                    iternal_register[0]                   <= '0;
                    iternal_register[INPUT_WIDTH - 1 : 1] <= iternal_register[INPUT_WIDTH - 2 : 0];
                end
                else if (BIT_ORDER == "LSB") begin
                    iternal_register[INPUT_WIDTH - 1]     <= '0;
                    iternal_register[INPUT_WIDTH - 2 : 0] <= iternal_register[INPUT_WIDTH - 1 : 1];
                end
            end
        end
    end
    // -----------------------------------------------
    // Assign block
    if (BIT_ORDER == "MSB") begin
        assign o_serial_data = iternal_register[INPUT_WIDTH - 1];
    end
    else if (BIT_ORDER == "LSB") begin
        assign o_serial_data = iternal_register[0];
    end
    
endmodule : parallel_to_serial
/*
    parallel_to_serial
    #(
        .INPUT_WIDTH (   16  ),
        .BIT_ORDER   ( "MSB" )  // "MSB" // "LSB"
    )
    parallel_to_serial_inst
    (
        .i_clk           ( ),
        .i_parallel_data ( ),
        .i_latch         ( ),
        .i_shift         ( ),
        .o_serial_data   ( )
    );
*/