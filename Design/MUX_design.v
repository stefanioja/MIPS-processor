module Mux #(parameter N = 32)
  (Input1, 
   Input2,
   Select,
   Output);
  
  input [N - 1:0]         Input1;
  input [N - 1:0]         Input2;
  input                   Select; 
  output reg [N - 1:0]    Output;

    always @(*) begin
      case(Select)
            0: Output = Input1;
            1: Output = Input2;
        endcase
    end
endmodule

module MuxJ #(parameter N = 32)
  (Input1, 
   Input2,
   Input3,
   Select,
   Output);
  
  input [N - 1:0]         Input1;
  input [N - 1:0]         Input2;
  input [N - 1:0]         Input3;
  input [1:0]             Select; 
  output reg [N - 1:0]    Output;

    always @(*) begin
      case(Select)
            0: Output = Input1;
            1: Output = Input2;
        	2: Output = Input3;
        endcase
    end
endmodule