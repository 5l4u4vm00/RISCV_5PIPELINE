module ins_decoder (
    output logic                           reg_web,
    output logic [1:0]                     branch_typ,
    output logic [2:0]                     alu_code,
    output logic [3:0]                     funct3,
    output logic [6:0]                     opcode,
    output logic [$clog2(`REG_NUM) - 1:0]  r1_idx,
    output logic [$clog2(`REG_NUM) - 1:0]  r2_idx,
    output logic [$clog2(`REG_NUM) - 1:0]  rd_idx,
    output logic [`DATA_WIDTH - 1:0]       imm,
    input  logic [`DATA_WIDTH - 1:0]       ir
);
  assign r1_idx   = `RS1;
  assign r2_idx   = `RS2;
  assign rd_idx   = `RD;
  assign opcode   = `OPCODE;
  assign funct3   = `FUNCT_3;

  always @(*) begin
    case (`OPCODE)
      `ALU:begin // R_Type
        alu_code   = {`FUNCT7_5 ,`FUNCT_3};
        imm        = 32'd0;
        reg_web    = 1'b0;
        branch_typ = `BRANCH_NONE;
      end
      `ALUI:begin // I Type
        if (`FUNCT_3 == 3'b101)begin
          alu_code = {`FUNCT7_5 , `FUNCT_3};
        end
        else begin
          alu_code = {1'b0,`FUNCT_3};
        end
        imm        = {{20{`IMM_SIGN}, `I_IMM};
        reg_web    = 1'b0;
        branch_typ = `BRANCH_NONE;
      end
      `LD:begin // I Type
        alu_code   = {1'b0, `FUNCT_3};
        imm        = {{20{`IMM_SIGN}, `I_IMM};
        reg_web    = 1'b1;
        branch_typ = `BRANCH_NONE;
      end
      `STYPE:begin // s_type
        alu_code   = 4'd0;
        imm        = {{20{`IMM_SIGN, `S_IMM};
        reg_web    = 1'b0;
        branch_typ = `BRANCH_NONE;
      end
      `LUI:begin // u_type
        alu_code   = 4'd0;
        imm        = {`U_IMM, 12'd0};
        reg_web    = 1'b1;
        branch_typ = `BRANCH_NONE;
      end
      `AUIPC: begin // u-type
        alu_code   = 4'd0;
        imm        = {`U_IMM, 12'd0};
        reg_web    = 1'b1;
        branch_typ = `BRANCH_NONE;
      end
      `BTYPE: begin // b-type
        alu_code   = 4'd0;
        imm        = {{19{`IMM_SIGN}, `B_IMM, 1'b0};
        reg_web    = 1'b0;
        branch_typ = `BRANCH_COM;
      end
      `JAL: begin // J_type
        alu_code   = 4'd0;
        imm        = {{11{`IMM_SIGN}, `J_IMM};
        reg_web    = 1'b1;
        branch_typ = `BRANCH_JAL;
      end
      `JALR: begin // I-type
        alu_code   = 4'd0;
        imm        = {{20{`IMM_SIGN}}, `I_IMM};
        reg_web    = 1'b1;
        branch_typ = `BRANCH_JALR;
      end
      default: begin
        alu_code   = 4'd0;
        imm        = 32'd0;
        reg_web    = 1'b0;
        branch_typ = `BRANCH_NONE;
      end
    endcase
  end
endmodule
