module DataMemory(Addr, 
                  WriteData, 
                  Clk, 
                  WriteEnable, 
                  MemRead, 
                  ReadData);
  
  input [31:0]      Addr; 
  input [31:0]      WriteData; 
  input             Clk; 
  input             WriteEnable; 
  input             MemRead; 
  output reg [31:0] ReadData;
  
  
  reg [31:0]        RegBank[63:0];
   
  integer i;
  initial begin
    for(i = 0;i < 64;i = i + 1)
      RegBank[i] = i;
  end

  always @(posedge Clk) begin
    if(WriteEnable) RegBank[Addr] <= WriteData;
  end
  
  always @(*) begin
    if(MemRead == 1) ReadData = RegBank[Addr];
  end
endmodule