`timescale 1ns/1ps



// Testbench that measures PWM duty cycle for each input value and writes CSV
module tb_pwm_measure;
    parameter WIDTH = 6;
    reg clk = 0;
    reg rstn = 0;
    reg [WIDTH-1:0] value = 0;
    wire pwm_out;

    pwm_dac #(.WIDTH(WIDTH)) dut(.clk(clk), .rstn(rstn), .value(value), .pwm_out(pwm_out));

    // clock
    always #5 clk = ~clk; // 100 MHz (10 ns period)

    integer csv;
    initial begin
        csv = $fopen("build/pwm_measurements.csv","w");
        $fwrite(csv, "value,measured_fraction");

        // reset
        rstn = 0; #20; rstn = 1;

        // For each value, measure over many cycles (e.g., 1024 PWM full cycles)
        integer v;
        integer cycles = 1024 * (1<<WIDTH); // ensure many PWM periods
        for (v = 0; v < (1<<WIDTH); v = v + 1) begin
            value = v;
            // count ones on pwm_out over 'cycles' clock samples
            integer i;
            integer ones = 0;
            for (i = 0; i < cycles; i = i + 1) begin
                @(posedge clk);
                if (pwm_out) ones = ones + 1;
            end
            // measured fraction in fixed-point (double printed)
            real frac = ones * 1.0 / cycles;
            $fwrite(csv, "%0d,%f", v, frac);
            $display("value=%0d measured_frac=%f", v, frac);
        end

        $fclose(csv);
        $finish;
    end
endmodule