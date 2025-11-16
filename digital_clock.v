// digital_clock.v
module digital_clock #(
    parameter integer TICKS_PER_SEC = 10
)(
    input  wire clk,
    input  wire rst_n,
    input  wire set_time,
    input  wire [4:0] hr_in,
    input  wire [5:0] min_in,
    input  wire [5:0] sec_in,
    input  wire set_alarm,
    input  wire [4:0] alarm_hr_in,
    input  wire [5:0] alarm_min_in,
    input  wire       alarm_en_in,
    input  wire       alarm_clear,
    output wire [4:0] hr,
    output wire [5:0] min,
    output wire [5:0] sec,
    output wire       alarm_active
);

wire tick_1hz;

tick_gen #(.TICKS_PER_SEC(TICKS_PER_SEC)) u_tg (
    .clk(clk), .rst_n(rst_n), .tick_1hz(tick_1hz)
);

wire sec_roll, min_roll;

mod60 u_sec(
    .clk(clk), .rst_n(rst_n),
    .en(tick_1hz),
    .load(set_time),
    .data(sec_in),
    .q(sec),
    .carry(sec_roll)
);

mod60 u_min(
    .clk(clk), .rst_n(rst_n),
    .en(sec_roll),
    .load(set_time),
    .data(min_in),
    .q(min),
    .carry(min_roll)
);

mod24 u_hr(
    .clk(clk), .rst_n(rst_n),
    .en(min_roll),
    .load(set_time),
    .data(hr_in),
    .q(hr)
);

reg [4:0] alarm_hr;
reg [5:0] alarm_min;
reg       alarm_en;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        alarm_hr <= 0;
        alarm_min <= 0;
        alarm_en <= 0;
    end else begin
        if (set_alarm) begin
            alarm_hr <= alarm_hr_in;
            alarm_min <= alarm_min_in;
        end
        alarm_en <= alarm_en_in;
    end
end

alarm_compare u_alarm(
    .clk(clk), .rst_n(rst_n),
    .hr(hr), .min(min), .sec(sec),
    .alarm_hr(alarm_hr),
    .alarm_min(alarm_min),
    .alarm_en(alarm_en),
    .alarm_clear(alarm_clear),
    .alarm_active(alarm_active)
);

endmodule
