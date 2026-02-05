`define "./define.sv"
`define "./control_unit.sv"
`define "./sign_extender.sv"

module decode (
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
  output [1:0] result_src_e,
  output reg_write_e,
  output mem_write_e,
  output jump_e,
  output branch_e,
  output alu_r1_src_e,
  output alu_r2_src_e,
  output pc_plus_src_e,
  output [1:0] result_src_e,
  output [2:0] alu_control_e,
);
  logic [1:0] result_src_d;
  logic [2:0] imm_src_d;
  logic [3:0] alu_control_d;
  logic [`DATA_WIDTH - 1:0] imm_ext_d;
  logic reg_write_d;
  logic mem_write_d;
  logic jump_d;
  logic branch_d;
  logic alu_r1_src_d;
  logic alu_r2_src_d;
  logic pc_plus_src_d;
  logic [5:0] rd1_d;
  logic [5:0] rd2_d;
  logic [`DATA_WIDTH - 1:0] register_file [`DATA_WIDTH - 1:0] // 32 * 32

  assign rd1_d = register_file[instr_d[19:15]];
  assign rd2_d = register_file[instr_d[24:20]];

  control_unit control_unit (
    .funct7(instr_d[31:25]),
    .funct3(instr_d[14:12]),
    .opcode(instr_d[6:0]),
    .result_src(result_src_d),
    .imm_src(imm_src_d),
    .alu_control(alu_control_d),
    .reg_write(reg_write_d),
    .mem_write(mem_write_d),
    .jump(jump_d),
    .branch(branch_d),
    .alu_r1_src(alu_r1_src_d),
    .alu_r2_src(alu_r2_src_d),
    .pc_plus_src(pc_plus_src_d)
  );

  sign_extender sign_extender (
    .imm_src(imm_src_d),
    .imm_in(instr_d),
    .imm_ext(imm_ext_d)
  );

  always @(posedge clk) begin
    if (rst) begin
      rd1_e         <= 32'd0;
      rd2_e         <= 32'd0;
      pc_e          <= 32'd0;
      pc_plus_4_e   <= 32'd0;
      imm_ext_e     <= 32'd0;
      rd_idx_e      <=  5'd0;
      result_src_e  <=  2'd0;
      reg_write_e   <=  1'b0;
      mem_write_e   <=  1'b0;
      jump_e        <=  1'b0;
      branch_e      <=  1'b0;
      alu_r1_src_e  <=  1'b0;
      alu_r2_src_e  <=  1'b0;
      pc_plus_src_e <=  1'b0;
      result_src_e  <=  2'd0;
      alu_control_e <=  3'd0;
    end
    else begin
      rd1_e         <= rd1_d;
      rd2_e         <= rd2_d;
      pc_e          <= pc_d;
      pc_plus_4_e   <= pc_plus_4_d;
      imm_ext_e     <= imm_ext_d;
      rd_idx_e      <= rd_idx_d;
      result_src_e  <= result_src_d;
      reg_write_e   <= reg_write_d;
      mem_write_e   <= mem_write_d;
      jump_e        <= jump_d;
      branch_e      <= branch_d;
      alu_r1_src_e  <= alu_r1_src_d;
      alu_r2_src_e  <= alu_r2_src_d;
      pc_plus_src_e <= pc_plus_src_d;
      result_src_e  <= result_src_d;
      alu_control_e <= alu_control_d;
    end
  end
endmodule                    
