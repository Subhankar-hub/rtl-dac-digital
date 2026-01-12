`timescale 1ns/1ps
// rtl/sigma_delta_dac.v
// First-order sigma-delta modulator (single-bit output) that accepts N-bit input
// and outputs a 1-bit stream at oversampled rate. Simple integrator + comparator.
// Written to be compatible with Icarus Verilog (Verilog-2001 style).

module sigma_delta_dac #(
    parameter WIDTH = 8
)(
    input  wire clk,
    input  wire rstn,
    input  wire [WIDTH-1:0] value, // target amplitude
    output reg sd_out
);

    // Use integer accumulator to avoid signed reg width issues across simulators.
    // integer is signed by default and has at least 32 bits.
    integer integrator;
    // a small vector that represents value shifted left once (value * 2)
    wire [WIDTH:0] ref;
    assign ref = {value, 1'b0}; // WIDTH+1 bits

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            integrator <= 0;
            sd_out <= 1'b0;
        end else begin
            // integrator <- integrator + ref - sd_out
            // ref and sd_out are unsigned; integrator is signed (integer)
            integrator <= integrator + $signed(ref) - $signed(sd_out);

            // comparator: output 1 when integrator non-negative
            if (integrator >= 0)
                sd_out <= 1'b1;
            else
                sd_out <= 1'b0;
        end
    end

endmodule
