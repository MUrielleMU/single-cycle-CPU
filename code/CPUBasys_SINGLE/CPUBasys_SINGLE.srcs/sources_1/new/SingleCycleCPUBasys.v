`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/20 20:56:04
// Design Name: 
// Module Name: SingleCycleCPUBasys
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


module SingleCycleCPUBasys(
        input CLK,
        input Reset,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] instruction,
        output [5:0] op,
        output [4:0] rs,
        output [4:0] rt,
        output [4:0] rd,
        output [31:0] DB,
        output [31:0] A,
        output [31:0] B,
        output [31:0] result,
        output [1:0] PCSrc
    );
    
    wire zero;
    wire PCWre;       //PC是否更改的信号量，为0时候不更改，否则可以更改
    wire ExtSel;      //立即数扩展的信号量，为0时候为0扩展，否则为符号扩展
    wire InsMemRW;    //指令寄存器的状态操作符，为0的时候写指令寄存器，否则为读指令寄存器
    wire RegDst;      //写寄存器组寄存器的地址，为0的时候地址来自rt，为1的时候地址来自rd
    wire RegWre;      //寄存器组写使能，为1的时候可写
    wire ALUSrcA;     //控制ALU数据A的选择端的输入，为0的时候，来自寄存器堆data1输出，为1的时候来自移位数sa
    wire ALUSrcB;     //控制ALU数据B的选择端的输入，为0的时候，来自寄存器堆data2输出，为1时候来自扩展过的立即数
   // wire [1:0]PCSrc;  //获取下一个pc的地址的数据选择器的选择端输入
    wire [2:0]ALUOp;  //ALU 8种运算功能选择(000-111)
    wire mRD;         //数据存储器读控制信号，为0读
    wire mWR;         //数据存储器写控制信号，为0写
    wire DBDataSrc;    //数据保存的选择端，为0来自ALU运算结果的输出，为1来自数据寄存器（Data MEM）的输出  
    wire [31:0] extend;
    wire [31:0] DataOut;
    wire[4:0] sa;
    wire[15:0] immediate;
    wire[25:0] addr;
    /*
        module pcAdd(
            input CLK,               //时钟
            input [1:0] PCSrc,             //数据选择器输入
            input [31:0] immediate,  //偏移量
            input [25:0] addr,
            input [31:0] curPC,
            output [31:0] nextPC  //新指令地址
        );
    */
    pcAdd pcAdd(.Reset(Reset),
                .CLK(CLK),
                .PCSrc(PCSrc),
                .immediate(extend),
                .addr(addr),
                .curPC(curPC),
                .nextPC(nextPC));
    
    /*
        module PC(
           input CLK,               //时钟
           input Reset,             //是否重置地址。0-初始化PC，否则接受新地址
           input PCWre,             //是否接受新的地址。0-不更改；1-可以更改
           input [1:0] PCSrc,             //数据选择器输入
           input [31:0] nextPC,  //当前指令地址
           output reg[31:0] curPC //下一条指令的地址
        );
    */
    PC pc(.CLK(CLK),
          .Reset(Reset),
          .PCWre(PCWre),
          .PCSrc(PCSrc),
          .nextPC(nextPC),
          .curPC(curPC));
          
    /*
    module InsMEM(
          input [31:0] IAddr,
          input InsMemRW,             //状态为'0'，写指令寄存器，否则为读指令寄存器
          output reg[31:0] IDataOut
      );
    */
    InsMEM InsMEM(.IAddr(curPC), 
                .InsMemRW(InsMemRW), 
                .IDataOut(instruction));
                    
    /*
        module InstructionCut(
            input [31:0] instruction,
            output reg[5:0] op,
            output reg[4:0] rs,
            output reg[4:0] rt,
            output reg[4:0] rd,
            output reg[4:0] sa,
            output reg[15:0] immediate,
            output reg[25:0] addr
        );
    */
    InstructionCut InstructionCut(.instruction(instruction),
                                  .op(op),
                                  .rs(rs),
                                  .rt(rt),
                                  .rd(rd),
                                  .sa(sa),
                                  .immediate(immediate),
                                  .addr(addr));
                                  
    /*
        module ControlUnit(
            input zero,         //ALU运算结果是否为0，为0时候为1
            input [5:0] op,     //指令的操作码
            output reg PCWre,       //PC是否更改的信号量，为0时候不更改，否则可以更改
            output reg ExtSel,      //立即数扩展的信号量，为0时候为0扩展，否则为符号扩展
            output reg InsMemRW,    //指令寄存器的状态操作符，为0的时候写指令寄存器，否则为读指令寄存器
            output reg RegDst,      //写寄存器组寄存器的地址，为0的时候地址来自rt，为1的时候地址来自rd
            output reg RegWre,      //寄存器组写使能，为1的时候可写
            output reg ALUSrcA,     //控制ALU数据A的选择端的输入，为0的时候，来自寄存器堆data1输出，为1的时候来自移位数sa
            output reg ALUSrcB,     //控制ALU数据B的选择端的输入，为0的时候，来自寄存器堆data2输出，为1时候来自扩展过的立即数
            output reg [1:0]PCSrc,  //获取下一个pc的地址的数据选择器的选择端输入
            output reg [2:0]ALUOp,  //ALU 8种运算功能选择(000-111)
            output reg mRD,         //数据存储器读控制信号，为0读
            output reg mWR,         //数据存储器写控制信号，为0写
            output reg DBDataSrc    //数据保存的选择端，为0来自ALU运算结果的输出，为1来自数据寄存器（Data MEM）的输出        
        );
    */
    ControlUnit ControlUnit(.zero(zero),
                            .op(op),
                            .PCWre(PCWre),
                            .ExtSel(ExtSel),
                            .InsMemRW(InsMemRW),
                            .RegDst(RegDst),
                            .RegWre(RegWre),
                            .ALUSrcA(ALUSrcA),
                            .ALUSrcB(ALUSrcB),
                            .PCSrc(PCSrc),
                            .ALUOp(ALUOp),
                            .mRD(mRD),
                            .mWR(mWR),
                            .DBDataSrc(DBDataSrc));
    
    /*
        module RegisterFile(
            input CLK,                  //时钟
            input [4:0] ReadReg1,    //rs寄存器地址输入端口
            input [4:0] ReadReg2,    //rt寄存器地址输入端口
            input [31:0] WriteData,     //写入寄存器的数据输入端口
            input [4:0] WriteReg,       //将数据写入的寄存器端口，其地址来源rt或rd字段
            input RegWre,               //WE，写使能信号，为1时，在时钟边沿触发写入
            output [31:0] ReadData1,  //rs寄存器数据输出端口
            output [31:0] ReadData2   //rt寄存器数据输出端口
        );
    */
    RegisterFile RegisterFile(.CLK(CLK),
                              .ReadReg1(rs),
                              .ReadReg2(rt),
                              .WriteData(DB),
                              .WriteReg(RegDst ? rd : rt),
                              .RegWre(RegWre),
                              .ReadData1(A),
                              .ReadData2(B));
                              
    /*
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
    */
    ALU alu(.ALUSrcA(ALUSrcA),
            .ALUSrcB(ALUSrcB),
            .ReadData1(A),
            .ReadData2(B),
            .sa(sa),
            .extend(extend),
            .ALUOp(ALUOp),
            .zero(zero),
            .result(result));
    
    /*
        module DataMEM(
            input mRD,
            input mWR,
            input CLK,
            input DBDataSrc,
            input [31:0] DAddr,
            input [31:0] DataIn,
            output reg[31:0] DataOut,
            output reg[31:0] DB
        );
    */
    DataMEM DataMEM(.mRD(mRD),
                    .mWR(mWR),
                    .CLK(CLK),
                    .DBDataSrc(DBDataSrc),
                    .DAddr(result),
                    .DataIn(B),
                    .DataOut(DataOut),
                    .DB(DB));
    
    /*
        module SignZeroExtend(
            input wire [15:0] immediate,    //立即数
            input ExtSel,                   //状态'0',0扩展，否则符号位扩展
            output wire[31:0] extendImmediate
        );
    */
    SignZeroExtend SignZeroExtend(.immediate(immediate),
                                  .ExtSel(ExtSel),
                                  .extendImmediate(extend));
    
endmodule