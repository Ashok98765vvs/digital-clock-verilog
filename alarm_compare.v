// alarm_compare.v
module alarm_compare(
    input  wire clk,
    input  wire rst_n,
    input  wire [4:0] hr,
    input  wire [5:0] min,
    input  wire [5:0] sec,
    input  wire [4:0] alarm_hr,
    input  wire [5:0] alarm_min,
    input  wire       alarm_en,
    input  wire       alarm_clear,
    output reg        alarm_active
);

wire match = alarm_en &&
             (hr  == alarm_hr) &&
             (min == alarm_min) &&
             (sec == 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        alarm_active <= 0;
    else if (alarm_clear)
        alarm_active <= 0;
    else if (match)
        alarm_active <= 1;
end

endmodule
