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

module booth_16x8(x,y,pp1,pp2,pp3,pp4,cy);
input [15:0] x;
input [7:0] y;
output [16:0] pp1,pp2,pp3,pp4;
output [7:0] cy;
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

module csa24(i,j,k,s,c);
input [23:0] i,j,k;
output [23:0] s,c;
wire [23:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module cla24(a,b,sum);
input [23:0] a,b;
output [23:0] sum;
wire [23:0] g,p,c,sum;
  assign g=a&b;
  assign p=a^b;
  assign c[0]=g[0];
  assign c[23:1]=g[23:1]|(c[22:0]&p[23:1]);
  assign sum[0]=p[0]^1'b0;
  assign sum[23:1]=p[23:1]^c[22:0];
endmodule

module wallace_16x8(pp1,pp2,pp3,pp4,cy,p);
input [16:0] pp1,pp2,pp3,pp4;
input [7:0] cy;
output [23:0] p;
wire [19:0] t0,t1;
wire [21:0] t2,t3;
wire [23:0] t4,t5;
csa20 w1 (
	 .i({4'b0001,8'b00000000,cy}),
	 .j({3'b001,~pp1[16],pp1[15:0]}),
	 .k({1'b1,~pp2[16],pp2[15:0],2'b0}),
	 .s(t0),
	 .c(t1)
	 );
csa22 w2 (
	 .i({2'b0,t0}),
	 .j({1'b0,t1,1'b0}),
	 .k({1'b1,~pp3[16],pp3[15:0],4'b0}),
	 .s(t2),
	 .c(t3)
	 );
csa24 w3 (
	 .i({2'b0,t2}),
	 .j({1'b0,t3,1'b0}),
	 .k({1'b1,~pp4[16],pp4[15:0],6'b0}),
	 .s(t4),
	 .c(t5)
	 );
cla24 w4 (
	 .a(t4),
	 .b({t5[22:0],1'b0}),
	 .sum(p)
	 );
endmodule

module bmw16x8(x,y,p);
input [15:0] x;
input [7:0] y;
output [23:0] p;
wire [16:0] pp1,pp2,pp3,pp4;
wire [7:0] cy;
booth_16x8 b	(
		.x(x),
		.y(y),
		.pp1(pp1),
		.pp2(pp2),
		.pp3(pp3),
		.pp4(pp4),
		.cy(cy)
		);
wallace_16x8 w	(
		.pp1(pp1),
		.pp2(pp2),
		.pp3(pp3),
		.pp4(pp4),
		.cy(cy),
		.p(p)
		);
endmodule

