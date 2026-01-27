`include "./rtl/define.sv"
`include "./rtl/ins_decoder.sv"

module top (
    input clk,
    input rst
);

  logic clk_b;
  assign clk_b = ~clk;

  // IF
  logic [`DATA_WIDTH - 1:0]  pc, ir;

  // IF/ID
  logic [`DATA_WIDTH - 1:0]  if_id_pc;
  logic [`DATA_WIDTH - 1:0]  if_id_pc_4;
  logic [`DATA_WIDTH - 1:0]  if_id_ir;

  // ID
  logic                      id_reg_web;
  logic [1:0]                id_branch_typ;
  logic [2:0]                id_alu_code;
  logic [3:0]                id_funct3;
  logic [6:0]                id_opcode;
  logic [$clog2(`REG_NUM):0] id_r1_idx;
  logic [$clog2(`REG_NUM):0] id_r2_idx;
  logic [$clog2(`REG_NUM):0] id_rd_idx;
  logic [`DATA_WIDTH - 1:0]  id_imm;
  logic [`DATA_WIDTH - 1:0]  regfile [0:`REG_NUM - 1];

  // ID_EX

  // EX
  logic ex_branch_en;
  logic [`DATA_WIDTH - 1:0]  ex_branch_address;

  SRAM_wrapper IM1 (
      .CK (clk_b),
      .CS (1'b1),
      .OE (1'b1),
      .WEB(4'b1111),
      .A  (pc[15:2]),
      .DI (32'd0),
      .DO (ir)
  );

  ins_decoder Decode (
      .ir        (if_id_ir),
      .reg_web   (id_reg_web),
      .branch_typ(id_branch_typ),
      .alu_code  (id_alu_code),
      .funct3    (id_funct3),
      .opcode    (id_opcode),
      .r1_idx    (id_r1_idx),
      .r2_idx    (id_r2_idx),
      .rd_idx    (id_rd_idx),
      .imm       (id_imm)
  );

  SRAM_wrapper DM1 (
      .CK (),
      .CS (),
      .OE (),
      .WEB(),
      .A  (),
      .DI (),
      .DO ()
  );

  always @(clk) begin : fetch
    if (rst) begin
      pc <= 32'd0;
      if_id_pc <= 32'd0;
      if_id_pc_4 <= 32'd0;
    end else begin
      if (ex_branch_en) begin
        pc <= ex_branch_address;
      end else begin
        pc <= pc + 4;
      end

      if_id_pc   <= pc;
      if_id_pc_4 <= pc + 4;
      if_id_ir   <= ir;
    end
  end

endmodule
