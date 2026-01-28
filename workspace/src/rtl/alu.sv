`include "./define.sv"

module alu (
  input  [2:0]               alu_code,
  input  [`DATA_WIDTH - 1:0] op1,
  input  [`DATA_WIDTH - 1:0] op2,
  output [`DATA_WIDTH - 1:0] res,
);

endmodule
