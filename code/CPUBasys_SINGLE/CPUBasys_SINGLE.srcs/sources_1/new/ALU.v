`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 22:49:52
// Design Name: 
// Module Name: ALU
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


module ALU(
        input ALUSrcA,
        input ALUSrcB,
        input [31:0] ReadData1,
        input [31:0] ReadData2,
        input [4:0] sa,
        input [31:0] extend,
        input [2:0] ALUOp,
        output reg zero,
        output reg[31:0] result
    );
    
    reg [31:0] A;
    reg [31:0] B;
    
    always@(ReadData1 or ReadData2 or ALUSrcA or ALUSrcB or ALUOp) 
    begin
        //定义两个输入端口
        A = (ALUSrcA == 0) ? ReadData1 : sa;
        B = (ALUSrcB == 0) ? ReadData2 : extend;
        case(ALUOp)
            3'b000: result = A + B;
            3'b001: result = A - B;
            3'b010: result = B << A;
            3'b011: result = A | B;
            3'b100: result = A & B;
            3'b101: result = (A < B) ? 1 : 0;
            3'b110: result = (((ReadData1 < ReadData2) && (ReadData1[31] == ReadData2[31] )) ||( ( ReadData1[31] ==1 && ReadData2[31] == 0))) ? 1:0;
            3'b111: result = A ^ B;
        endcase
        zero = (result == 0) ? 1 : 0;
    end 
endmodule
