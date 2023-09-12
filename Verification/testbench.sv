module test;
  reg         Clk;
  reg         Reset;
  wire [31:0] TestReg; 

  MIPS DUV_MIPS(Clk, Reset, TestReg);

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, DUV_MIPS);
    Clk = 1; Reset = 1; 
    #4; 
    Reset = 0;
    #4;
    #4;
    #28;
    $finish;
  end
  always #2 Clk = ~Clk;
endmodule