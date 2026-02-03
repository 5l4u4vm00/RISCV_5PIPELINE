`define "./define.sv"

module decode_cycle (
  input                      clk,
  input                      rst,
  input  [`DATA_WIDTH - 1:0] instr_d,
  input  [`DATA_WIDTH - 1:0] pc_d,
  input  [`DATA_WIDTH - 1:0] pc_plus_4_d,
  output [`DATA_WIDTH - 1:0] rd1_e,
  output [`DATA_WIDTH - 1:0] rd2_e,
  output [`DATA_WIDTH - 1:0] pc_e,
  output [`DATA_WIDTH - 1:0] pc_plus_4_e,
  output [`DATA_WIDTH - 1:0] imm_ext_e,
  output [4:0] rd_idx_e,
  output reg_wtite_e,
  output reg_wtite_e,
  output mem_write_e,
  output jump_e,
  output branch_e,
  output alu_src_e,
  output [1:0] result_src_e,
  output [2:0] alu_control_e,
);

endmodule
