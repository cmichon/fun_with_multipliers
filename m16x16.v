module booth16(i,j,pp,cy);
input [15:0] i;
input [2:0] j;
output [16:0] pp;
output [1:0] cy;
reg [16:0] pp;
reg [1:0] cy;
  always @(i or j)
  begin
    case(j)
      0: {pp,cy} = {{{16{1'b0}},1'b0},2'b0};
      1: {pp,cy} = {{i[15],i},2'b0};
      2: {pp,cy} = {{i[15],i},2'b0};
      3: {pp,cy} = {{i,1'b0},2'b0};
      4: {pp,cy} = {{~i,1'b0},2'b10};
      5: {pp,cy} = {{~i[15],~i},2'b01};
      6: {pp,cy} = {{~i[15],~i},2'b01};
      7: {pp,cy} = {{{16{1'b0}},1'b0},2'b0};
    endcase
  end
endmodule

module booth_16x16(x,y,pp1,pp2,pp3,pp4,pp5,pp6,pp7,pp8,cy);
input [15:0] x,y;
output [16:0] pp1,pp2,pp3,pp4,pp5,pp6,pp7,pp8;
output [15:0] cy;
booth16 b1 (
	   .i(x),
	   .j({y[1:0],1'b0}),
	   .pp(pp1),
	   .cy(cy[1:0])
	   );
booth16 b2 (
	   .i(x),
	   .j(y[3:1]),
	   .pp(pp2),
	   .cy(cy[3:2])
	   );
booth16 b3 (
	   .i(x),
	   .j(y[5:3]),
	   .pp(pp3),
	   .cy(cy[5:4])
	   );
booth16 b4 (
	   .i(x),
	   .j(y[7:5]),
	   .pp(pp4),
	   .cy(cy[7:6])
	   );
booth16 b5 (
	   .i(x),
	   .j(y[9:7]),
	   .pp(pp5),
	   .cy(cy[9:8])
	   );
booth16 b6 (
	   .i(x),
	   .j(y[11:9]),
	   .pp(pp6),
	   .cy(cy[11:10])
	   );
booth16 b7 (
	   .i(x),
	   .j(y[13:11]),
	   .pp(pp7),
	   .cy(cy[13:12])
	   );
booth16 b8 (
	   .i(x),
	   .j(y[15:13]),
	   .pp(pp8),
	   .cy(cy[15:14])
	   );
endmodule

module csa20(i,j,k,s,c);
input [19:0] i,j,k;
output [19:0] s,c;
wire [19:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module csa22(i,j,k,s,c);
input [21:0] i,j,k;
output [21:0] s,c;
wire [21:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module csa26(i,j,k,s,c);
input [25:0] i,j,k;
output [25:0] s,c;
wire [25:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module csa28(i,j,k,s,c);
input [27:0] i,j,k;
output [27:0] s,c;
wire [27:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module csa33(i,j,k,s,c);
input [32:0] i,j,k;
output [32:0] s,c;
wire [32:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module csa35(i,j,k,s,c);
input [34:0] i,j,k;
output [34:0] s,c;
wire [34:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module cla32(a,b,sum);
input [31:0] a,b;
output [31:0] sum;
wire [31:0] g,p,c,sum;
  assign g=a&b;
  assign p=a^b;
  assign c[0]=g[0];
  assign c[31:1]=g[31:1]|(c[30:0]&p[31:1]);
  assign sum[0]=p[0]^1'b0;
  assign sum[31:1]=p[31:1]^c[30:0];
endmodule

module wallace_16x16(pp1,pp2,pp3,pp4,pp5,pp6,pp7,pp8,cy,p);
input [16:0] pp1,pp2,pp3,pp4,pp5,pp6,pp7,pp8;
input [15:0] cy;
output [31:0] p;
wire [19:0] t0,t1;
wire [21:0] t2,t3;
wire [21:0] t4,t5;
wire [25:0] t6,t7;
wire [27:0] t8,t9;
wire [32:0] t10,t11;
wire [34:0] t12,t13;
csa20 w1 (
	 .i({4'b0001,cy}),
	 .j({3'b001,~pp1[16],pp1[15:0]}),
	 .k({1'b1,~pp2[16],pp2[15:0],2'b0}),
	 .s(t0),
	 .c(t1)
	 );
csa22 w2 (
	 .i({5'b0001,~pp3[16],pp3[15:0]}),
	 .j({3'b001,~pp4[16],pp4[15:0],2'b0}),
	 .k({1'b1,~pp5[16],pp5[15:0],4'b0}),
	 .s(t2),
	 .c(t3)
	 );
csa22 w3 (
	 .i({5'b0001,~pp6[16],pp6[15:0]}),
	 .j({3'b001,~pp7[16],pp7[15:0],2'b0}),
	 .k({1'b1,~pp8[16],pp8[15:0],4'b0}),
	 .s(t4),
	 .c(t5)
	 );
csa26 w4 (
	 .i({6'b0,t0}),
	 .j({5'b0,t1,1'b0}),
	 .k({t2,4'b0}),
	 .s(t6),
	 .c(t7)
	 );
csa28 w5 (
	 .i({6'b0,t3}),
	 .j({1'b0,t4,5'b0}),
	 .k({t5,6'b0}),
	 .s(t8),
	 .c(t9)
	 );
csa33 w6 (
	 .i({7'b0,t7}),
	 .j({1'b0,t8,4'b0}),
	 .k({t9,5'b0}),
	 .s(t10),
	 .c(t11)
	 );
csa35 w7 (
	 .i({9'b0,t6}),
	 .j({1'b0,t10,1'b0}),
	 .k({t11,2'b0}),
	 .s(t12),
	 .c(t13)
	 );
cla32 w8 (
	 .a(t12[31:0]),
	 .b({t13[30:0],1'b0}),
	 .sum(p)
	 );
endmodule

module bmw16x16(x,y,p);
input [15:0] x,y;
output [31:0] p;
wire [16:0] pp1,pp2,pp3,pp4,pp5,pp6,pp7,pp8;
wire [15:0] cy;
booth_16x16 b	(
		.x(x),
		.y(y),
		.pp1(pp1),
		.pp2(pp2),
		.pp3(pp3),
		.pp4(pp4),
		.pp5(pp5),
		.pp6(pp6),
		.pp7(pp7),
		.pp8(pp8),
		.cy(cy)
		);
wallace_16x16 w	(
		.pp1(pp1),
		.pp2(pp2),
		.pp3(pp3),
		.pp4(pp4),
		.pp5(pp5),
		.pp6(pp6),
		.pp7(pp7),
		.pp8(pp8),
		.cy(cy),
		.p(p)
		);
endmodule

