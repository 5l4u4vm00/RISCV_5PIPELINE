`include "./rtl/define.sv"
`include "./rtl/ins_decoder.sv"

module top (
    input clk,
    input rst
);

  logic  clk_b;


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

