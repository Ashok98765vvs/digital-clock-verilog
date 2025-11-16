// mod60.v — 0–59 counter
module mod60(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    input  wire load,
    input  wire [5:0] data,
    output reg  [5:0] q,
    output wire carry
);

assign carry = en && (q == 59) && !load;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 0;
    else if (load)
        q <= (data <= 59) ? data : 0;
    else if (en) begin
        if (q == 59) q <= 0;
        else         q <= q + 1;
    end
end

endmodule

