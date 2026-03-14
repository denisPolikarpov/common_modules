`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2025 09:35:45
// Design Name: 
// Module Name: ddrx_intr
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


interface DDRx_intr ();

    logic          CAS_n;
    logic          CKE;
   
    logic          Clk;
    logic          Clk_n;
   
    logic          CS_n;
    logic          DRSTB;
    logic          ODT;
    logic          RAS_n;
    logic          WEB;
    logic [2  : 0] BankAddr;
    logic [14 : 0] Addr;
    logic [3  : 0] DM;
    logic [31 : 0] DQ;
    
    logic [3  : 0] DQS;
    logic [3  : 0] DQS_n;

    modport ports (
        inout CAS_n,
        inout CKE,
        inout Clk,
        inout Clk_n,
        inout CS_n,
        inout DRSTB,
        inout ODT,
        inout RAS_n,
        inout WEB,
        inout BankAddr,
        inout Addr,
        inout DM,
        inout DQ,
        inout DQS,
        inout DQS_n
    );
endinterface : DDRx_intr
