// * structrue define
`define DATA_WIDTH 32 // the width of the data
`define REG_NUM    32

// * instruction define
//
`define OPCODE   ir[6:0]
`define RS1      ir[19:15]
`define RS2      ir[24:20]
`define RD       ir[11:7]
`define FUNCT7_5 ir[30]
`define FUNCT3   ir[14:12]

`define ALU   7'b0110011
`define ALUI  7'b0010011
`define LD    7'b0000011
`define JALR  7'b1100111
`define STYPE 7'b0100011
`define BTYPE 7'b1100011
`define AUIPC 7'b0010111
`define LUI   7'b0110111
`define JAL   7'b1101111

`define IMM_SIGN ir[31]
`define I_IMM    ir[31:20]
`define S_IMM    {ir[31:25], ir[11:7]}
`define U_IMM    ir[31:12]
`define B_IMM    {ir[31], ir[7], ir[30:25], ir[11:8]}
`define J_IMM    {ir[31], ir[19:12], ir[20], ir[30:21], 1'b0}

`define BRANCH_NONE 2'b00
`define BRANCH_COM  2'b01
`define BRANCH_JAL  2'b10
`define BRANCH_JALR 2'b11
