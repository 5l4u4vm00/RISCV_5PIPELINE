`define "./define.sv"

module alu (
  input  [3:0] alu_control,
  input  [`DATA_WIDTH - 1:0] src_a,
  input  [`DATA_WIDTH - 1:0] src_b,
  output [`DATA_WIDTH - 1:0] alu_result,
);
integer i1,i2;
always @(*) begin
  case (alu_result)
    4'b0000:begin // ADD
      alu_result = src_a + src_b;
      i1 = 0;
      i2 = 0;
    end
    4'b1000:begin // SUB
      alu_result = src_a - src_b;
      i1 = 0;
      i2 = 0;
    end
    4'b0001:begin // SLL
      alu_result = {src_a[src_b[4:0]:0],{src_b[4:0]{1'b0}};
      i1 = 0;
      i2 = 0;
    end
    4'b0010:begin // SLT
      i1 = src_a;
      i2 = src_b;
      alu_result = {31'd0,i1 < i2};
    end
    4'b0011:begin // SLTU
      i1 = 0;
      i2 = 0;
      alu_result = {31'd0,src_a < src_b};
    end
    4'b0100:begin // XOR
      i1 = 0;
      i2 = 0;
      alu_result = src_a ^ src_b;
    end
    4'b0101:begin // SRL
      i1 = 0;
      i2 = 0;
      alu_result = {{src_b[4:0]{1'b0},src_a[31:src_b[4:0]]};
    end
    4'b0101:begin // SRA
      i1 = 0;
      i2 = 0;
      alu_result = {{src_b[4:0]{src_a[31]},src_a[31:src_b[4:0]]};
    end
    4'b0110:begin // OR
      i1 = 0;
      i2 = 0;
      alu_result = src_a | src_b;
    end
    4'b0111:begin // AND
      i1 = 0;
      i2 = 0;
      alu_result = src_a & src_b;
    end
    default:begin
      i1 = 0;
      i2 = 0;
      alu_result = 32'd0;
    end
  endcase
end
endmodule
