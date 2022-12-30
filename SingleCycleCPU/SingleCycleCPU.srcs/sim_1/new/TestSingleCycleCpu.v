`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/19 14:23:09
// Design Name: 
// Module Name: TestSingleCycleCpu
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


module TestSingleCycleCpu();
    // Inputs
	reg CLK;
	reg Reset;

	// Outputs
	wire [1:0] PCSrc;
	wire [5:0] op;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [31:0] DB;
	wire [31:0] result;
	wire [31:0] curPC;
    wire [31:0] nextPC;
    wire [31:0] instruction;
    wire [31:0] A;
    wire [31:0] B;
    wire zero;
    wire PCWre;       //PC�Ƿ���ĵ��ź�����Ϊ0ʱ�򲻸��ģ�������Ը���
    wire ExtSel;      //��������չ���ź�����Ϊ0ʱ��Ϊ0��չ������Ϊ������չ
    wire InsMemRW;    //ָ��Ĵ�����״̬��������Ϊ0��ʱ��дָ��Ĵ���������Ϊ��ָ��Ĵ���
    wire RegDst;      //д�Ĵ�����Ĵ����ĵ�ַ��Ϊ0��ʱ���ַ����rt��Ϊ1��ʱ���ַ����rd
    wire RegWre;      //�Ĵ�����дʹ�ܣ�Ϊ1��ʱ���д
    wire ALUSrcA;     //����ALU����A��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data1�����Ϊ1��ʱ��������λ��sa
    wire ALUSrcB;     //����ALU����B��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data2�����Ϊ1ʱ��������չ����������
    wire [2:0]ALUOp;  //ALU 8�����㹦��ѡ��(000-111)
    wire mRD;         //���ݴ洢���������źţ�Ϊ0��
    wire mWR;         //���ݴ洢��д�����źţ�Ϊ0д
    wire DBDataSrc;    //���ݱ����ѡ��ˣ�Ϊ0����ALU�������������Ϊ1�������ݼĴ�����Data MEM�������  
	// Instantiate the Unit Under Test (UUT)
	SingleCycleCPU uut (
		.CLK(CLK), 
		.Reset(Reset), 
		.curPC(curPC),
		.nextPC(nextPC),
		.instruction(instruction),
		.op(op), 
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.DB(DB),
		.A(A),
		.B(B),
		.result(result),
		.PCSrc(PCSrc),
		.zero(zero),
		.PCWre(PCWre),
		.ExtSel(ExtSel),
		.InsMemRW(InsMemRW),
		.RegDst(RegDst),
		.RegWre(RegWre),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ALUOp(ALUOp),
		.mRD(mRD),
		.mWR(mWR),
		.DBDataSrc(DBDataSrc)
	);
	
    initial begin
        // Initialize Inputs
        CLK = 1;
        Reset = 0;

        CLK = !CLK;  // �½��أ�ʹPC������
        Reset = 1;  // ��������ź�
        forever #5
        begin // ����ʱ���źţ�����Ϊ50s
             CLK = !CLK;
        end
    end
endmodule
