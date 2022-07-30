module control(in,funct,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,bmnSignal,jalSignal,jmaddSignal);
input [5:0] in;
input [5:0] funct;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,bmnSignal,jalSignal,jmaddSignal;
wire rformat,lw,sw,beq,bmn,brz,jal,jmadd;
assign rformat=~|in; //000000 for R-type instructions
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];//100011 lw
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]); // beq 000100
assign bmn=~in[5]& in[4]&(~in[3])&in[2]&(~in[1])&(in[0]); // bmn 010101,opcode=21
assign jal=~in[5] &~in[4]&~in[3]&~in[2]&in[1]&in[0]; // jal 000011
assign jmadd=~funct[5]&funct[4]&funct[3]&funct[2]&funct[1]&funct[0]; // jmadd funct code=011111 31
//assign baln = ~(in[5])& in[4]&in[3]&(~in[2])&in[1]&in[0];
//assign balnSignal=baln;
assign jmaddSignal=jmadd;
assign jalSignal = jal;
assign bmnSignal=bmn;
assign regdest=rformat;
assign alusrc=lw|sw|bmn;
assign memtoreg=lw;
assign regwrite=rformat|lw;
assign memread=lw;
assign memwrite=sw;
assign branch=beq;
assign aluop1=rformat;
assign aluop2=beq;
endmodule
