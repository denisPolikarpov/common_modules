//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2025 19:55:53
// Design Name: 
// Package Name: math_pkg
// Project Name: 
// Tool Versions: 
// Description: 
// Used to make work with math easier
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


package math_pkg;
    
    // Custom types
    typedef byte unsigned u8;
    
    // Functions for output width calculation
    function u8 adder_output_width_calculation (u8 input1_width, u8 input2_width);
        if (input1_width > input2_width) begin
            return input1_width + 1;
        end
        else begin
            return input2_width + 1;
        end
    endfunction : adder_output_width_calculation
    
    function u8 mult_output_width_calculation (u8 input1_width, u8 input2_width);
        return input1_width + input2_width;
    endfunction : mult_output_width_calculation
    
endpackage : math_pkg
