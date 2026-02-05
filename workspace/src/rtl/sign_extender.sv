`define "./define.sv"

module sign_extender (
  input  [2:0] imm_src,
  input  [`DATA_WIDTH - 1:0] imm_in,
  output [`DATA_WIDTH - 1:0] imm_ext
);
 assign imm_ext = (imm_src == 3'b000) ? {{20{imm_in[31]}},imm_in[31:20]} : // I Type
                  (imm_src == 3'b001) ? {{20{imm_in[31]}},imm_in[31:25],imm_in[11:7]} : // S Type
                  (imm_src == 3'b010) ? {{19{imm_in[31]}},imm_in[31],imm[7],imm[30:25],imm[11:8],1'b0} : // B Type
                  (imm_src == 3'b011) ? {imm_in[31:12],{12{1'b0}}} : // U Type
                  (imm_src == 3'b100) ? {{11{imm_in[31]}},imm_in[31],imm[19:12],imm_in[20],imm_in[30:21],1'b0} : // J Type
                  32'd0;
endmodule
