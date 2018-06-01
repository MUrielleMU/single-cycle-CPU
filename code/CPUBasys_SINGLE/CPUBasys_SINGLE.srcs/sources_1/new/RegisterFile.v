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

//寄存器组
module RegisterFile(
        input CLK,                  //时钟
        input [4:0] ReadReg1,    //rs寄存器地址输入端口
        input [4:0] ReadReg2,    //rt寄存器地址输入端口
        input [31:0] WriteData,     //写入寄存器的数据输入端口
        input [4:0] WriteReg,       //将数据写入的寄存器端口，其地址来源rt或rd字段
        input RegWre,               //WE，写使能信号，为1时，在时钟边沿触发写入
        output reg[31:0] ReadData1,  //rs寄存器数据输出端口
        output reg[31:0] ReadData2   //rt寄存器数据输出端口
    );
    
    initial begin
        ReadData1 <= 0;
        ReadData2 <= 0;
    end
    
    //$0恒为0，所以写入寄存器的地址不能为0
    reg [31:0] regFile[0:31]; //  寄存器定义必须用reg类型
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
        if(RegWre && WriteReg)
            begin
                regFile[WriteReg] <= WriteData;
            end
    end
endmodule
