`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/20 23:56:32
// Design Name: 
// Module Name: keyled
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


module Debounce(
        input clk, 
        input key, 
        output out
    );
    
    reg delay1,delay2,delay3;  
    assign out = delay1&delay2&delay3;
    always@(posedge clk)//CLK 100M
    begin
        delay1 <= key;
        delay2 <= delay1;
        delay3 <= delay2;
    end
endmodule
