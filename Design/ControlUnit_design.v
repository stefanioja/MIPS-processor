module Control(Opcode,
               RegDst, 
               Jump, 
               Branch, 
               MemRead, 
               MemtoReg,
               ALUOp,
               MemWrite,
               ALUSrc,
               RegWrite);
  
  input [5:0]  Opcode;
  output       RegDst; 
  output       Jump; 
  output       Branch; 
  output       MemRead; 
  output       MemtoReg;
  output [1:0] ALUOp;
  output       MemWrite;
  output       ALUSrc;
  output       RegWrite;
  
  reg [9:0]    Controls;
  
  always @Opcode begin
    case(Opcode)
      6'b000000: Controls = 10'b1000010001; //R
      6'b100011: Controls = 10'b0001100011; //lw
      6'b101011: Controls = 10'b0000000110; //sw
      6'b000100: Controls = 10'b0010001000; //beq
      6'b001000: Controls = 10'b0000000110; //addi
      6'b000010: Controls = 10'b0100000000; //j
    endcase
  end
  
  assign { RegDst, 
           Jump, 
           Branch, 
           MemRead, 
           MemtoReg,
           ALUOp,
           MemWrite,
           ALUSrc,
           RegWrite } = Controls;
endmodule