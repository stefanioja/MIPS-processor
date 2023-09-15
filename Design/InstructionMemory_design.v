module InstructionMemory(Addr, 
                         Out1, 
                         Out2, 
                         Out3, 
                         Out4, 
                         Out5, 
                         Out6, 
                         Out7,
                         Out8);
  
  input [31:0]      Addr;
  output reg [25:0] Out1;
  output reg [5:0]  Out2;
  output reg [4:0]  Out3;
  output reg [4:0]  Out4;
  output reg [4:0]  Out5;
  output reg [15:0] Out6;
  output reg [5:0]  Out7;
  output reg [4:0]  Out8;
  
  reg [31:0]        ASM [31:0];
  
  initial begin
    $readmemb ("memfile.dat",ASM);
  end
  
  always @(Addr) begin
    Out1 = ASM[Addr>>2][25:0];
    Out2 = ASM[Addr>>2][31:26];
    Out3 = ASM[Addr>>2][25:21];
    Out4 = ASM[Addr>>2][20:16];
    Out5 = ASM[Addr>>2][15:11];
    Out6 = ASM[Addr>>2][15:0];
    Out7 = ASM[Addr>>2][5:0];
    Out8 = ASM[Addr>>2][10:6];
  end
  
endmodule