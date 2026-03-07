`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Polikarpov D. A.
// 
// Create Date: 02.03.2026 18:24:23
// Module Name: SPI_master
// Project Name: SPI
// Description: 
// * Basic SPI master module
// Dependencies: 
// * counter.sv
// * parallel_to_serial.sv
// * edge_sense.sv
// * clk_gen.sv
// Revision:
// Revision 0.01 - File Created
//          0.02 - First version of SPI (SCLK always in work)
// Additional Comments:
// * Module supports type of SPI, when SCLK always in work
//////////////////////////////////////////////////////////////////////////////////


module SPI_master
#(
    parameter int unsigned INPUT_WIDTH    = 16,
    parameter int unsigned MAIN_CLK_FREQ  = 120000000,
    parameter int unsigned SCLK_FREQ      = 20000000,
    parameter              SCLK_NOT_END   = "YES",     // "YES"    // "NO"
    parameter              TRANSMIT_ORDER = "MSB",     // "MSB"    // "LSB"
    parameter              RECIEVED_ORDER = "MSB"      // "MSB"    // "LSB"
)
(
    input  logic i_clk,
    // SPI master interface 
    SPI_intr.master intr_SPI_master,
    // Data to transfer
    input  logic [INPUT_WIDTH - 1 : 0] i_data,
           logic                       i_start,
    // Recieved data
    output logic [INPUT_WIDTH - 1 : 0] o_recieved_data,
           logic                       o_data_valid
);
    // ------------------------------------------------------------
    // Constants calculations
    localparam int unsigned TRANS_BIT_CN_FINAL = INPUT_WIDTH - 1;
    localparam int unsigned TRANS_BIT_CN_WIDTH = $clog2(TRANS_BIT_CN_FINAL) + 1;
    // Declaration of variables
    logic enable_SCLK_gen       = '0,
          reset_trans_bit_cn    = '0,
          enable_shifting       = '0,
          latch_data            = '0,
          reset_MISO_ser_to_par = '0,
          latch_recieved_data   = '0, 
          generated_SCLK,
          falling_edge_detected,
          rising_edge_detected,
          MOSI_shift_register,
          MISO_shift_register,
          enable_trans_bit_cn,
          trans_bit_cn_finished;
    logic [INPUT_WIDTH - 1 : 0] recieved_data_reg = '0,
                                recieved_data_wire;
    // ------------------------------------------------------------
    // FSM
    enum logic [3 : 0] {
        IDLE_STATE      = 4'b0001,
        NEXT_FALL_STATE = 4'b0010,
        TRANS_STATE     = 4'b0100,
        LAST_BIT_STATE  = 4'b1000
    } fsm_state = IDLE_STATE;  
    
    always_ff @(posedge i_clk) begin : fsm
        unique case(fsm_state)
            IDLE_STATE : begin
                if (i_start) begin
                    fsm_state             <= NEXT_FALL_STATE;
                    
                    intr_SPI_master.CSn   <= '1;
                    reset_trans_bit_cn    <= '1;
                    latch_data            <= '1;
                    enable_shifting       <= '0;
                    reset_MISO_ser_to_par <= '1;
                    latch_recieved_data   <= '0;
                end
                else begin
                    fsm_state             <= IDLE_STATE;
                    
                    intr_SPI_master.CSn   <= '1;
                    reset_trans_bit_cn    <= '1;
                    latch_data            <= '0;
                    enable_shifting       <= '0;
                    reset_MISO_ser_to_par <= '1;
                    latch_recieved_data   <= '0;
                end
            end
            NEXT_FALL_STATE : begin
                if (falling_edge_detected) begin
                    fsm_state             <= TRANS_STATE;
                    
                    intr_SPI_master.CSn   <= '0;
                    reset_trans_bit_cn    <= '0;
                    latch_data            <= '0;
                    enable_shifting       <= '1;
                    reset_MISO_ser_to_par <= '0;
                    latch_recieved_data   <= '0;
                end
                else begin
                    fsm_state             <= NEXT_FALL_STATE;
                    
                    intr_SPI_master.CSn   <= '1;
                    reset_trans_bit_cn    <= '1;
                    latch_data            <= '0;
                    enable_shifting       <= '0;
                    reset_MISO_ser_to_par <= '1;
                    latch_recieved_data   <= '0;
                end
            end
            TRANS_STATE : begin
                if (trans_bit_cn_finished) begin
                    fsm_state             <= LAST_BIT_STATE;
                    
                    intr_SPI_master.CSn   <= '0;
                    reset_trans_bit_cn    <= '1;
                    latch_data            <= '0;
                    enable_shifting       <= '1;
                    reset_MISO_ser_to_par <= '0;
                    latch_recieved_data   <= '0;
                end
                else begin
                    fsm_state             <= TRANS_STATE;
                    
                    intr_SPI_master.CSn   <= '0;
                    reset_trans_bit_cn    <= '0;
                    latch_data            <= '0;
                    enable_shifting       <= '1;
                    reset_MISO_ser_to_par <= '0;
                    latch_recieved_data   <= '0;
                end
            end
            LAST_BIT_STATE : begin
                if (falling_edge_detected) begin
                    if (i_start) begin
                        fsm_state             <= TRANS_STATE;
                        
                        intr_SPI_master.CSn   <= '0;
                        reset_trans_bit_cn    <= '0;
                        latch_data            <= '1;
                        enable_shifting       <= '1;
                        reset_MISO_ser_to_par <= '1;
                        latch_recieved_data   <= '1;
                    end
                    else begin
                        fsm_state             <= IDLE_STATE;
                        
                        intr_SPI_master.CSn   <= '1;
                        reset_trans_bit_cn    <= '1;
                        latch_data            <= '0;
                        enable_shifting       <= '0;
                        reset_MISO_ser_to_par <= '0;
                        latch_recieved_data   <= '1;
                    end
                end
                else begin
                    fsm_state             <= LAST_BIT_STATE;
                    
                    intr_SPI_master.CSn   <= '0;
                    reset_trans_bit_cn    <= '1;
                    latch_data            <= '0;
                    enable_shifting       <= '1;
                    reset_MISO_ser_to_par <= '0;
                    latch_recieved_data   <= '0;
                end
            end
        endcase
    end : fsm
    // ------------------------------------------------------------
    // MOSI shift register
    assign MOSI_shift_register = enable_shifting & falling_edge_detected;
    
    parallel_to_serial
    #(
        .INPUT_WIDTH (  INPUT_WIDTH   ),
        .BIT_ORDER   ( TRANSMIT_ORDER )  // "MSB" // "LSB"
    )
    parallel_to_serial_MOSI
    (
        .i_clk,
        .i_parallel_data (        i_data        ),
        .i_latch         (      latch_data      ),
        .i_shift         (  MOSI_shift_register ),
        .o_serial_data   ( intr_SPI_master.MOSI )
    );
    // ------------------------------------------------------------
    // MISO shift register
    assign MISO_shift_register = enable_shifting & rising_edge_detected;
    
    serial_to_parallel
    #(
        .INPUT_WIDTH (   INPUT_WIDTH  ),
        .BIT_ORDER   ( RECIEVED_ORDER )   // "MSB"  // "LSB"
    )
    serial_to_parallel_MISO
    (
        .i_clk,
        .i_serial        (  intr_SPI_master.MISO ),
        .i_reset         ( reset_MISO_ser_to_par ),
        .i_enable        (  MISO_shift_register  ),
        .o_parallel_data (   recieved_data_wire  )
    );
    
    // ------------------------------------------------------------
    // Counter to count amount of transmitted bits
    assign enable_trans_bit_cn = ~reset_trans_bit_cn & falling_edge_detected;
    
    counter
    #(
        .COUNTER_WIDTH      ( TRANS_BIT_CN_WIDTH ),
        .FINAL_VALUE_SOURCE (     "PARAMETER"    ), // "PARAMETER"  // "PORT"
        .FINAL_VALUE        ( TRANS_BIT_CN_FINAL )
    )
    counter_transfered_bits
    (
        .i_clk,
        .i_reset               (   reset_trans_bit_cn  ),
        .i_enable              (  enable_trans_bit_cn  ),
        .i_final_value         (           '0          ),
        .o_value               (                       ),
        .o_final_value_reached ( trans_bit_cn_finished )
    );
    // ------------------------------------------------------------
    // Detect SCLK falling edges
    edge_sense
    #(
        .EDGE_TO_DETECT ( "FALLING" )         // "RISING" // "FALLING" // "BOTH"
    )
    SPI_SCLK_fall_edge
    (
        .i_clk,
        .i_signal (     generated_SCLK    ),
        .o_detect ( falling_edge_detected )
    );
    
    edge_sense
    #(
        .EDGE_TO_DETECT ( "RISING" )         // "RISING" // "FALLING" // "BOTH"
    )
    SPI_SCLK_rise_edge
    (
        .i_clk,
        .i_signal (    generated_SCLK    ),
        .o_detect ( rising_edge_detected )
    );
    // ------------------------------------------------------------
    // SCLK generation
    if (SCLK_NOT_END == "YES") begin
        clk_gen
        #(
            .MAIN_CLK_FREQ ( MAIN_CLK_FREQ ),
            .REQ_CLK_FREQ  (   SCLK_FREQ   )
        )
        SCLK_generation
        (
            .i_clk,
            .i_enable  (       '1       ),
            .o_gen_clk ( generated_SCLK )
        );
    end
    else if (SCLK_NOT_END == "NO") begin
        clk_gen
        #(
            .MAIN_CLK_FREQ ( MAIN_CLK_FREQ ),
            .REQ_CLK_FREQ  (   SCLK_FREQ   )
        )
        SCLK_generation
        (
            .i_clk,
            .i_enable  ( enable_SCLK_gen ),
            .o_gen_clk (  generated_SCLK )
        );
    end
    // ------------------------------------------------------------
    // Output signal logic
    always_ff @(posedge i_clk) begin : recieved_data_register
        if (latch_recieved_data) begin
            recieved_data_reg <= recieved_data_wire; 
        end
    end : recieved_data_register
    
    always_ff @(posedge i_clk) begin : delay
        o_data_valid         <= latch_recieved_data;
        intr_SPI_master.SCLK <= generated_SCLK;
    end : delay
    
    assign o_recieved_data = recieved_data_reg;
    
endmodule : SPI_master
/*
    SPI_master
    #(
        .INPUT_WIDTH    (     16    ),
        .MAIN_CLK_FREQ  ( 120000000 ),
        .SCLK_FREQ      (  20000000 ),
        .SCLK_NOT_END   (   "YES"   ),     // "YES"    // "NO"
        .TRANSMIT_ORDER (   "MSB"   )      // "MSB"    // "LSB"
    )
    SPI_master_inst
    (
        .i_clk ( ),
        // SPI master interface 
        .intr_SPI_master ( ),
        // Data to transfer
        .i_data  ( ),
        .i_start ( ),
        // Recieved data
        .o_recieved_data ( ),
        .o_data_valid    ( )
    );
*/