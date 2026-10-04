
`timescale 1ns/1ps

module tb_decoder_4to16;

    reg  [3:0] sel;
    wire [15:0] y;
    integer i;

    decoder_4to16 uut (
        .sel(sel),
        .y(y)
    );

    initial begin
        $display("sel    y");
        $monitor("%b   %b", sel, y);

        for (i = 0; i < 16; i = i + 1) begin
            sel = i;
            #10;
        end

        report_and_finish;
    end

    // ---------------------------------------------------------------
    // Self-check: compares the DUT against a reference model and
    // prints PASS/FAIL when the simulation ends.
    // ---------------------------------------------------------------
    integer errors = 0;
    integer checks = 0;

    always @(sel) begin
        #1;
        checks = checks + 1;
        if ((y) !== (16'b1 << sel)) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: sel=%b got %b expected %b", $time, sel, (y), (16'b1 << sel));
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
