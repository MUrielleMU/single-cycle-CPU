`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 20:44:18
// Design Name: 
// Module Name: SignZeroExtend
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


module SignZeroExtend(
        input wire [15:0] immediate,    //������
        input ExtSel,                   //״̬'0',0��չ���������λ��չ
        output [31:0] extendImmediate
    );
    
    always@(extendImmediate)
    begin
        $display("%d", extendImmediate[31]);
    end
    
    assign extendImmediate[15:0] = immediate;
    assign extendImmediate[31:16] = ExtSel ? (immediate[15] ? 16'hffff : 16'h0000) : 16'h0000;
endmodule
