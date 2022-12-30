`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/19 15:31:51
// Design Name: 
// Module Name: pcAdd
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


module pcAdd(
        input Reset,
        input CLK,               //ʱ��
        input [1:0] PCSrc,             //����ѡ��������
        input [31:0] immediate,  //ƫ����
        input [25:0] addr,
        input [31:0] curPC,
        output reg[31:0] nextPC  //��ָ���ַ
    );
    
    initial begin
        nextPC <= 0;
    end
    
    reg [31:0] pc;
    
    always@(negedge CLK or negedge Reset)
    begin
        if(!Reset) begin
            nextPC <= 0;
        end
        else begin
            pc <= curPC + 4;
            case(PCSrc)
                2'b00: nextPC <= curPC + 4;
                2'b01: nextPC <= curPC + 4 + immediate * 4;
                2'b10: nextPC <= {pc[31:28],addr,2'b00};
                2'b11: nextPC <= nextPC;
            endcase
        end
    end
endmodule
