module SignExtend(Input, 
                  SignImm);
  
  input[15:0]       Input;
  output reg [31:0] SignImm;
  
  assign SignImm = { {16{Input[15]}}, Input };
endmodule