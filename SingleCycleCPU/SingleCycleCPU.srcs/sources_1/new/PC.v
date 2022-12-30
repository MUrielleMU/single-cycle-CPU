`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 22:01:44
// Design Name: 
// Module Name: PC
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


module PC(
       input CLK,               //ʱ��
       input Reset,             //�Ƿ����õ�ַ��0-��ʼ��PC����������µ�ַ
       input PCWre,             //�Ƿ�����µĵ�ַ��0-�����ģ�1-���Ը���
       input [1:0] PCSrc,             //����ѡ��������
       input [31:0] nextPC,  //��ָ���ַ
       output reg[31:0] curPC //��ǰָ��ĵ�ַ
    );
    
    initial begin
        curPC <= 0;
    end

    always@(posedge CLK or negedge Reset)
    begin
        if(!Reset) // Reset == 0, PC = 0
            begin
                curPC <= 0;
            end
        else 
            begin
                if(PCWre) // PCWre == 1
                    begin 
                        curPC <= nextPC;
                    end
                else    // PCWre == 0, halt
                    begin
                        curPC <= curPC;
                    end
            end
    end
endmodule
