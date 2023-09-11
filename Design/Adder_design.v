module Adder(x, 
             y,
             Output);
  
  input [31:0]  x;
  input [31:0]  y;
  output [31:0] Output;
  
  assign Output = x + y;
endmodule

module AdderPC(Input, 
               Output);
  
  input [31:0]      Input;
  output reg [31:0] Output;
  
  always @Input 
    Output = Input + 32'h00000004;
endmodule