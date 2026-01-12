`timescale 1ns/1ps
// Measure mean value of sigma-delta output stream for each input
module tb_sigma_delta_measure;
    parameter WIDTH = 8;
    reg clk = 0;
    reg rstn = 0;
    reg [WIDTH-1:0] value = 0;
    wire sd_out;

    // measurement variables
    integer csv;
    integer v;
    integer samples;
    integer i;
    integer ones;
    real frac;

    sigma_delta_dac #(.WIDTH(WIDTH)) dut(.clk(clk), .rstn(rstn), .value(value), .sd_out(sd_out));

    always #1 clk = ~clk; // high-rate clock for oversampling

    initial begin
        samples = 100000; // many samples to estimate mean
        csv = $fopen("build/sd_measurements.csv","w");
        $fwrite(csv, "value,measured_fraction\n");
        rstn = 0; #10; rstn = 1;

        for (v = 0; v < (1<<WIDTH); v = v + 16) begin
            value = v;
            ones = 0;
            for (i = 0; i < samples; i = i + 1) begin
                @(posedge clk);
                if (sd_out) ones = ones + 1;
            end
            frac = ones * 1.0 / samples;
            $fwrite(csv, "%0d,%f\n", v, frac);
            $display("sd value=%0d measured_frac=%f", v, frac);
        end

        $fclose(csv);
        $finish;
    end
endmodule
