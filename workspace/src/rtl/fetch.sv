`include "./define.sv"
`include "../SRAM_wrapper.sv"

module fetch (
  input                      clk,
  input                      rst,
  input                      pc_src_e,
  input  [`DATA_WIDTH - 1:0] pc_target_e,
  output [`DATA_WIDTH - 1:0] pc_d,
  output [`DATA_WIDTH - 1:0] pc_pluse_4_d,
  output [`DATA_WIDTH - 1:0] instr_d,
);
  logic  clk_b;
  assign clk_b = ~clk;

  logic [`DATA_WIDTH - 1:0] pc_f;
  logic [`DATA_WIDTH - 1:0] instr_f;

  SRAM_wrapper IM1 (
      .CK (clk_b),
      .CS (1'b1),
      .OE (1'b1),
      .WEB(4'd1),
      .A  (pc_f[15:2]),
      .DI (32'd0),
      .DO (instr_f)
  );

  always @(posedge clk) begin
    if (rst) begin
      pc_f <= 32'd0;
      instr_f <= 32'd0;
      pc_d <= 32'd0;
      pc_pluse_4_d <= 32'd0;
      instr_d <= 32'd0;
    end
    else begin
      if (pc_src_e) begin
        pc_f <= pc_target_e; 
      end
      else begin
        pc_f <= pc_f + 4;
      end

      pc_d <= pc_f;
      pc_pluse_4_d <= pc_f + 4;
      instr_d <= insftr_f;
    end
  end
endmodule
