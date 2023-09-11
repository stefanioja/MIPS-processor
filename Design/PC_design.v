module ProgramCounter(Input,
                      Clk, 
                      Reset, 
                      Output);
  
  input [31:0]      Input;
  input             Clk;
  input             Reset;
  output reg [31:0] Output;
  
  always @(posedge Clk, posedge Reset) begin
    if(Reset) Output <= 0;
    else
    	Output <= Input;
  end
endmodule