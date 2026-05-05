module cu(
    input clk,
    input arst_n,
    input start,
    input serial_ip,
    output reg[7:0] a,
    output reg[7:0] b,
    output reg[2:0] opcode,
    output alu_en
);

reg [18:0] serial_data;
reg [4:0] count;

localparam IDLE = 2'b00,
           RECIEVING = 2'b01,
           SIGNAL = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or negedge arst_n) begin
    if(!arst_n) state = IDLE;
    else state = next_state;
end

always @(*) begin
    case (state)
        IDLE: next_state = (start) ? RECIEVING : IDLE;
        RECIEVING: (count==5'd18) ? SIGNAL : RECIEVING;
        SIGNAL: next_state = IDLE;
        default: 
    endcase
end

always @(posedge clk or negedge arst_n) begin
    if(!arst_n) begin
        serial_data <= 0;
        count <= 0;
        {a, b, opcode} <= 0;
        alu_en <= 0;
    end 
    else begin
        case (state)
            IDLE: begin
                count <= 0;
                alu_en <= 0;
            end
            RECIEVING: begin
                if(start) begin
                    serial_data <= {a[17:0], serial_ip};
                    count <= count+1;
                end
            end
            SIGNAL: begin 
                a = serial_data[18:11];
                b = serial_data[10:3];
                opcode = serial_data[2:0];
                alu_en = 1'b1;
                count = 0;
            end
            default: 
        endcase
    end
end

endmodule