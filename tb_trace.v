`timescale 1ns/1ps

module tb_trace;
    reg clk;
    reg reset;

    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire StallF;
    wire StallD;
    wire FlushE;
    wire FlushD;
    wire BranchE;
    wire JumpE;
    wire JumpRE;
    wire PCSrcE;
    wire [31:0] PC_nowE;
    wire [4:0] Rs1E;
    wire [4:0] Rs2E;
    wire [4:0] RdE;
    wire [31:0] PCTargetE;
    wire [31:0] ReadDataM;
    wire [31:0] WriteDataE;
    wire [31:0] ALU_outE;

    integer cycle;

    RiscV_Datapath dut (
        clk,
        reset,
        ForwardAE,
        ForwardBE,
        StallF,
        StallD,
        FlushE,
        FlushD,
        BranchE,
        JumpE,
        JumpRE,
        PCSrcE,
        PC_nowE,
        Rs1E,
        Rs2E,
        RdE,
        PCTargetE,
        ReadDataM,
        WriteDataE,
        ALU_outE
    );

    initial begin
        clk = 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        cycle = 0;
        reset = 1'b0;
        #12 reset = 1'b1;
        #300 $finish;
    end

    always @(negedge clk) begin
        #1;
        if (reset) begin
            cycle = cycle + 1;
            $display("%0d,%08h,%08h,%08h,%0d,%0d,%0d,%08h,%08h",
                     cycle, ALU_outE, PC_nowE, PCTargetE, Rs1E, Rs2E,
                     RdE, ReadDataM, WriteDataE);
        end
    end
endmodule
