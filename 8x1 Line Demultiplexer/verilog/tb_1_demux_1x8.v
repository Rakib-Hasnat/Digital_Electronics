`timescale 1ns/1ps

module demux_1x8_tb;

reg i;
reg [2:0] sel;
wire [7:0] out;

demux_1x8 one (
    .i(i),
    .sel(sel),
    .out(out)
);

integer k;

initial begin

    $display("sel       out");
    $display("--------------------");

    i = 1'b1;
    for (k = 0; k < 8; k = k + 1) begin
        sel = k;
        #10;
        $display(" %b    %b", sel, out);
    end

    $finish;
end

endmodule
