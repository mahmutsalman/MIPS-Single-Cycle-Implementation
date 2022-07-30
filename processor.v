module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk; //clock
reg holdN;
reg holdZ;
reg [7:0] datmem[0:127],mem[0:31]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
out5,       //Output of mux with bmnSignal
out6,       //Output of mux with brz funct code & z
out7,       //Output of mux with jal signal
out8,       //Output of mux with jmadd signal
out9,       //Output of mux with baln signal
sum,		//ALU result
extad,	//Output of sign-extend unit
extad2, //For contention
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,
adder3out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
sextad,	//Output of shift left 2 unit
addr_shift, // From 26-bit address get 28-bit
target_addr; // Target address for jal

wire[4:0] brzFunct;
wire [5:0] funct;

wire [5:0] inst31_26;	//31-26 bits of instruction
wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
out1;		//Write data input of Register File

wire [25:0] addr;// 26-bit address for jal instruction

wire [15:0] inst15_0;	//15-0 bits of instruction

wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)

wire [2:0] gout;	//Output of ALU control unit

wire zout,	//Zero output of ALU
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop0,bmnSignal,bmnSignalForMux,brzSignal,brzSignalForMux,jalSignalForMux,jmaddSignalForMux,balnSignal,balnSignalForMux;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

integer i,test_no;

// datamemory connections

always @(posedge clk)
//write data to memory, when towards 1
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];

 //funct code
 assign funct = {instruc[5:0]};


// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
// burası posedge idi
always @(negedge clk)
 registerfile[out1]= regwrite ? out3:registerfile[out1];//Write data to register

always @(negedge clk)
 registerfile[31]= balnSignalForMux ? pc:registerfile[31];//Write data to register if it is jal instruction

always @(negedge clk)
registerfile[31]= jmaddSignalForMux ? pc:registerfile[31];//Write data to register if it is jal instruction

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]+3],datmem[sum[5:0]+2],datmem[sum[5:0]+1],datmem[sum[5:0]]};

// Calculate direct jump address
shift addr_2(instruc,addr_shift);
concat j_addr(adder1out, addr_shift, target_addr); // PC + 4 is in adder1out

//multiplexers
//mux with RegDst control
mult2_to_1_5  mult1(out1, instruc[20:16],instruc[15:11],regdest);

//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,extad,alusrc);

//mux with MemToReg control
mult2_to_1_32 mult3(out3, sum,dpack,memtoreg);

//mux with (Branch&ALUZero) control
mult2_to_1_32 mult4(out4, adder1out,adder2out,pcsrc);

//mux with bmnSignal control
mult2_to_1_32 mult5(out5, out4,dpack,bmnSignalForMux);

//mux with brz funct code & z , if funct = 10100 & [Z]=1
mult2_to_1_32 mult6(out6,out5,sum,brzSignalForMux);

mult2_to_1_32 mult7(out7,out6,target_addr,jalSignalForMux);

mult2_to_1_32 mult8(out8,out7,dpack,jmaddSignalForMux);

mult2_to_1_32 mult9(out9,out8,target_addr,balnSignalForMux);

//Take most-significant bit of sum (ALU result) as flag
always @(negedge clk)
holdN <= sum[31];// From ALU's previous output,by looking at the left-most significant bit we can check if it is negative

