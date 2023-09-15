module ALUControl(Func, 
                  ALUOP, 
                  AluSelect,
                  JRSel);
  
  input [5:0]      Func;
  input [1:0]      ALUOP;
  output reg [2:0] AluSelect;
  output reg       JRSel;
  
  assign JRSel = (Func == 6'b001000) ? 1 : 0;
  always @(*) begin
    case(ALUOP) 
      2'b00: AluSelect = 3'b010; //add
 	    2'b01: AluSelect = 3'b110; //sub
      2'b11: AluSelect = 3'b111; //slt
      default: case(Func) //R
        6'b100000: AluSelect = 3'b010; // ADD
		    6'b100010: AluSelect = 3'b110; // SUB
		    6'b100100: AluSelect = 3'b000; // AND
		    6'b101010: AluSelect = 3'b111; // SLT
        6'b000000: AluSelect = 3'b100; // SLL
      	endcase
    endcase
  end
endmodule