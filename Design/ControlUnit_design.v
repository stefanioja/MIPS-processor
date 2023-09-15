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
  output [1:0] RegDst; 
  output       Jump; 
  output       Branch; 
  output       MemRead; 
  output [1:0] MemtoReg;
  output [1:0] ALUOp;
  output       MemWrite;
  output       ALUSrc;
  output       RegWrite;
  
  reg [11:0]    Controls;
  always @Opcode begin
    case(Opcode)
      6'b000000: Controls = 12'b010000010001; //R
      6'b100011: Controls = 12'b000010100011; //lw
      6'b101011: Controls = 12'b000000000110; //sw
      6'b000100: Controls = 12'b000100001000; //beq
      6'b001000: Controls = 12'b000000000111; //addi
      6'b000010: Controls = 12'b001000000000; //j
      6'b000011: Controls = 12'b101001000001; //jal           
      6'b001010: Controls = 12'b000000011011; //slti
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