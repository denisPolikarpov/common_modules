`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 09.03.2026 19:41:56
// Module Name: delay
// Project Name: common_module
// Description: 
// * Basic register based delay
// Revision:
// Revision 0.01 - File Created
//          0.02 - First version of module
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module delay
#(
    parameter int unsigned DELAY_TIME  = 5,
    parameter int unsigned INPUT_WIDTH = 8
)
(
    input  logic                       i_clk,
                                       i_enable,
           logic [INPUT_WIDTH - 1 : 0] i_signal,
    output logic [INPUT_WIDTH - 1 : 0] o_delayed
);
    // -----------------------------------------------
    // Defenition
    logic [INPUT_WIDTH - 1 : 0] iternal_register_line [DELAY_TIME : 0] = '{default : '0};
    
    genvar register_num;
    // -----------------------------------------------
    // Basic logic
    always_ff @(posedge i_clk) begin : first_register
        iternal_register_line[0] <= i_signal;
    end : first_register
    
    for (register_num = 1; register_num < DELAY_TIME + 1; register_num++) begin
        always_ff @(posedge i_clk) begin : other_registers_in_line
            if (i_enable) begin
                iternal_register_line[register_num] <= iternal_register_line[register_num - 1];
            end
        end : other_registers_in_line
    end
    // -----------------------------------------------
    // Assign block
    assign o_delayed = iternal_register_line[DELAY_TIME];
    
endmodule : delay
/*
    delay
    #(
        .DELAY_TIME  ( 5 ),
        .INPUT_WIDTH ( 8 )
    )
    delay_inst
    (
        .i_clk     ( ),
        .i_enable  ( ),
        .i_signal  ( ),
        .o_delayed ( )
    );
*/