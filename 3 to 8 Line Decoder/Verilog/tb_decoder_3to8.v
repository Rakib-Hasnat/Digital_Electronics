`timescale 1ns/1ps

module tb_decoder_3to8;

    reg  [2:0] sel;
    wire [7:0] y;
    integer i;

    decoder_3to8 uut (
        .sel(sel),
        .y(y)
    );

    initial begin
        $display("sel    y");
 	$monitor("%b %b", sel, y);
        for (i = 0; i < 8; i = i + 1) begin
            sel = i;
            #10;
        end

        $finish;
    end

endmodule
