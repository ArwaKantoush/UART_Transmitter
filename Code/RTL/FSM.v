module FSM (
    input CLK,
    input RST,
    input V_INPUT,
    input P_EN,
    input SER_DONE,
    output reg SER_EN,
    output reg BUSY,
    output reg [1:0]SEL
);
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam PARITY = 3'b011;
localparam STOP = 3'b100;

reg [2:0]cs,ns;

always @(*) begin
    case (cs)
        IDLE : begin
            if (V_INPUT) begin
                ns = START;
            end
            else begin
                ns = IDLE;
            end
        end
        START : begin
            ns = DATA;
        end
        DATA : begin
            if (SER_DONE) begin
                if (P_EN) begin
                    ns = PARITY;
                end
                else begin
                    ns = STOP;
                end
            end
            else begin
                ns = DATA;
            end
        end
        PARITY : begin
            ns = STOP;
        end
        STOP : begin
            ns = IDLE;
        end
        default : begin
            ns = IDLE;
        end
    endcase
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            SER_EN = 0;
            BUSY = 0;
            SEL = 2'b11;
        end
        START : begin
            SER_EN = 0;
            BUSY = 1;
            SEL = 2'b00;
        end
        DATA : begin
            SER_EN = 1;
            BUSY = 1;
            SEL = 2'b01;
        end
        PARITY : begin
            SER_EN = 0;
            BUSY = 1;
            SEL = 2'b10;
        end
        STOP : begin
            SER_EN = 0;
            BUSY = 1;
            SEL = 2'b11;
        end
        default : begin
            SER_EN = 0;
            BUSY = 0;
            SEL = 2'b11;
        end
    endcase
end

endmodule //FSM
