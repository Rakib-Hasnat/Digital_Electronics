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

    report_and_finish;
end

    // ---------------------------------------------------------------
    // Self-check: compares the DUT against a reference model and
    // prints PASS/FAIL when the simulation ends.
    // ---------------------------------------------------------------
    integer errors = 0;
    integer checks = 0;

    always @(i or sel) begin
        #1;
        checks = checks + 1;
        if ((out) !== ({7'b0, i} << sel)) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: i=%b sel=%b got %b expected %b", $time, i, sel, (out), ({7'b0, i} << sel));
        end
    end

    task report_and_finish;
        begin
            if (errors == 0) $display("PASS: %0d checks", checks);
            else             $display("FAIL: %0d of %0d checks failed", errors, checks);
            $finish;
        end
    endtask

endmodule
