// Code your design here
`include "PC_design.v"
`include "InstructionMemory_design.v"
`include "ControlUnit_design.v"
`include "MUX_design.v"
`include "RegisterFile_design.v"
`include "ALUControl_design.v"
`include "ALU_design.v"
`include "DataMemory_design.v"
`include "SignExt_design.v"
`include "Adder_design.v"
`include "Shift_design.v"
`include "AND_design.v"
`include "monitor.sv"
module MIPS(Clk,
            Reset,
            TestReg);
  
  input          Clk;
  input          Reset;
  output [31:0]  TestReg;
  
  assign TestReg = DUT_RF.RegBank[31];
  
  wire [31:0] PCIn;
  wire [31:0] PCOut;
  ProgramCounter DUT_PC(PCIn, Clk, Reset, PCOut);
  
  wire [31:0] PC4;
  AdderPC DUT_APC(PCOut, PC4);
  
  wire [25:0] InstrShift;
  wire [5:0]  InstrControl;
  wire [4:0]  InstrAddr1;
  wire [4:0]  InstrAddr2;
  wire [4:0]  InstrAddr3;
  wire [15:0] InstrSext;
  wire [5:0]  InstrFunc;
  InstructionMemory DUT_IM(PCOut, InstrShift, InstrControl, InstrAddr1, InstrAddr2, InstrAddr3, InstrSext, InstrFunc);
  
  wire [1:0] RegDst; 
  wire       Jump; 
  wire       Branch; 
  wire       MemRead; 
  wire [1:0] MemtoReg;
  wire [1:0] ALUOp;
  wire       MemWrite;
  wire       ALUSrc;
  wire       RegWrite;
  Control DUT_CONTROL(InstrControl, RegDst, Jump, Branch, MemRead, MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite);
  
  wire [4:0] WriteRegister;
  
  reg [5:0] ReturnAddr = 5'b11111;
  MuxJ #(5, 5) DUT_MUXReg(InstrAddr2, InstrAddr3, ReturnAddr, RegDst, WriteRegister);
  
  wire [31:0] WriteData, SrcA, RD2, SrcB;
  RegisterFile DUT_RF(Clk, InstrAddr1, InstrAddr2, WriteRegister, WriteData, RegWrite, SrcA, RD2);
  
  wire [2:0] AluSelect;
  ALUControl DUT_ALUC(InstrFunc, ALUOp, AluSelect);
  
  wire Zero;
  wire[31:0] AluResult;
  ALU DUT_ALU(SrcA, SrcB, AluSelect, Zero, AluResult);
  
  wire [31:0] RD;
  DataMemory DUT_DM(AluResult, RD2, Clk, MemWrite, MemRead, RD); 
  
  wire [31:0] SignImm;
  SignExtend DUT_SE(InstrSext, SignImm);
  
  Mux #(32) DUT_MUXSign(RD2, SignImm, ALUSrc, SrcB);
  
  MuxJ #(32) DUT_MUXData(AluResult, RD, JumpAddr, MemtoReg, WriteData);
  
  wire BranchSelect;
  AND DUT_AND(Branch, Zero, BranchSelect);
 
  wire [31:0] AddBranch;
  wire [31:0] ShiftBranch;
  Adder DUT_ADDBranch(PC4, ShiftBranch, AddBranch);
  
  Shift DUT_SH(SignImm, ShiftBranch);
  
  wire [31:0] BranchAddr;
  Mux #(32) DUT_MUXBranch(PC4, AddBranch, BranchSelect, BranchAddr);
  
  wire [31:0] JumpAddr;
  ShiftJump DUT_SJMP(InstrShift, PC4, JumpAddr);
  
  Mux #(32) MUXJmp(BranchAddr, JumpAddr, Jump, PCIn);
  
endmodule