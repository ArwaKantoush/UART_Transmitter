module UART_TX #(
    parameter WIDTH = 8
) (
    input CLK,
    input RST,
    input [WIDTH-1:0]P_INPUT,
    input V_INPUT,
    input P_EN,
    input P_BIT,
    output TX_OUTPUT,
    output BUSY
);
wire PARITY_BIT;
wire SER_EN;
wire SER_DATA;
wire SER_DONE;
wire [1:0]SEL;

Parity_Calculator #(.WIDTH(WIDTH)) dut1 (
    .CLK(CLK),
    .RST(RST),
    .P_INPUT(P_INPUT),
    .V_INPUT(V_INPUT),
    .P_EN(P_EN),
    .P_BIT(P_BIT),
    .PARITY_BIT(PARITY_BIT)
);

Serializer #(.WIDTH(WIDTH)) dut2 (
    .CLK(CLK),
    .RST(RST),
    .P_INPUT(P_INPUT),
    .V_INPUT(V_INPUT),
    .SER_EN(SER_EN),
    .SER_DATA(SER_DATA),
    .SER_DONE(SER_DONE)
);

MUX dut3 (
    .SER_DATA(SER_DATA),
    .PARITY_BIT(PARITY_BIT),
    .SEL(SEL),
    .TX_OUTPUT(TX_OUTPUT)
);

FSM dut (
    .CLK(CLK),
    .RST(RST),
    .V_INPUT(V_INPUT),
    .P_EN(P_EN),
    .SER_DONE(SER_DONE),
    .SER_EN(SER_EN),
    .BUSY(BUSY),
    .SEL(SEL)
);

endmodule //TOP
