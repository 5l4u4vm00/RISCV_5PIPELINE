module top (
    input clk,
    input rst
);

  logic clk_b;

  assign clk_b = ~clk;

  // IF
  logic [`DATA_WIDTH - 1 : 0] pc, ir;

  // IF/ID
  logic [`DATA_WIDTH - 1 : 0] if_id_pc, if_id_pc_4, if_id_ir;

  // EX
  logic ex_branch_en;
  logic [`DATA_WIDTH - 1 : 0] ex_branch_address;

  SRAM_wrapper IM1 (
      .CK (clk_b),
      .CS (1'b1),
      .OE (1'b1),
      .WEB(4'b1111),
      .A  (pc[15:2]),
      .DI (32'd0),
      .DO (ir)
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
