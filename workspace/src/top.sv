`include "./SRAM_wrapper.sv"

module top (
    input clk,
    input rst
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

