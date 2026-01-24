`include "SRAM_wrapper.sv"
`include "define.sv"

module top (
    clk,
    rst
);

  // define port
  input clk, rst;

  // IF
  logic [`DATA_WIDTH - 1 : 0] pc, ir;

  // IF/ID
  logic [`DATA_WIDTH -1 : 0] if_id_pc, if_id_pc_4, if_id_ir;

  SRAM_wrapper IM1 (
      .CK (),
      .CS (),
      .OE (),
      .WEB(),
      .A  (),
      .DI (),
      .DO ()
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

endmodule
