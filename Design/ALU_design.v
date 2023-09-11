module ALU(SrcA, 
           SrcB, 
           Control,
           Zero, 
           Result);
  
  input[31:0]       SrcA;
  input[31:0]       SrcB;
  input[2:0]        Control;
  output reg        Zero;
  output reg [31:0] Result;
  
  always @(*) begin
    case(Control)
      3'b000: Result = SrcA & SrcB; //AND
      3'b001: Result = SrcA | SrcB; //OR
      3'b010: Result = SrcA + SrcB; //ADD
      3'b110: Result = SrcA - SrcB; //SUBSTRACT
      3'b111: Result =  (SrcA < SrcB) ? 1 : 0; //SLT
    endcase
    Zero = (Result == 0) ? 1 : 0; //ZERO
  end
endmodule