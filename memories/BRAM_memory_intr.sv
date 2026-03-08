`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 29.08.2025 18:42:33
// Module Name: BRAM_memory_intr
// Project Name: Memories
// Target Devices: Zynq, Artix, etc.
// Description: 
// * BRAM interface
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


interface BRAM_memory_intr
#(
    parameter int unsigned  DATA_WIDTH    = 16,
    parameter int unsigned  ADDRESS_WIDTH = 256,
    localparam int unsigned WE_WIDTH      = DATA_WIDTH / 8
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
/*
    BRAM_memory_intr
    #(
        .DATA_WIDTH    (  16 ),
        .ADDRESS_WIDTH ( 256 )
    ) 
    BRAM_memory_intr_inst
    ( 
        .clk ( )
    );

    // Signals
    BRAM_memory_intr_inst.addr
    BRAM_memory_intr_inst.clk
    BRAM_memory_intr_inst.din
    BRAM_memory_intr_inst.dout
    BRAM_memory_intr_inst.en
    BRAM_memory_intr_inst.rst
    BRAM_memory_intr_inst.we
*/