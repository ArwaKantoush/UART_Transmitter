module UART_TX_tb ();
parameter WIDTH = 8;
reg CLK;
reg RST;
reg [WIDTH-1:0]P_INPUT;
reg V_INPUT;
reg P_EN;
reg P_BIT;
wire TX_OUTPUT;
reg TX_OUTPUT_exp;
wire BUSY;
reg BUSY_exp;

UART_TX #(.WIDTH(WIDTH)
    ) dut ( .CLK(CLK),
            .RST(RST),
            .P_INPUT(P_INPUT),
            .V_INPUT(V_INPUT),
            .P_EN(P_EN),
            .P_BIT(P_BIT),
            .TX_OUTPUT(TX_OUTPUT),
            .BUSY(BUSY)
);

initial begin
    CLK = 1;
    forever begin
        #1 CLK = ~CLK;
    end
end

integer i;
initial begin
    RST = 0;
    P_INPUT = 8'b0000_0000; V_INPUT = 0; P_EN = 0; P_BIT = 0;
    TX_OUTPUT_exp = 1; BUSY_exp = 0;
    @(negedge CLK);
    if (TX_OUTPUT !== TX_OUTPUT_exp || BUSY !== BUSY_exp) begin
        $display("ERROR!");
        //$stop;
    end

    RST = 1;
    P_INPUT = 8'b1010_0101; V_INPUT = 1; P_EN = 0; P_BIT = 0;
    for (i = 0 ; i < 10 ; i = i + 1) begin
        if (i==0) begin
            TX_OUTPUT_exp = 0; BUSY_exp = 1;
        end
        else if (i<9) begin
            TX_OUTPUT_exp = P_INPUT[i-1]; BUSY_exp = 1;
        end
        else begin
            TX_OUTPUT_exp = 1; BUSY_exp = 1;
        end
        @(negedge CLK);
        V_INPUT = 0;
        if (TX_OUTPUT !== TX_OUTPUT_exp || BUSY !== BUSY_exp) begin
            $display("ERROR!");
            //$stop;
        end
    end

    TX_OUTPUT_exp = 1; BUSY_exp = 0;
    @(negedge CLK);
    if (TX_OUTPUT !== TX_OUTPUT_exp || BUSY !== BUSY_exp) begin
        $display("ERROR!");
        //$stop;
    end

    P_INPUT = 8'b1010_0101; V_INPUT = 1; P_EN = 1; P_BIT = 0;
    for (i = 0 ; i < 11 ; i = i + 1) begin
        if (i==0) begin
            TX_OUTPUT_exp = 0; BUSY_exp = 1;
        end
        else if (i<9) begin
            TX_OUTPUT_exp = P_INPUT[i-1]; BUSY_exp = 1;
        end
        else if (i<10) begin
            TX_OUTPUT_exp = ^P_INPUT; BUSY_exp = 1;
        end
        else begin
            TX_OUTPUT_exp = 1; BUSY_exp = 1;
        end
        @(negedge CLK);
        V_INPUT = 0;
        if (TX_OUTPUT !== TX_OUTPUT_exp || BUSY !== BUSY_exp) begin
            $display("ERROR!");
            //$stop;
        end
    end

    TX_OUTPUT_exp = 1; BUSY_exp = 0;
    @(negedge CLK);
    if (TX_OUTPUT !== TX_OUTPUT_exp || BUSY !== BUSY_exp) begin
        $display("ERROR!");
        //$stop;
    end

    P_INPUT = 8'b1010_0101; V_INPUT = 1; P_EN = 1; P_BIT = 1;
    for (i = 0 ; i < 11 ; i = i + 1) begin
        if (i==0) begin
            TX_OUTPUT_exp = 0; BUSY_exp = 1;
        end
        else if (i<9) begin
            TX_OUTPUT_exp = P_INPUT[i-1]; BUSY_exp = 1;
        end
        else if (i<10) begin
            TX_OUTPUT_exp = ~^P_INPUT; BUSY_exp = 1;
        end
        else begin
            TX_OUTPUT_exp = 1; BUSY_exp = 1;
        end
        @(negedge CLK);
        V_INPUT = 0;
        if (TX_OUTPUT !== TX_OUTPUT_exp || BUSY !== BUSY_exp) begin
            $display("ERROR!");
            //$stop;
        end
    end

    TX_OUTPUT_exp = 1; BUSY_exp = 0;
    @(negedge CLK);
    if (TX_OUTPUT !== TX_OUTPUT_exp || BUSY !== BUSY_exp) begin
        $display("ERROR!");
        //$stop;
    end
    $stop;
end

initial begin
    $monitor("CLK=%b,RST=%b,P_INPUT=%b,V_INPUT=%b,P_EN=%b,P_BIT=%b,TX_OUTPUT=%b,TX_OUTPUT_exp=%b,BUSY=%b,BUSY_exp=%b",
                CLK,RST,P_INPUT,V_INPUT,P_EN,P_BIT,TX_OUTPUT,TX_OUTPUT_exp,BUSY,BUSY_exp);
end

endmodule //UART_TX_tb
