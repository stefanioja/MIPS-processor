module RegisterFile(Clk, 
                    Addr1, 
                    Addr2, 
                    Addr3, 
                    WriteData, 
                    WriteEnable, 
                    ReadData1, 
                    ReadData2);
  
  input             Clk;
  input [4:0]       Addr1;
  input [4:0]       Addr2;
  input [4:0]       Addr3;
  input [31:0]      WriteData;
  input             WriteEnable;
  output reg [31:0] ReadData1;
  output reg [31:0] ReadData2;
  
  reg[31:0]         RegBank [31:0];
  
  integer i;
  initial begin
    for(i = 0;i < 32;i = i + 1)
      RegBank[i] = i;
  end
  
  always @(Addr1, Addr2) begin
    ReadData1 = RegBank[Addr1];
    ReadData2 = RegBank[Addr2];
  end
  
  always @(posedge Clk) begin
    if(WriteEnable && Addr3 != 0) begin // $0 hardwired to 0
      RegBank[Addr3] <= WriteData;
    end
  end
endmodule