module Mux #(parameter N = 8, parameter O = 32)
  (Input1, 
   Input2,
   Select,
   Output);
  
  input [N - 1:0]      Input1;
  input [N - 1:0]      Input2;
  input                Select; 
  output reg [O - 1:0]    Output;

    always @(*) begin
      case(Select)
            0: Output = Input1;
            1: Output = Input2;
        endcase
    end
endmodule