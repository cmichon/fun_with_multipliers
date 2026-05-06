module booth_element12(i,j,pp,cy);
input [11:0] i;
input [2:0] j;
output [12:0] pp;
output [1:0] cy;
reg [12:0] pp;
reg [1:0] cy;
  always @(i or j)
  begin
    case(j)
      0: {pp,cy} = {{{12{1'b0}},1'b0},2'b0};
      1: {pp,cy} = {{i[11],i},2'b0};
      2: {pp,cy} = {{i[11],i},2'b0};
      3: {pp,cy} = {{i,1'b0},2'b0};
      4: {pp,cy} = {{~i,1'b0},2'b10};
      5: {pp,cy} = {{~i[11],~i},2'b01};
      6: {pp,cy} = {{~i[11],~i},2'b01};
      7: {pp,cy} = {{{12{1'b0}},1'b0},2'b0};
    endcase
  end  
endmodule

module booth(x,y,pp1,pp2,pp3,pp4,pp5,pp6,c);
input [11:0] x,y;
output [12:0] pp1,pp2,pp3,pp4,pp5,pp6;
output [11:0] c;
booth_element12 b1 (
		   .i(x),
		   .j({y[1:0],1'b0}),
		   .pp(pp1),
		   .cy(c[1:0])
		   );
booth_element12 b2 (
		   .i(x),
		   .j(y[3:1]),
		   .pp(pp2),
		   .cy(c[3:2])
		   );
booth_element12 b3 (
		   .i(x),
		   .j(y[5:3]),
		   .pp(pp3),
		   .cy(c[5:4])
		   );
booth_element12 b4 (
		   .i(x),
		   .j(y[7:5]),
		   .pp(pp4),
		   .cy(c[7:6])
		   );
booth_element12 b5 (
		   .i(x),
		   .j(y[9:7]),
		   .pp(pp5),
		   .cy(c[9:8])
		   );
booth_element12 b6 (
		   .i(x),
		   .j(y[11:9]),
		   .pp(pp6),
		   .cy(c[11:10])
		   );
endmodule

module csa16(ip1,ip2,ip3,s,c);
input [15:0] ip1,ip2,ip3;
output [15:0] s,c;
wire [15:0] s,c;
  assign c = (ip1 & ip2) | (ip1 & ip3) | (ip2 & ip3); 
  assign s = (ip1 ^ ip2 ^ ip3);
endmodule

module csa18(ip1,ip2,ip3,s,c);
input [17:0] ip1,ip2,ip3;
output [17:0] s,c;
wire [17:0] s,c;
  assign c = (ip1 & ip2) | (ip1 & ip3) | (ip2 & ip3); 
  assign s = (ip1 ^ ip2 ^ ip3);
endmodule

module csa22(ip1,ip2,ip3,s,c);
input [21:0] ip1,ip2,ip3;
output [21:0] s,c;
wire [21:0] s,c;
  assign c = (ip1 & ip2) | (ip1 & ip3) | (ip2 & ip3); 
  assign s = (ip1 ^ ip2 ^ ip3);
endmodule

module csa23(ip1,ip2,ip3,s,c);
input [22:0] ip1,ip2,ip3;
output [22:0] s,c;
wire [22:0] s,c;
  assign c = (ip1 & ip2) | (ip1 & ip3) | (ip2 & ip3); 
  assign s = (ip1 ^ ip2 ^ ip3);
endmodule

module csa24(ip1,ip2,ip3,s,c);
input [23:0] ip1,ip2,ip3;
output [23:0] s,c;
wire [23:0] s,c;
  assign c = (ip1 & ip2) | (ip1 & ip3) | (ip2 & ip3); 
  assign s = (ip1 ^ ip2 ^ ip3);
endmodule

module cla24(ip1,ip2,p);
input [23:0] ip1,ip2;
output [23:0] p;
wire [23:0] c,s,cy;
  assign c = ip1 & ip2;
  assign s = ip1 ^ ip2;
  assign cy[0] = c[0] | 1'b0;
  assign cy[23:1] = c[23:1] | (cy[22:0] & s[23:1]);
  assign p[0] = s[0] ^ 1'b0;
  assign p[23:1] = s[23:1] ^ cy[22:0];
endmodule
  
module wallace(pp1,pp2,pp3,pp4,pp5,pp6,c,p);
input [12:0] pp1,pp2,pp3,pp4,pp5,pp6;
input [11:0] c;
output [23:0] p;
wire [15:0] t0,t1;
wire [17:0] t2,t3;
wire [21:0] t4,t5;
wire [22:0] t6,t7;
wire [23:0] t8,t9;
csa16 w1 (
	 .ip1({4'b0001,c}),
	 .ip2({3'b001,~pp1[12],pp1[11:0]}),
	 .ip3({1'b1,~pp2[12],pp2[11:0],2'b0}),
	 .s(t0),
	 .c(t1)
	 );
csa18 w2 (
	 .ip1({5'b00001,~pp3[12],pp3[11:0]}),
	 .ip2({3'b001,~pp4[12],pp4[11:0],2'b0}),
	 .ip3({1'b1,~pp5[12],pp5[11:0],4'b0}),
	 .s(t2),
	 .c(t3)
	 );
csa22 w3 (
	 .ip1({6'b0,t0}),
	 .ip2({5'b0,t1,1'b0}),
	 .ip3({t2,4'b0}),
	 .s(t4),
	 .c(t5)
	 );
csa23 w4 (
	 .ip1({1'b0,t4}),
	 .ip2({t5,1'b0}),
	 .ip3({t3,5'b0}),
	 .s(t6),
	 .c(t7)
	 );
csa24 w5 (
	 .ip1({1'b0,t6}),
	 .ip2({t7,1'b0}),
	 .ip3({1'b1,~pp6[12],pp6[11:0],10'b0}),
	 .s(t8),
	 .c(t9)
	 );
cla24 cla(
	 .ip1(t8[23:0]),
 	 .ip2({t9[22:0],1'b0}),
 	 .p(p)
	 );
endmodule

module bmw12x12(x,y,p);
input [11:0] x,y;
reg [11:0] x_lat,y_lat;
output [23:0] p;
wire [12:0] pp1,pp2,pp3,pp4,pp5,pp6;
reg [12:0] pp1_lat,pp2_lat,pp3_lat,pp4_lat,pp5_lat,pp6_lat;
wire [11:0] c;

booth b (
	.x(x),
	.y(y),
	.pp1(pp1),
	.pp2(pp2),
	.pp3(pp3),
	.pp4(pp4),
	.pp5(pp5),
	.pp6(pp6),
	.c(c)
	);
wallace w (
	  .pp1(pp1),
	  .pp2(pp2),
	  .pp3(pp3),
	  .pp4(pp4),
	  .pp5(pp5),
	  .pp6(pp6),
	  .c(c),
	  .p(p)
	  );
endmodule

