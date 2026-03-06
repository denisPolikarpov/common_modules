`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 05.03.2026 21:45:25
// Design Name: 
// Module Name: SPI_master_tb
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


module SPI_master_tb();
    
    localparam int unsigned INPUT_WIDTH = 16;
    
    logic i_clk, 
          i_start;
//          CSn,
//          SCLK,
//          MOSI,
//          MISO = '0;
          
    SPI_intr intr_SPI_master();
    
//    assign CSn  = intr_SPI_master.CSn;
//    assign SCLK = intr_SPI_master.SCLK;
//    assign MOSI = intr_SPI_master.MOSI;
//    assign intr_SPI_master.MISO = MISO;
    
    logic [INPUT_WIDTH - 1 : 0] i_data = 'hADC5;
    
    SPI_master
    #(
        .INPUT_WIDTH    ( INPUT_WIDTH ),
        .MAIN_CLK_FREQ  (  120000000  ),
        .SCLK_FREQ      (   20000000  ),
        .SCLK_NOT_END   (    "YES"    ),     // "YES"   // "NO"
        .TRANSMIT_ORDER (    "MSB"    )      // "MSB"   // "LSB"
    )
    SPI_master_DUT
    (
        .*,
        .intr_SPI_master ( intr_SPI_master ),
        // Recieved data
        .o_recieved_data ( ),
        .o_data_valid    ( )
    );
    
    initial begin
        i_clk <= '0;
        forever #1 i_clk <= ~i_clk;
    end
    
    initial begin
        i_data <= 'hADC5;
        #1205
        i_data <= 'h5CDA;
    end
    
    initial begin
        i_start <= '0;
        #1001
        i_start <= '1;
        #2
        i_start <= '0;
        #200
        i_start <= '1;
        #2
        i_start <= '0;
    end
    
endmodule : SPI_master_tb
