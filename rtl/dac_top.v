// Top wrapper that instantiates PWM or Sigma-Delta DAC and optional clock divider
module dac_top #(
    parameter WIDTH = 6,
    parameter USE_SIGMA_DELTA = 0  // if 1 use sigma-delta, else use PWM
)(
    input wire clk,
    input wire rstn,
    input wire [WIDTH-1:0] value,
    output wire dac_out
);

    generate
        if (USE_SIGMA_DELTA) begin : gen_sd
        // instantiate sigma delta with wider internal width
        sigma_delta_dac #(.WIDTH(WIDTH)) u_sd(.clk(clk), .rstn(rstn), .value(value), .sd_out(dac_out));
        end else begin : gen_pwm
        pwm_dac #(.WIDTH(WIDTH)) u_pwm(.clk(clk), .rstn(rstn), .value(value), .pwm_out(dac_out));
        end
    endgenerate
endmodule