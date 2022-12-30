`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 20:43:00
// Design Name: 
// Module Name: RegisterFile
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

//�Ĵ�����
module RegisterFile(
        input CLK,                  //ʱ��
        input [4:0] ReadReg1,    //rs�Ĵ�����ַ����˿�
        input [4:0] ReadReg2,    //rt�Ĵ�����ַ����˿�
        input [31:0] WriteData,     //д��Ĵ�������������˿�
        input [4:0] WriteReg,       //������д��ļĴ����˿ڣ����ַ��Դrt��rd�ֶ�
        input RegWre,               //WE��дʹ���źţ�Ϊ1ʱ����ʱ�ӱ��ش���д��
        output reg[31:0] ReadData1,  //rs�Ĵ�����������˿�
        output reg[31:0] ReadData2   //rt�Ĵ�����������˿�
    );
    
    initial begin
        ReadData1 <= 0;
        ReadData2 <= 0;
    end
    

    reg [31:0] regFile[0:31]; //  �Ĵ������������reg����
    integer i;
    initial begin
        for (i = 0; i < 32; i = i+ 1) regFile[i] <= 0;  
    end
    
    always@(ReadReg1 or ReadReg2) 
    begin
        ReadData1 = regFile[ReadReg1];
        ReadData2 = regFile[ReadReg2];
        //$display("regfile %d %d\n", ReadReg1, ReadReg2);
    end
    
    always@(negedge CLK)
    begin
        //$0��Ϊ0������д��Ĵ����ĵ�ַ����Ϊ0
        if(RegWre && WriteReg)
            begin
                regFile[WriteReg] <= WriteData;
            end
    end
endmodule
