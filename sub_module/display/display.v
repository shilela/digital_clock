module display(alarm_clk,mode,alarm_set,
             hr_high,hr_low,min_high,min_low,sec_high,sec_low,
             hr_high_timing,hr_low_timing,min_high_timing,min_low_timing,sec_high_timing,sec_low_timing,
             hr_high_setting,hr_low_setting,min_high_setting,min_low_setting,
             hr_high_alarm,hr_low_alarm);

input alarm_clk,mode,alarm_set;
output[3:0] hr_high,hr_low,min_high,min_low,sec_high,sec_low;
reg[3:0] hr_high,hr_low,min_high,min_low,sec_high,sec_low;
input[3:0] hr_high_timing,hr_low_timing,min_high_timing,min_low_timing,sec_high_timing,sec_low_timing,
           hr_high_setting,hr_low_setting,min_high_setting,min_low_setting,
           hr_high_alarm,hr_low_alarm;
           
initial
begin
hr_high<=0;
hr_low<=0;
min_high<=0;
min_low<=0;
sec_high<=0;
sec_low<=0;
end

always @(posedge alarm_clk)
begin
hr_high<=alarm_set?(hr_high_alarm):(mode?hr_high_timing:hr_high_setting);
min_high<=alarm_set?0:(mode?min_high_timing:min_high_setting);
sec_high<=alarm_set?0:sec_high_timing;
hr_low<=alarm_set?(hr_low_alarm):(mode?hr_low_timing:hr_low_setting);
min_low<=alarm_set?0:(mode?min_low_timing:min_low_setting);
sec_low<=alarm_set?0:sec_low_timing;
end

endmodule
