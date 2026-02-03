`define "./define.sv"

module sign_extender (
  input  [2:0] imm_src,
  input  [`DATA_WIDTH - 1:0] imm_in,
  output [`DATA_WIDTH - 1:0] imm_ext
);
  
endmodule
