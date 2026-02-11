`define "./define.sv"
`define "./branch.sv"
`define "./alu.sv"

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
  output                     mem_write_m,
  output                     reg_write_m,
  output                     pc_src_e
);
  logic [`DATA_WIDTH - 1:0] src_a_e;
  logic [`DATA_WIDTH - 1:0] src_b_e;
  logic [`DATA_WIDTH - 1:0] write_data_e;
  logic [`DATA_WIDTH - 1:0] alu_result_e;
  logic                     zero_e;
  
  assign src_a_e      = alu_r1_src_e ? pc_e : rd1_e;
  assign src_b_e      = alu_r2_src_e ? imm_ext_e : rd2_e;
  assign write_data_e = rd2_e;
  assign pc_target_e  = pc_plus_src_e ? rd1_e + imm_ext_e :
                        pc_e + imm_ext_e;
  always @(*) begin
    if (branch_e) begin
      branch branch (
        .alu_control(alu_control_e),
        .src_a(src_a_e),
        .src_b(src_b_e),
        .zero(zero_e)
      );
      alu_result_e = 32'd0;
    end
    else begin
     alu alu (
       .alu_control(alu_control_e),
       .src_a(src_a_e),
       .src_b(src_b_e),
       .alu_result(alu_result_e)
     );
     zero_e = 1'b0;
    end
  end
  assign pc_src_e = (branch_e & zero_e) | jump_e;
  always @(posedge clk) begin
    if(rst) begin
      reg_write_m  <= 1'b0;
      mem_write_m  <= 1'd0;
      alu_result_m <= 32'd0;
      write_data_m <= 32'd0;
      pc_plus_4_m  <= 32'd0;
      rd_idx_m     <= 5'd0;
      result_src_m <= 2'd0;
    end
    else begin
      reg_write_m  <= reg_write_e;
      mem_write_m  <= mem_write_e;
      alu_result_m <= alu_result_e;
      write_data_m <= write_data_e;
      pc_plus_4_m  <= pc_plus_4_e;
      rd_idx_m     <= rd_idx_e;
      result_src_m <= result_src_e;
    end
  end
endmodule
