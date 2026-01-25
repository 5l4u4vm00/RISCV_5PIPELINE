`include "./define.sv"

module ins_decoder (
    output logic                       reg_web,
    output logic [6:0]                 opcode,
    output logic [2:0]                 branch_typ,
    output logic [3:0]                 funct3,
    output logic [2:0]                 alu_code,
    output logic [$clog2(`REG_NUM):0]  r1_index,
    output logic [$clog2(`REG_NUM):0]  r2_index,
    output logic [$clog2(`REG_NUM):0]  rd_index,
    output logic [`DATA_WIDTH - 1:0]   imm,
    input  logic [`DATA_WIDTH - 1:0]   ir
);
  assign r1_index = `RS1;
  assign r2_index = `RS2;
  assign rd_index = `RD;
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
