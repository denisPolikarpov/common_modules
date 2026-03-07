`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 03.03.2026 17:55:46
// Interface Name: SPI_intr
// Project Name: SPI_module
// Description: 
// * SPI interface
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


interface SPI_intr();
    // -----------------------------------------------
    // Signals list
    logic CSn;
    logic SCLK;
    logic MOSI;
    logic MISO;
    // -----------------------------------------------
    // Modports
    modport master (
        output CSn,
        output SCLK,
        output MOSI,
        input  MISO
    );
    
    modport slave (
        input  CSn,
        input  SCLK,
        input  MOSI,
        output MISO
    );
endinterface : SPI_intr
/*
    SPI_intr SPI_intr_inst ();
    
    // Signals
    SPI_intr_inst.CSn
    SPI_intr_inst.SCLK
    SPI_intr_inst.MOSI
    SPI_intr_inst.MISO
*/