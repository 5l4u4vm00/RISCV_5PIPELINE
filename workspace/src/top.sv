`include "./rtl/define.sv"
`include "./rtl/ins_decoder.sv"

module top (
    input clk,
    input rst
);

  logic  clk_b;
  assign clk_b = ~clk;

  // IF
  logic [`DATA_WIDTH - 1:0]  pc;
  logic [`DATA_WIDTH - 1:0]  ir;

  // IF/ID
  logic [`DATA_WIDTH - 1:0]  if_id_pc;
  logic [`DATA_WIDTH - 1:0]  if_id_pc_4;
  logic [`DATA_WIDTH - 1:0]  if_id_ir;

  // ID
  logic                          id_reg_web;
  logic [1:0]                    id_branch_typ;
  logic [2:0]                    id_alu_code;
  logic [3:0]                    id_funct3;
  logic [6:0]                    id_opcode;
  logic [$clog2(`REG_NUM) - 1:0] id_r1_idx;
  logic [$clog2(`REG_NUM) - 1:0] id_r2_idx;
  logic [$clog2(`REG_NUM) - 1:0] id_rd_idx;
  logic [`DATA_WIDTH - 1:0]      id_imm;
  logic [`DATA_WIDTH - 1:0]      regfile [0:`REG_NUM - 1];

  // ID_EX
  logic                          id_ex_reg_web;
  logic [1:0]                    id_ex_branch_typ;
  logic [2:0]                    id_ex_alu_code;
  logic [3:0]                    id_ex_funct3;
  logic [6:0]                    id_ex_opcode;
  logic [`DATA_WIDTH - 1:0]      id_ex_r1;
  logic [`DATA_WIDTH - 1:0]      id_ex_r2;
  logic [`DATA_WIDTH - 1:0]      id_ex_pc;
  logic [`DATA_WIDTH - 1:0]      id_ex_pc_4;
  logic [`DATA_WIDTH - 1:0]      id_ex_imm;
  logic [$clog2(`REG_NUM) - 1:0] id_ex_r1_idx;
  logic [$clog2(`REG_NUM) - 1:0] id_ex_r2_idx;
  logic [$clog2(`REG_NUM) - 1:0] id_ex_rd_idx;

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

  always @(clk) begin : decode
    if (rst) begin
      id_ex_reg_web    <= 1'b0;
      id_ex_branch_typ <= 2'd0;
      id_ex_alu_code   <= 3'd0;
      id_ex_funct3     <= 4'd0;
      id_ex_r1_idx     <= 5'd0;
      id_ex_r2_idx     <= 5'd0;
      id_ex_rd_idx     <= 5'd0;
      id_ex_opcode     <= 7'd0;
      id_ex_r1         <= 32'd0;
      id_ex_r2         <= 32'd0;
      id_ex_pc         <= 32'd0;
      id_ex_pc_4       <= 32'd0;
      id_ex_imm        <= 32'd0;
    end
    else begin
      id_ex_reg_web    <= id_reg_web;
      id_ex_branch_typ <= id_branch_typ;
      id_ex_alu_code   <= id_alu_code;
      id_ex_funct3     <= id_funct3;
      id_ex_r1_idx     <= id_r1_idx;
      id_ex_r2_idx     <= id_r2_idx;
      id_ex_rd_idx     <= id_rd_idx;
      id_ex_opcode     <= id_opcode;
      id_ex_r1         <= regfile[id_r1_idx];
      id_ex_r2         <= regfile[id_r2_idx];
      id_ex_pc         <= if_id_pc;
      id_ex_pc_4       <= if_id_pc_4;
      id_ex_imm        <= id_imm;
    end
  end
  
  always @(*) begin : ex_alu_op1_select
    case (id_ex_opcode)
      `JALR,`BTYPE,`AUIPC,`JAL:
        ex_alu_op1 = id_ex_pc;//rs1 = pc
      `LUI:
        ex_alu_op1 = 32'b0;//rs1 = 0
      default:
        ex_alu_op1 = id_ex_r1;//rs1 = s1(data forwarding)
    endcase
  end
  
  always @(*) begin : ex_alu_op2_select
    case (id_ex_opcode)
      `LD,`ALUI,`STYPE,`BTYPE,`AUIPC,`LUI:
        ex_alu_op2 = id_ex_imm;//rs2 = imm
  		`JAL:
        ex_alu_op2 = 32'd4;//rs1 = 0
      default:
        ex_alu_op2 = id_ex_r2;//rs2 = s2(data forwarding)
    endcase
  end

