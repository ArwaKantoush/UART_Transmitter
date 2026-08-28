module MUX #(
    parameter START_BIT = 0,
    parameter STOP_BIT = 1
) (
    input SER_DATA,
    input PARITY_BIT,
    input [1:0]SEL,
    output reg TX_OUTPUT
);

always @(*) begin
    case (SEL)
        2'b00 : begin
            TX_OUTPUT = START_BIT;
        end
        2'b01 : begin
            TX_OUTPUT = SER_DATA;
        end
        2'b10 : begin
            TX_OUTPUT = PARITY_BIT;
        end
        2'b11 : begin
            TX_OUTPUT = STOP_BIT;
        end
        default : begin
            TX_OUTPUT = STOP_BIT;
        end
    endcase
end

endmodule //MUX
