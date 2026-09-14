`timescale 1ns/1ps

module demux_1x8_tb;

reg i;
reg [2:0] sel;
wire [7:0] out;

demux_1x8 dut (
    .i(i),
    .sel(sel),
    .out(out)
);

integer k;

initial begin

    // Generate waveform
    $dumpfile("demux_1x8.vcd");
    $dumpvars(0, demux_1x8_tb);


    $display("  Random Select Tests");
    $display("-------------------------");
    $display(" i    sel       out"); 
    $display("-------------------------");
    repeat (10) begin
        sel = $random % 8;
        i = $random % 2;
        #10;
        $display(" %b    %b     %b", i, sel, out);
    end

    $finish;
end

endmodule
