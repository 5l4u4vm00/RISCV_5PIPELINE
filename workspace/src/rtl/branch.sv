`define "./define.sv"
module branch (
  input [3:0]              alu_control,
  input [`DATA_WIDTH -1:0] src_a,
  input [`DATA_WIDTH -1:0] src_b.
  output zero
);
integer i1,i2;
always @(*) begin
  case (alu_control)
    4'b0000:begin
      i1 = 0;
      i2 = 0;
      zero = src_a == src_b;
    end
    4'b0001:begin
      zero = src_a != src_b;
    end
    4'b0100:begin
      i1 = src_a;
      i2 = src_b;
      zero = i1 <  i2;
    end
    4'b0101:begin
      i1 = src_a;
      i2 = src_b;
      zero = i1 >= i2;
    end
    4'b0110:begin
      i1 = 0;
      i2 = 0;
      zero = src_a <  src_b;
    end
    4'b0111:begin
      i1 = 0;
      i2 = 0;
      zero = src_a >= src_b;
    end
    default: begin
      i1 = 0;
      i2 = 0;
      zero = 1'b0;
    end
  endcase
end
endmodule
