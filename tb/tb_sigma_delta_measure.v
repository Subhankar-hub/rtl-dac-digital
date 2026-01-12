`timescale 1ps/

// Measure mean value of sigma-delta output stream for each input

module tb_signma_delta_measure;
    parameter WIDTH = 8;
    reg clk= 0;
    reg rstn = 0;
    reg[WIDTH-1:0] value = 0;
    wire sd_out;

    sigman_delta_dac #(.WIDTH(WIDTH)) dut(.clk(clk), .rstn(rstn), .value(value), .sd_out(sd_out));

    //clock
    always #1 clk = ~clk; // high rate clock for oversampling

    integer csv;
    initial begin
        csv = $fopen("build/sd_measurements.csv","w");
        $fwrite(csv, "value,measured_fraction");

        //reset 

        rstn = 0; #10; rstn = 1;

        integer v;
        integer samples = 100000; // many samples to estimate mean
        for (v = 0; v < (1<<WIDTH); v = v + 16) begin
            value = v;
            integer i; integer ones = 0;
            for(i = 0; i < samples; i = i + 1) begin
                @(posedge clk);
                if(sd_out) ones = ones + 1;
            end
            rea; frac = ones * 1.0 / samples;
            $fwrite(csv, "%0d,%f", v, frac);
            $display("value=%0d measured_frac=%f", v, frac);
        end

        $fclose(csv);
        $finish;
        end
endmodule