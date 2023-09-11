module Shift(Input,
             Output);
  
  input [31:0]  Input;
  output [31:0] Output;
  
  assign Output = Input<<2;
  
endmodule

module ShiftJump(Input1,
                 Input2,
                 Output);
  
  input [25:0]   Input1;
  input [31:0]   Input2;
  output [31:0]  Output;
  
  reg [27:0]    RegBank;
  
  always @Input1 RegBank = Input1 << 2;
  
  assign Output = { Input2[31:28] , RegBank };
endmodule