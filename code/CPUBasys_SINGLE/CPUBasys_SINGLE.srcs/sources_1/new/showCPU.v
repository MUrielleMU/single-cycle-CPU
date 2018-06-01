`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/20 21:12:04
// Design Name: 
// Module Name: showCPU
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


module showCPU(
        input Reset,
        input clock_100Mhz, // 100 Mhz clock source on Basys 3 FPGA
        input S0, // control
        input S1, // control
        input click,  //
        output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
        output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
    
    reg [3:0] LED_BCD;
    reg [26:0] refresh_counter; // the first 19-bit for creating 190Hz refresh rate
    // the other 2-bit for creating 4 LED-activating signals
    wire [1:0] LED_activating_counter; 
    wire [31:0] curPC;
    wire [31:0] nextPC;
    wire [31:0] instruction;
    wire [5:0] op;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [31:0] DB;
    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] result;
    wire [1:0] PCSrc;
    wire CpuCLk;
    
    Debounce Debounce(.clk(clock_100Mhz), .key(click), .out(CpuCLK));
    
    SingleCycleCPUBasys SingleCycleCPUBasys(.CLK(CpuCLK), 
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
                                            .PCSrc(PCSrc));
    
    //…®√Ë∆µ¬ 
    always @(posedge clock_100Mhz)
    begin 
        refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[20:19];

   //œ‘ æ∞ÂøÈ
   always @(*)
    begin
        case(LED_activating_counter)
            2'b00: begin
                Anode_Activate = 4'b0111; 
                if(!S0 && !S1) begin
                    LED_BCD = curPC[7:4];
                end
                else if(!S0 && S1) begin
                    LED_BCD ={3'b000, rs[4]};
                end
                else if(S0 && S1) begin
                    LED_BCD ={3'b000, rt[4]};
                end
                else begin
                    LED_BCD = result[7:4];
                end
            end
            2'b01: begin
                Anode_Activate = 4'b1011; 
                if(!S0 && !S1) begin
                   LED_BCD = curPC[3:0];
                end
                else if(!S0 && S1) begin
                    LED_BCD = rs[3:0];
                end
                else if(S0 && !S1) begin
                    LED_BCD = rt[3:0];
                end
                else begin
                    LED_BCD = result[3:0];
                end
            end
            2'b10: begin
                Anode_Activate = 4'b1101; 
                if(!S0 && !S1) begin
                   LED_BCD = nextPC[7:4];
                end
                else if(!S0 && S1) begin
                    LED_BCD = A[7:4];
                end
                else if(S0 && !S1) begin
                    LED_BCD = B[7:4];
                end
                else begin
                    LED_BCD = DB[7:4];                    
                end
            end
            2'b11: begin
                Anode_Activate = 4'b1110; 
                if(!S0 && !S1) begin
                   LED_BCD = nextPC[3:0];
                end
                else if(!S0 && S1) begin
                    LED_BCD = A[3:0];
                end
                else if(S0 && !S1) begin
                    LED_BCD = B[3:0];
                end
                else begin
                    LED_BCD = DB[3:0];
                end
            end
        endcase
    end
     // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
            4'b0000: LED_out = 7'b0000001; // "0"     
            4'b0001: LED_out = 7'b1001111; // "1" 
            4'b0010: LED_out = 7'b0010010; // "2" 
            4'b0011: LED_out = 7'b0000110; // "3" 
            4'b0100: LED_out = 7'b1001100; // "4" 
            4'b0101: LED_out = 7'b0100100; // "5" 
            4'b0110: LED_out = 7'b0100000; // "6" 
            4'b0111: LED_out = 7'b0001111; // "7" 
            4'b1000: LED_out = 7'b0000000; // "8"     
            4'b1001: LED_out = 7'b0000100; // "9" 
            4'b1010: LED_out = 7'b0001000;  //A
            4'b1011: LED_out = 7'b1100000;  //B
            4'b1100: LED_out = 7'b0110001;  //C
            4'b1101: LED_out = 7'b1000010;  //D
            4'b1110: LED_out = 7'b0110000;  //E
            4'b1111: LED_out = 7'b0111000; //F
            default: LED_out = 7'b0000000;  //≤ª¡¡
        endcase
    end

endmodule
