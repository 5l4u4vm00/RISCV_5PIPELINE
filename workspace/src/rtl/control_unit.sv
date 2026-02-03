`include "./define.sv"

module control_unit (
  input        funct7,
  input  [2:0] funct3,
  input  [6:0] opcode,
  output [1:0] result_src,
  output [2:0] imm_src,
  output [3:0] alu_control,
  output       reg_write,
  output       mem_write,
  output       jump,
  output       branch,
  output       alu_r1_src,
  output       alu_r2_src,
  output       pc_plus_src
);

always @(*) begin
  case (opcode)
    `R_TYPE:begin
      alu_control = {funct7, funct3};
      alu_r1_src = 1'b0;
      alu_r2_src = 1'b0;
      reg_write = 1'b1;
      mem_write = 1'b0;
      jump = 1'b0;
      branch = 1'b0;
      imm_src = 3'bxxx;
      result_src = 2'b00;
      pc_plus_src = 1'b0;
    end
    `I_ALU: begin
      if (funct3 == 3'b101) begin
        alu_control = {funct7, funct3};
      end
      else begin
        alu_control = {1'b0, funct3};
      end
      alu_r1_src = 1'b0;
      alu_r2_src = 1'b1;
      reg_write = 1'b1;
      mem_write = 1'b0;
      jump = 1'b0;
      branch = 1'b0;
      imm_src = 3'b000;
      result_src = 2'b00;
      pc_plus_src = 1'b0;
    end
    `I_LOAD: begin
      alu_control = {1'b1, funct3};
      alu_r1_src = 1'b0;
      alu_r2_src = 1'b1;
      reg_write = 1'b1;
      mem_write = 1'b1;
      jump = 1'b0;
      branch = 1'b0;
      imm_src = 3'b000;
      result_src = 2'b01;
      pc_plus_src = 1'b0;
    end
    `JALR: begin
      alu_control = {1'b0, funct3};
      alu_r1_src = 1'b0;
      alu_r2_src = 1'b1;
      reg_write = 1'b1;
      mem_write = 1'b0;
      jump = 1'b1;
      branch = 1'b0;
      imm_src = 3'b000;
      result_src = 2'b10;
      pc_plus_src = 1'b1;
    end
    `S_TYPE: begin
      alu_control = 4'b0000;
      alu_r1_src = 1'b0;
      alu_r2_src = 1'b1;
      reg_write = 1'b0;
      mem_write = 1'b0;
      jump =1'b0;
      branch = 1'b0;
      imm_src = 3'b001;
      result_src = 2'bxx;
      pc_plus_src = 1'b0;
    end
    `B_TYPE: begin
      alu_control = {1'b0, funct3};
      alu_r1_src = 1'b0;
      alu_r2_src = 1'b0;
      reg_write = 1'b0;
      mem_write = 1'b0;
      jump = 1'b0;
      branch = 1'b1;
      imm_src = 3'b010;
      result_src = 2'bxx;
      pc_plus_src = 1'b0;
    end
    `AUIPC: begin
      alu_control = 4'b0000;
      alu_r1_src = 1'b1;
      alu_r2_src = 1'b1;
      reg_write = 1'b1;
      mem_write = 1'b0;
      jump = 1'b0;
      branch = 1'b0;
      imm_src = 3'b011;
      result_src = 2'b00;
      pc_plus_src = 1'b0;
    end
    default: begin 
      alu_control = 4'bxxxx;
      alu_r1_src = 1'bx;
      alu_r2_src = 1'bx;
      reg_write = 1'bx;
      mem_write = 1'bx;
      jump = 1'bx;
      branch = 1'bx;
      imm_src = 3'bxxx;
      result_src = 2'bxx;
      pc_plus_src = 1'bx;
    end
  endcase
end
  
endmodule
