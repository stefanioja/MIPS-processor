module ALUControl(Func, 
                  ALUOP, 
                  AluSelect);
  
  input [5:0]      Func;
  input [1:0]      ALUOP;
  output reg [2:0] AluSelect;
  
  always @(*) begin
    case(ALUOP) 
      2'b00: AluSelect = 3'b010; //add
 	  2'b01: AluSelect = 3'b110; //substract
      default: case(Func) //R
        6'b100000: AluSelect = 3'b010; // ADD
		6'b100010: AluSelect = 3'b110; // SUB
		6'b100100: AluSelect = 3'b000; // AND
		6'b101010: AluSelect = 3'b111; // SLT
      	endcase
    endcase
  end
endmodule