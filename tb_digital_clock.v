`timescale 1ns/1ps

module tb_digital_clock;

reg clk = 0;
always #50 clk = ~clk;

reg rst_n = 0;

reg set_time;
reg [4:0] hr_in;
reg [5:0] min_in;
reg [5:0] sec_in;

reg set_alarm;
reg [4:0] alarm_hr_in;
reg [5:0] alarm_min_in;
reg alarm_en_in;
reg alarm_clear;

wire [4:0] hr;
wire [5:0] min, sec;
wire alarm_active;

digital_clock #(.TICKS_PER_SEC(10)) dut (
    .clk(clk), .rst_n(rst_n),
    .set_time(set_time),
    .hr_in(hr_in), .min_in(min_in), .sec_in(sec_in),
    .set_alarm(set_alarm),
    .alarm_hr_in(alarm_hr_in), .alarm_min_in(alarm_min_in),
    .alarm_en_in(alarm_en_in),
    .alarm_clear(alarm_clear),
    .hr(hr), .min(min), .sec(sec),
    .alarm_active(alarm_active)
);

integer fd;

initial begin
    $dumpfile("clock.vcd");
    $dumpvars(0, tb_digital_clock);

    fd = $fopen("report.txt", "w");
    $fwrite(fd, "Digital Clock Simulation Report\n");

    rst_n = 0;
    set_time = 0;
    set_alarm = 0;
    alarm_clear = 0;
    alarm_en_in = 0;

    repeat (5) @(posedge clk);
    rst_n = 1;

    @(posedge clk);
    hr_in = 23; min_in = 59; sec_in = 55;
    set_time = 1;
    @(posedge clk) set_time = 0;

    @(posedge clk);
    alarm_hr_in = 0;
    alarm_min_in = 0;
    alarm_en_in = 1;
    set_alarm = 1;
    @(posedge clk) set_alarm = 0;

    repeat (200) @(posedge clk);

    if (alarm_active)
        $fwrite(fd, "ALARM activated at %0d:%0d:%0d\n", hr, min, sec);
    else
        $fwrite(fd, "ERROR: Alarm did not activate\n");

    alarm_clear = 1;
    @(posedge clk);
    alarm_clear = 0;

    $fclose(fd);
    $stop;
end

endmodule