always @(negedge clk)

	if(sum==32'b00000000000000000000000000000000)begin
	holdZ <=1;
	end else begin
	holdZ <=0;
end





assign bmnSignalForMux=bmnSignal && holdN; // If least-recently ALU result is negative and bmnSignal=1, then branch to address found in mem[imm+($rs)]

// For brz
assign brzSignal=instruc[4]&~(instruc[3])&instruc[2]&~(instruc[1])&~(instruc[0]);
assign brzSignalForMux =brzSignal && holdZ;// funct control et brzSignal yerine funct=20 10100

// For baln
assign balnSignal=~(instruc[31])&instruc[30]&instruc[29]&~(instruc[28])&instruc[27]&instruc[26];
assign balnSignalForMux =balnSignal && holdN;// funct control et brzSignal yerine funct=20 10100

// load pc, negedge 1->0
always @(negedge clk)
pc=out9; 

// alu, adder and control logic connections

//ALU unit,dataa $rs, out2= $rt or imm32
alu32 alu1(sum,dataa,out2,zout,gout);

//adder PC + 4
adder add1(pc,32'h4,adder1out);

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//adder which adds ($rs) and sign extented version of imm
adder add3(dataa,extad,adder3out);

//Control unit
control cont(instruc[31:26],instruc[5:0],regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,
aluop1,aluop0,bmnSignal,jalSignalForMux,jmaddSignalForMux);


//Sign extend unit
signext sext(instruc[15:0],extad);

//assign extad={{ 16 {instruc[15]}}, instruc};







//ALU control unit
alucont acont(aluop1,aluop0,instruc[5],instruc[4],instruc[3],instruc[2], instruc[1], instruc[0] ,gout);


//Shift-left 2 unit
shift shift2(sextad,extad2);

//AND gate
assign pcsrc=branch && zout; 

//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
//For bmn test_no=1
//For brz test_no=1
//For jmadd test_no=1
//For baln test_no=1
//For jal test_no=1
//For srlv test_no=1
test_no=3;
case(test_no)
1:     begin
//$readmemh("data/initDm.dat",datmem); //read Data Memory
//$readmemh("data/initIM.dat",mem);//read Instruction Memory
//$readmemh("data/initReg.dat",registerfile);//read Register File
$readmemh("data/bmnDM.dat",datmem); //read Data Memory
$readmemh("data/bmnIM.dat",mem);//read Instruction Memory
$readmemh("data/bmnReg.dat",registerfile);//read Register File
$display("MIPS: add $3, $1, $2		# $1=0xaa		$2=0x11");
$display("MIPS: sub $6, $4, $5		# $4=0x55		$5=0x22");
$display("MIPS: and $9, $7, $8		# $7=0xff		$8=0x88");
$display("MIPS: or $12, $10, $11	# $10=0xa0		$11=0x0b");
$display("MIPS: slt $15, $13, $14	# $13=0x01		$14=0x10");
$display("MIPS: srl $17, $16, 0x4	# $16=0xaa00");

end
2:      begin
	$readmemh("data/brzDM.dat",datmem);
	$readmemh("data/brzIM.dat",mem);
	$readmemh("data/brzReg.dat",registerfile);
	$display("MIPS: sub $11, $9, $10		# $1=0x0a		$2=0x1c");
	$display("MIPS: brz $3, $4, $2		# $4=0x55		$5=0x22");
	$display("MIPS: and $0, $1, $2		# $7=0xff		$8=0x88");
	$display("MIPS: add $0, $7, $8	# $10=0xa0		$11=0x0b");
	$display("MIPS: or $12, $10, $11	# $13=0x01		$14=0x10");
	
end
3:begin
    $readmemh("data/jmaddDM.dat",datmem);
	$readmemh("data/jmaddIM.dat",mem);
	$readmemh("data/jmaddReg.dat",registerfile);
end
4:begin
	  $readmemh("data/balnDM.dat",datmem);
	$readmemh("data/balnIM.dat",mem);
	$readmemh("data/balnReg.dat",registerfile);
end
5:begin
    $readmemh("data/jalDM.dat",datmem);
	$readmemh("data/jalIM.dat",mem);
	$readmemh("data/jalReg.dat",registerfile);
end
6:begin
    $readmemh("data/srlvDM.dat",datmem);
	$readmemh("data/srlvIM.dat",mem);
	$readmemh("data/srlvReg.dat",registerfile);
end
endcase

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
#400 $finish;
	
end
initial
begin
//clk=1'b1;
clk =0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],"       $31 %h",registerfile[31],
 );
end
endmodule
//"   REGISTER 4 5 6 %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[31]
