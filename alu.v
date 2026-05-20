module alu (
    input [7:0] a,
    input [7:0] b,
    input [2:0] sel,
    output [7:0] out,
    output [7:0] out_flag
);

reg [7:0] temp_out, flag;


always @(*) begin
    case (sel)
        3'b000: begin
            {flag[4], temp_out[3:0]} = a[3:0]+b[3:0];
            {flag[0],temp_out[7:4]} = a[7:4] + b[7:4] + flag[4];
        end
        3'b001: begin
            {flag[4], temp_out} = a[3:0] + (~b[3:0]+1'b1);
            {flag[0], temp_out} = a[7:4] + (~b[7:4]+flag[4]);
        end
        3'b010: begin
            temp_out = a&b;
        end
        3'b011: begin
            temp_out = a|b;
        end
        3'b100: begin
            temp_out = a^b;
        end
        3'b101: begin
            temp_out = ~a;
        end
        3'b110: begin
            temp_out = a >> 1;
        end
        3'b111: begin
            temp_out = a << 1;
        end
        default: temp_out = 0;
    endcase
end
always @(*) begin
    flag[2] = ~^temp_out;
    flag[6] = ~|temp_out;
    flag[7] = (sel==3'b001)&&(temp_out[7]==1'b1);
end

assign out = temp_out;
assign out_flag = flag;

endmodule