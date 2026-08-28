module Parity_Calculator #(
    parameter WIDTH = 8
) (
    input CLK,
    input RST,
    input [WIDTH-1:0]P_INPUT,
    input V_INPUT,
    input P_EN,
    input P_BIT,
    output reg PARITY_BIT
);

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        PARITY_BIT <= 0;
    end
    else begin
        if (V_INPUT && P_EN) begin
            if (P_BIT) begin
                PARITY_BIT <= ~^P_INPUT;
            end
            else begin
                PARITY_BIT <= ^P_INPUT;
            end
        end
    end
end

endmodule //Parity_Calculator
