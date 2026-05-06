`timescale 1ns / 1ns

module tb12x12;
parameter m=12,n=12;
integer x,y;
wire [m+n-1:0] p;
reg [m+n-1:0] theory;

bmw12x12 multi	(
		.x(x[m-1:0]),
		.y(y[n-1:0]),
		.p(p)
		);

initial
begin 
//$dumpfile("df");
//$dumpvars(0,tb);
 for(x=0;x<2**m;x=x+1)
  begin
    for(y=0;y<2**n;y=y+1)
    begin
      #1;
      theory={{n{x[m-1]}},x[m-1:0]}*{{m{y[n-1]}},y[n-1:0]};
      if(p!==theory)
      $display("x=%b  y=%b  p=%b  theory=%b",x[m-1:0],y[n-1:0],p[m+n-1:0],theory[m+n-1:0]);
    end
  end
  $display("%t: SIMULATION FINISHED !!!",$time);
end
endmodule
