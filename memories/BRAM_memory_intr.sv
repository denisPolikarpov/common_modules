`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2025 18:42:33
// Design Name: 
// Module Name: memory_intr
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


interface BRAM_memory_intr
#(
    parameter int unsigned DATA_WIDTH    = 16,
    parameter int unsigned ADDRESS_WIDTH = 256,
    localparam int unsigned WE_WIDTH = DATA_WIDTH / 4
) 
( 
    input logic clk
);
    // ------------------------------------------------------------
    // Signals
    logic [ADDRESS_WIDTH - 1 : 0] addr;
    logic [DATA_WIDTH - 1    : 0] din;
    logic [DATA_WIDTH - 1    : 0] dout;
    logic                         en;
    logic                         rst;
    logic [WE_WIDTH - 1      : 0] we;
    // ------------------------------------------------------------
    // Modports
    modport nonMem (
        output addr,
        input  clk,
        output din,
        input  dout,
        output en,
        output rst,
        output we
    );
    
    modport mem (
        input  addr,
        input  clk,
        input  din,
        output dout,
        input  en,
        input  rst,
        input  we
    );
                          
endinterface : BRAM_memory_intr
