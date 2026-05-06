module booth8(i,j,pp,cy);
input [7:0] i;
input [2:0] j;
output [8:0] pp;
output [1:0] cy;
reg [8:0] pp;
reg [1:0] cy;
  always @(i or j)
  begin
    case(j)
      0: {pp,cy} = {{{8{1'b0}},1'b0},2'b0};
      1: {pp,cy} = {{i[7],i},2'b0};
      2: {pp,cy} = {{i[7],i},2'b0};
      3: {pp,cy} = {{i,1'b0},2'b0};
      4: {pp,cy} = {{~i,1'b0},2'b10};
      5: {pp,cy} = {{~i[7],~i},2'b01};
      6: {pp,cy} = {{~i[7],~i},2'b01};
      7: {pp,cy} = {{{8{1'b0}},1'b0},2'b0};
    endcase
  end
endmodule

module booth_8x8(x,y,pp1,pp2,pp3,pp4,cy);
input [7:0] x,y;
output [8:0] pp1,pp2,pp3,pp4;
output [7:0] cy;
booth8 b1 (
	  .i(x),
	  .j({y[1:0],1'b0}),
	  .pp(pp1),
	  .cy(cy[1:0])
	  );
booth8 b2 (
	  .i(x),
	  .j(y[3:1]),
	  .pp(pp2),
	  .cy(cy[3:2])
	  );
booth8 b3 (
	  .i(x),
	  .j(y[5:3]),
	  .pp(pp3),
	  .cy(cy[5:4])
	  );
booth8 b4 (
	  .i(x),
	  .j(y[7:5]),
	  .pp(pp4),
	  .cy(cy[7:6])
	  );
endmodule

module csa12(i,j,k,s,c);
input [11:0] i,j,k;
output [11:0] s,c;
wire [11:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module csa14(i,j,k,s,c);
input [13:0] i,j,k;
output [13:0] s,c;
wire [13:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module csa16(i,j,k,s,c);
input [15:0] i,j,k;
output [15:0] s,c;
wire [15:0] s,c;
  assign c=(i&j)|(i&k)|(j&k);
  assign s=(i^j^k);
endmodule

module cla16(a,b,sum);
input [15:0] a,b;
output [15:0] sum;
wire [15:0] g,p,c,sum;
  assign g=a&b;
  assign p=a^b;
  assign c[0]=g[0];
  assign c[15:1]=g[15:1]|(c[14:0]&p[15:1]);
  assign sum[0]=p[0]^1'b0;
  assign sum[15:1]=p[15:1]^c[14:0];
endmodule

module wallace_8x8(pp1,pp2,pp3,pp4,cy,p);
input [8:0] pp1,pp2,pp3,pp4;
input [7:0] cy;
output [15:0] p;
wire [11:0] t0,t1;
wire [13:0] t2,t3;
wire [15:0] t4,t5;
csa12 w1 (
	 .i({4'b0001,cy}),
	 .j({3'b001,~pp1[8],pp1[7:0]}),
	 .k({1'b1,~pp2[8],pp2[7:0],2'b0}),
	 .s(t0),
	 .c(t1)
	 );
csa14 w2 (
	 .i({2'b0,t0}),
	 .j({1'b0,t1,1'b0}),
	 .k({1'b1,~pp3[8],pp3[7:0],4'b0}),
	 .s(t2),
	 .c(t3)
	 );
csa16 w3 (
	 .i({2'b0,t2}),
	 .j({1'b0,t3,1'b0}),
	 .k({1'b1,~pp4[8],pp4[7:0],6'b0}),
	 .s(t4),
	 .c(t5)
	 );
cla16 w4 (
	 .a(t4),
	 .b({t5[14:0],1'b0}),
	 .sum(p)
	 );
endmodule

module bmw8x8(x,y,p);
input [7:0] x,y;
output [15:0] p;
wire [8:0] pp1,pp2,pp3,pp4;
wire [7:0] cy;
booth_8x8 b	(
		.x(x),
		.y(y),
		.pp1(pp1),
		.pp2(pp2),
		.pp3(pp3),
		.pp4(pp4),
		.cy(cy)
		);
wallace_8x8 w	(
		.pp1(pp1),
		.pp2(pp2),
		.pp3(pp3),
		.pp4(pp4),
		.cy(cy),
		.p(p)
		);
endmodule

