// mod24.v — 0–23 counter
module mod24(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    input  wire load,
    input  wire [4:0] data,
    output reg  [4:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 0;
    else if (load)
        q <= (data <= 23) ? data : 0;
    else if (en) begin
        if (q == 23) q <= 0;
        else         q <= q + 1;
    end
end

endmodule
