module booth_element4(i,j,pp,cy);
input [3:0] i;
input [2:0] j;
output [4:0] pp;
output [1:0] cy;
reg [4:0] pp;
reg [1:0] cy;
  always @(i or j)
  begin
    case(j)
      0: {pp,cy} = {{{4{1'b0}},1'b0},2'b0};
      1: {pp,cy} = {{i[3],i},2'b0};
      2: {pp,cy} = {{i[3],i},2'b0};
      3: {pp,cy} = {{i,1'b0},2'b0};
      4: {pp,cy} = {{~i,1'b0},2'b10};
      5: {pp,cy} = {{~i[3],~i},2'b01};
      6: {pp,cy} = {{~i[3],~i},2'b01};
      7: {pp,cy} = {{{4{1'b0}},1'b0},2'b0};
    endcase
  end  
endmodule

module booth(x,y,pp1,pp2,c);
input [3:0] x,y;
output [4:0] pp1,pp2;
output [3:0] c;
booth_element4 b1 (
	          .i(x),
		  .j({y[1:0],1'b0}),
		  .pp(pp1),
		  .cy(c[1:0])
		  );
booth_element4 b2 (
		  .i(x),
		  .j(y[3:1]),
		  .pp(pp2),
		  .cy(c[3:2])
		  );
endmodule

module csa8(ip1,ip2,ip3,s,c);
input [7:0] ip1,ip2,ip3;
output [7:0] s,c;
wire [7:0] s,c;
  assign c = (ip1 & ip2) | (ip1 & ip3) | (ip2 & ip3); 
  assign s = (ip1 ^ ip2 ^ ip3);
endmodule

module cla8(ip1,ip2,p);
input [7:0] ip1,ip2;
output [7:0] p;
wire [7:0] c,s,cy;
  assign     c=ip1&ip2;
  assign     s=ip1^ip2;
  assign     cy[0]=c[0]|1'b0;
  assign     cy[7:1]=c[7:1]|(cy[6:0]&s[7:1]);
  assign     p[0]=s[0]^1'b0;
  assign     p[7:1]=s[7:1]^cy[6:0];
endmodule
  
module wallace(pp1,pp2,c,p);
input [4:0] pp1,pp2;
input [3:0] c;
output [7:0] p;
wire [7:0] t0,t1;
csa8 csa (
	 .ip1({4'b0001,c}),
	 .ip2({3'b001,~pp1[4],pp1[3:0]}),
	 .ip3({1'b1,~pp2[4],pp2[3:0],2'b0}),
	 .s(t0),
	 .c(t1)
	 );
cla8 cla (
	 .ip1(t0),
 	 .ip2({t1[6:0],1'b0}),
 	 .p(p)
	 ); 
endmodule

module bmw4x4(x,y,p);
input [3:0] x,y;
output [7:0] p;
wire [4:0] pp1,pp2;
wire [3:0] c;
booth b (
	.x(x),
	.y(y),
	.pp1(pp1),
	.pp2(pp2),
	.c(c)
	);
wallace w (
	  .pp1(pp1),
	  .pp2(pp2),
	  .c(c),
	  .p(p)
	  );
endmodule
