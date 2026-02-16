module exp_01 (
    input a,
    input b,
    output t,u,v,w,x,y,z
);

assign t = a & b;
assign u = a | b;
assign v = ~a ;
assign w = ~(a | b);
assign x = ~(a & b);
assign y = a ^ b;
assign z = ~(a ^ b);

endmodule