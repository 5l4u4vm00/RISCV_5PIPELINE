`define "./define.sv"

module alu (
  input  [3:0] alu_control,
  input  [`DATA_WIDTH - 1:0] src_a,
  input  [`DATA_WIDTH - 1:0] src_b,
  output [`DATA_WIDTH - 1:0] alu_result,
  output                     zero_e
);
  always @(*) begin
    case (alu_result)
      4'b0000: alu_result = src_a + src_b;
      4'b1000: alu_result = src_a - src_b;
      default : 
    endcase
  end
  
endmodule
