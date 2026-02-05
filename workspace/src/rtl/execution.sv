`define "./define.sv"

module execution (
  input                      clk,
  input                      rst,
  input  [`DATA_WIDTH - 1:0] rd1_e,
  input  [`DATA_WIDTH - 1:0] rd2_e,
  input  [`DATA_WIDTH - 1:0] pc_e,
  input  [`DATA_WIDTH - 1:0] pc_plus_4_e,
  input  [`DATA_WIDTH - 1:0] pc_plus_4_e,
  input  [`DATA_WIDTH - 1:0] imm_ext_e,
  input  [1:0]               result_src_e,
  input  [1:0]               result_src_e,
  input  [2:0]               alu_control_e,
  input  [4:0]               rd_idx_e,
  input                      reg_write_e,
  input                      mem_write_e,
  input                      jump_e,
  input                      branch_e,
  input                      alu_r1_src_e,
  input                      alu_r2_src_e,
  input                      pc_plus_src_e,
  output [`DATA_WIDTH - 1:0] pc_target_e,
  output [`DATA_WIDTH - 1:0] alu_result_m,
  output [`DATA_WIDTH - 1:0] write_data_m,
  output [`DATA_WIDTH - 1:0] pc_plus_4_m,
  output [4:0]               rd_idx_m,
  output [1:0]               result_src_m,
  output                     mem_write_d,
  output                     reg_write_m,
  output                     pc_src_e
);
  logic [`DATA_WIDTH - 1:0] src_a_e;
  logic [`DATA_WIDTH - 1:0] src_b_e;
  logic [`DATA_WIDTH - 1:0] write_data_e;
  
  assign src_a_e      = alu_r1_src_e ? pc_e : rd1_e;
  assign src_b_e      = alu_r2_src_e ? imm_ext_e : rd2_e;
  assign write_data_e = rd2_e;
  assign pc_target_e  = pc_plus_src_e ? rd1_e + imm_ext_e :
                        pc_e + imm_ext_e;
endmodule
