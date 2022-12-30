`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/19 13:39:47
// Design Name: 
// Module Name: SingleCycleCPU
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


module SingleCycleCPU(
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
        output [1:0] PCSrc,
        output zero,
        output PCWre,       //PC�Ƿ���ĵ��ź�����Ϊ0ʱ�򲻸��ģ�������Ը���
        output ExtSel,      //��������չ���ź�����Ϊ0ʱ��Ϊ0��չ������Ϊ������չ
        output InsMemRW,    //ָ��Ĵ�����״̬��������Ϊ0��ʱ��дָ��Ĵ���������Ϊ��ָ��Ĵ���
        output RegDst,      //д�Ĵ�����Ĵ����ĵ�ַ��Ϊ0��ʱ���ַ����rt��Ϊ1��ʱ���ַ����rd
        output RegWre,      //�Ĵ�����дʹ�ܣ�Ϊ1��ʱ���д
        output ALUSrcA,     //����ALU����A��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data1�����Ϊ1��ʱ��������λ��sa
        output ALUSrcB,     //����ALU����B��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data2�����Ϊ1ʱ��������չ����������
        output [2:0]ALUOp,  //ALU 8�����㹦��ѡ��(000-111)
        output mRD,         //���ݴ洢���������źţ�Ϊ0��
        output mWR,         //���ݴ洢��д�����źţ�Ϊ0д
        output DBDataSrc    //���ݱ����ѡ��ˣ�Ϊ0����ALU�������������Ϊ1�������ݼĴ�����Data MEM�������  
    );

    wire [31:0] extend;
    wire [31:0] DataOut;
    wire[4:0] sa;
    wire[15:0] immediate;
    wire[25:0] addr;

    pcAdd pcAdd(.Reset(Reset),
                .CLK(CLK),
                .PCSrc(PCSrc),
                .immediate(extend),
                .addr(addr),
                .curPC(curPC),
                .nextPC(nextPC));
    
    PC pc(.CLK(CLK),
          .Reset(Reset),
          .PCWre(PCWre),
          .PCSrc(PCSrc),
          .nextPC(nextPC),
          .curPC(curPC));

    InsMEM InsMEM(.IAddr(curPC), 
                .InsMemRW(InsMemRW), 
                .IDataOut(instruction));
                    
    InstructionCut InstructionCut(.instruction(instruction),
                                  .op(op),
                                  .rs(rs),
                                  .rt(rt),
                                  .rd(rd),
                                  .sa(sa),
                                  .immediate(immediate),
                                  .addr(addr));

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

    RegisterFile RegisterFile(.CLK(CLK),
                              .ReadReg1(rs),
                              .ReadReg2(rt),
                              .WriteData(DB),
                              .WriteReg(RegDst ? rd : rt),
                              .RegWre(RegWre),
                              .ReadData1(A),
                              .ReadData2(B));

    ALU alu(.ALUSrcA(ALUSrcA),
            .ALUSrcB(ALUSrcB),
            .ReadData1(A),
            .ReadData2(B),
            .sa(sa),
            .extend(extend),
            .ALUOp(ALUOp),
            .zero(zero),
            .result(result));

    DataMEM DataMEM(.mRD(mRD),
                    .mWR(mWR),
                    .CLK(CLK),
                    .DBDataSrc(DBDataSrc),
                    .DAddr(result),
                    .DataIn(B),
                    .DataOut(DataOut),
                    .DB(DB));

    SignZeroExtend SignZeroExtend(.immediate(immediate),
                                  .ExtSel(ExtSel),
                                  .extendImmediate(extend));
    
endmodule
