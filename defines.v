//全局
`define RstEnable 1'b0
`define RstDisable 1'b1
`define ZeroWord 16'h0000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 2:0
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0


//op
`define EXE_OR  5'b11101
`define EXE_ORI 5'b11111
`define EXE_MOVE 5'b01111
`define EXE_NOP 5'b00001
`define EXE_J 5'b00010
`define EXE_LW 5'b10011
`define EXE_SW 5'b11011
`define EXE_BEQ 5'b00100
`define EXE_BNE 5'b00101
`define EXE_LI 5'b01101
`define EXE_ADDU 5'b11100
`define EXE_ADDIU 5'b01001
`define EXE_ADDIU3 5'b01000
`define EXE_IH		5'b11110
`define EXE_BGEZ  5'b00001
`define EXE_SLLSRA 5'b00110
`define EXE_BTEQZ 5'b01100
`define EXE_SWSP 5'b11010
`define EXE_LWSP 5'b10010
//op4
`define INST_OR	5'b01101
`define INST_AND	5'b01100
`define INST_MFIH	5'b00000
`define INST_MTIH	5'b00001
`define INST_CMP	5'b01010
`define INST_JR 	5'b00000
`define INST_SLTU 	5'b00011

//AluOp
`define EXE_OR_OP    8'b00100101
//`define EXE_ORI_OP  8'b01011010
`define EXE_MOVE_OP  8'b00001010
`define EXE_NOP_OP    8'b00000000
`define EXE_J_OP  8'b01001111
`define EXE_LW_OP  8'b11100011
`define EXE_SW_OP  8'b11101011
`define EXE_SWRS_OP 8'b11111011
`define EXE_BEQ_OP  8'b01010001
`define EXE_BNE_OP  8'b01010010
`define EXE_LI_OP  8'b11100000 //used to be LB

`define EXE_AND_OP	8'b00100100
`define EXE_ADDU_OP	8'b00100001
`define EXE_SUBU_OP	8'b00100011
`define EXE_ADDIU_OP 8'b00001001
`define EXE_ADDIU3_OP	8'b01001001

`define EXE_CMP_OP	8'b10101010
`define EXE_SLTU_OP	8'b10111010
`define EXE_SLL_OP 8'b01111100
`define EXE_SRA_OP 8'b00000011


//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_MOVE 3'b011
`define EXE_RES_SHIFT 3'b010

`define EXE_RES_JUMP_BRANCH 3'b110
`define EXE_RES_LOAD_STORE 3'b111

`define EXE_RES_NOP 3'b000
`define EXE_RES_ARITHMETIC	3'b100


`define InstAddrBus 15:0
`define InstBus 15:0
`define InstMemNum 1024 // todo: change to 65535
`define InstMemNumLog2 16

//数据存储器data_ram
`define DataAddrBus 15:0
`define DataBus 15:0
`define DataMemNum 65535// todo: change to 65535


//通用寄存器regfile
`define RegAddrBus 3:0
`define RegBus 15:0
`define RegWidth 16
`define DoubleRegWidth 32
`define DoubleRegBus 31:0
`define RegNum 16
`define RegNumLog2 4

//special regs
`define NOPRegAddr	4'b1000
`define SPRegAddr		4'b1001
`define TRegAddr		4'b1010
`define RARegAddr		4'b1011
`define IHRegAddr		4'b1100
 
