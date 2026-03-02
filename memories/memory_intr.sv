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


interface memory_intr
#(
    parameter int unsigned MEMORY_WIDTH = 16,
    parameter int unsigned MEMORY_DEPTH = 256
) 
( 

);
    localparam ADDRESS_WIDTH = $clog2(MEMORY_DEPTH);
    localparam WE_WIDTH = MEMORY_WIDTH / 4;
    
    logic [ADDRESS_WIDTH - 1 : 0] addr;
    logic                         clk;
    logic [MEMORY_WIDTH - 1  : 0] din;
    logic [MEMORY_WIDTH - 1  : 0] dout;
    logic                         en;
    logic                         rst;
    logic [WE_WIDTH - 1      : 0] we;
 
    
    modport nonMemModule (output addr,
                          output clk,
                          output din,
                          input  dout,
                          output en,
                          output rst,
                          output we);
    
    modport memModule (input  addr,
                       input  clk,
                       input  din,
                       output dout,
                       input  en,
                       input  rst,
                       input  we);
                          
endinterface : memory_intr
