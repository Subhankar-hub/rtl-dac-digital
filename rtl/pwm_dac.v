// Parameterizable WIDTH PWM DAC module. Counter wraps at (1<<WIDTH)-1

module pwm_dac #(
    parameter WIDTH = 6 
    )(
        input wire clk,
        input wire rstn,
        input wire [WIDTH-1:0] value, // parallel input value
        output reg pwm_out
    );
        reg [WIDTH-1:0] counter;

        always @(posedge clk or negedge rstn) begin
            if (!rstn)begin
                counter <= 0;
                pwm_out <= 0;
            end else begin
                counter <= counter + 1'b1;
                pwm_out <= (counter < value) ? 1'b1 : 1'b0;            
        end
        end
endmodule