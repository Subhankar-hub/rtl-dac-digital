`timescale 1ns/1ps
// rtl/sigma_delta_dac.v
// First-order sigma-delta modulator (single-bit output) that accepts N-bit input
// and outputs a 1-bit stream at oversampled rate. Compatible with Icarus Verilog.

module sigma_delta_dac #(
    parameter WIDTH = 8
)(
    input  wire clk,
    input  wire rstn,
    input  wire [WIDTH-1:0] value, // target amplitude
    output reg sd_out
);

    // Use integer accumulator for signed arithmetic.
    integer integrator;

    // Full-scale feedback value: 2^WIDTH
    localparam integer FULL_SCALE = 1 << WIDTH;

    initial begin
        integrator = 0;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            integrator <= 0;
            sd_out <= 1'b0;
        end else begin
            // First-order sigma-delta: integrator += input - feedback
            // Feedback is FULL_SCALE when sd_out=1, 0 when sd_out=0
            integer feedback;
            integer next_integrator;

            feedback = sd_out ? FULL_SCALE : 0;
            next_integrator = integrator + value - feedback;

            integrator <= next_integrator;

            // Comparator: output 1 when next integrator value is non-negative
            sd_out <= (next_integrator >= 0) ? 1'b1 : 1'b0;
        end
    end

endmodule
