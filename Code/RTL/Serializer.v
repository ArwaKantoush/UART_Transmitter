module Serializer #(
    parameter WIDTH = 8
) (
    input CLK,
    input RST,
    input [WIDTH-1:0]P_INPUT,
    input V_INPUT,
    input SER_EN,
    output SER_DATA,
    output reg SER_DONE
);
reg [WIDTH-1:0]register;
reg [$clog2(WIDTH)-1:0]counter;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        SER_DONE <= 0;
        register <= 0;
        counter <= 0;
    end
    else if (V_INPUT && !SER_EN) begin
            register <= P_INPUT;
            SER_DONE <= 0;
            counter <= 0;
        end
    else if (SER_EN) begin
        if (counter < WIDTH-2) begin
            register <= {1'b0,register[WIDTH-1:1]};
            SER_DONE <= 0;
            counter <= counter + 1;
        end
        else begin
            register <= {1'b0,register[WIDTH-1:1]};
            SER_DONE <= 1;
            counter <= 0;
        end
    end
    else begin
        SER_DONE <= 0;
    end
end

assign SER_DATA = (!RST)? 0 : register[0];

endmodule //Serializer
