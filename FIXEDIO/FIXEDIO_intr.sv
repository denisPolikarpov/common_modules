`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2025 10:05:15
// Design Name: 
// Module Name: FIXEDIO_intr
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

interface FIXEDIO_intr ();

    logic [53 : 0] MIO;
    logic          DDR_VRN;
    logic          DDR_VRP;
    logic          PS_SRSTB;
    logic          PS_CLK;
    logic          PS_PORB;
    
    modport ports (
        inout MIO,   
        inout DDR_VRN,
        inout DDR_VRP,
        inout PS_SRSTB,
        inout PS_CLK,
        inout PS_PORB
    );
    
endinterface : FIXEDIO_intr
