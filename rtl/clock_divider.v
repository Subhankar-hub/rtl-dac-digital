// Divide Iinput clock by an integer power-of two factor (parameterizable)
module clock_divider #(
    parameter DIV = 4, // divide by 2^DIV
    parameter W = 32
)(
    input wire clk,
    input wire rstn,
    output reg clk_out
);
    reg [W-1:0] cnt;
    localparam TRESH = (1 << DIV) - 1;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt <= 0;
            clk_out <= 0;
        end else begin
            cnt <= cnt + 1'b1;
            if ( cnt == TRESH) begin
                cnt <= 0;
                clk_out <= ~clk_out;
            end
        end
    end
endmodule
