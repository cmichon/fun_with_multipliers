module swalmul16 (c,a,b);
output [31:00] c; // product (2's complement number)
input [15:00] a; // multiplier (2's complement #)
input [15:00] b; // multiplicand (2's complement #)
wire [15:00] a; // multiplier
wire [15:00] b; // multiplicand
wire [15:00] ci; // carry in bits required when recode is negative
wire [16:00] r0; // recoded multiplicands
wire [18:02] r1;
wire [20:04] r2;
wire [22:06] r3;
wire [24:08] r4;
wire [26:10] r5;
wire [28:12] r6;
wire [30:14] r7;
wire [31:16] se;
// stage one results
wire [20:00] s1_s1;
wire [21:01] s1_c1;
wire [26:04] s1_s2;
wire [27:05] s1_c2;
wire [31:10] s1_s3;
wire [32:11] s1_c3;
// stage two results
wire [26:00] s2_s1;
wire [27:01] s2_c1;
wire [31:05] s2_s2;
wire [32:06] s2_c2;
// stage three results
wire [31:00] s3_s1;
wire [32:01] s3_c1;
// stage four results
wire [31:00] sum;
wire [32:01] carry;
// final product
wire [31:0] c;
// look at multiplier and recode multiplicand
rcd2 rc0( a[01:00],b,r0,ci[01:00]);
rcd3 rc1( a[03:01],b,r1,ci[03:02]);
rcd3 rc2( a[05:03],b,r2,ci[05:04]);
rcd3 rc3( a[07:05],b,r3,ci[07:06]);
rcd3 rc4( a[09:07],b,r4,ci[09:08]);
rcd3 rc5( a[11:09],b,r5,ci[11:10]);
rcd3 rc6( a[13:11],b,r6,ci[13:12]);
rcd3 rc7( a[15:13],b,r7,ci[15:14]);
// create sign extention for 2's complement numbers
assign se = {~r7[30], 1'b1, ~r6[28], 1'b1, ~r5[26], 1'b1, ~r4[24], 1'b1, ~r3[22], 1'b1, ~r2[20], 1'b1, ~r1[18], 1'b1, ~r0[16], 1'b0};
// three sections to create stage 1 results
defparam c1.WIDTH = 21;
carry_save_add c1(s1_c1,s1_s1,
{4'h1, // constant 1 is se carryin
se[16], ci[15:00]},
{2'h0, se[18:17], r0[16:00]},
{se[20:19], r1[18:02], 2'h0});
defparam c2.WIDTH = 23;
carry_save_add c2(s1_c2,s1_s2,{4'h0,se[22:21],r2[20:04]},
{2'h0,se[24:23],r3[22:06],2'h0},
{se[26:25],r4[24:08],4'h0});
defparam c3.WIDTH = 22;
carry_save_add c3(s1_c3,s1_s3,{3'h0,se[28:27],r5[26:10]},
{1'h0,se[30:29],r6[28:12],2'h0},
{se[31], r7[30:14], 4'h0});
// two sections to create stage 2 results
defparam c4.WIDTH = 27;
carry_save_add c4(s2_c1,s2_s1,{6'h00,s1_s1[20:00]},
{5'h00,s1_c1[21:01],1'h0},
{s1_s2[26:04],4'h0});
defparam c5.WIDTH = 27;
carry_save_add c5(s2_c2,s2_s2,{4'h0,s1_c2[27:05]},
{s1_s3[31:10],5'h00},
{s1_c3[31:11],6'h00});
// one section for stage 3 results
defparam c6.WIDTH = 32;
carry_save_add c6(s3_c1,s3_s1,{5'h00,s2_s1[26:00]},
{4'h0 ,s2_c1[27:01],1'h0 },
{s2_s2[31:05],5'h00});
// one section for stage 3 results
defparam c7.WIDTH = 32;
carry_save_add c7(carry,sum,s3_s1[31:00],
{s3_c1[31:01],1'h0 },
{s2_c2[31:06],6'h00});
// final stage should be carry lookahead adder
assign c = sum + {carry[31:01],1'b0};
endmodule

module rcd2(a,b,rec,ci);
input [2:1] a;
input [15:0] b;
output [16:0] rec;
output [1:0] ci;
// note that rcd2 is a case of rcd3 with lsb of a = 0
reg [16:0] rec;
reg [1:0] ci;
always @(a or b)
case (a)
0: begin rec = 17'h00000; ci = 0; end // 00 ==> 0 * b
1: begin rec = {b[15],b}; ci = 0; end // 01 ==> 1 * b
2: begin rec = {~b,1'b0}; ci = 2; end // 10 ==> -2 * b
3: begin rec = {~b[15],~b}; ci = 1; end // 11 ==> -1 * b
default: begin rec = 17'h00000; ci = 0; end
endcase
endmodule

module rcd3(a,b,rec,ci);
input [2:0] a;
input [15:0] b;
output [16:0] rec;
output [1:0] ci;
reg [16:0] rec;
reg [1:0] ci;
always @(a or b)
case (a)
0: begin rec = 17'h00000; ci = 0; end // 000 ==> 0 * b
1: begin rec = {b[15],b}; ci = 0; end // 001 ==> 1 * b
2: begin rec = {b[15],b}; ci = 0; end // 010 ==> 1 * b
3: begin rec = {b,1'b0}; ci = 0; end // 011 ==> 2 * b
4: begin rec = {~b,1'b0}; ci = 2; end // 100 ==> -2 * b
5: begin rec = {~b[15],~b}; ci = 1; end // 101 ==> -1 * b
6: begin rec = {~b[15],~b}; ci = 1; end // 110 ==> -1 * b
7: begin rec = 17'h00000; ci = 0; end // 111 ==> 0 * b
default: begin rec = 17'h00000; ci = 0; end
endcase
endmodule

module carry_save_add(carry, sum, a, b, c);
parameter WIDTH = 21;
output [WIDTH-1:0] carry;
output [WIDTH-1:0] sum;
input [WIDTH-1:0] a;
input [WIDTH-1:0] b;
input [WIDTH-1:0] c;
integer i;
reg [WIDTH-1:0] carry;
reg [WIDTH-1:0] sum;
reg [1:0] result;
always@(a or b or c)
begin
for(i = 0; i < WIDTH; i = i + 1)
begin
result = a[i] + b[i] + c[i];
sum[i] = result[0];
carry[i] = result[1];
end
end
endmodule
