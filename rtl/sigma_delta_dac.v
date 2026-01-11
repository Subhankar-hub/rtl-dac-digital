// First-order sigma-delta modulator (single-bit output) that accepts N-bit input
// add outputs a 1-bit stream at oversampled rate, simple integrator + comparator.

module sigma_delta_dac #(
    parameter WIDTH = 8

)(
    input wire clk,
    input wire rstn,
    input [WIDTH-1:0] value, // target amplitude
    output reg sd_out
);
    // accumulator width: WIDTH  + 1 to avoid overflow
    reg signed [WIDTH:0] integrator;
    wire signed [WIDTH:0] ref;

    // reference: left-justified input in same signed domain 
    assign ref = {value, 1'b0}; // *2

    always @(posedge clk or negedge rstn) begin
      if (!rstn) begin
        integrator <= 0;
        sd_out <= 1'b0;
      end else begin
        // subtract previous output (as signed and add reference)
        // convert sd_out(0/1) to signed value (-1 or +1) scaled: here use 0/1 mapping
        if (sd_out)
        integrator <= integrator + ref -{{1{1'b0}}, 1'b1};
        else
        integrator <= integrator - ref +{{1{1'b0}}, 1'b1};

        // comparator
        if ( integrator >= 0)
        sd_out <= 1'b1;
        else
        sd_out <= 1'b0;
      end
    end

endmodule