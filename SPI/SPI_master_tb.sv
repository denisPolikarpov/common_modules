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
    
    localparam int unsigned INPUT_WIDTH = 8;
    
    logic i_clk, 
          i_start,
          o_data_valid;
          
    SPI_intr intr_SPI_master();
    
    logic [INPUT_WIDTH - 1 : 0] data_to_MISO [1 : 0] = '{'hB4, 'hC3};
    logic [2 : 0] curr_bit_num = '0;
    logic next_seq = '0;
    
    logic [INPUT_WIDTH - 1 : 0] i_data = 'hAD,
                                o_recieved_data;
    
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
        .*
    );
    
    initial begin
        i_clk <= '0;
        forever #1 i_clk <= ~i_clk;
    end
    
    initial begin
        i_data <= 'hAD;
        #1205
        i_data <= 'h5C;
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
    
    always @(negedge intr_SPI_master.SCLK) begin
        intr_SPI_master.MISO <= data_to_MISO[next_seq][curr_bit_num];
        curr_bit_num <= curr_bit_num + 'b1;
        if (curr_bit_num == 'd7) begin
            next_seq <= ~next_seq;
        end
    end
    
endmodule : SPI_master_tb
