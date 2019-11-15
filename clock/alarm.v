module alarm(alarm_set,alarm,hr_high_alarm_i,hr_low_alarm_i,hr_high_alarm_o,hr_low_alarm_o,sec_high_z_i,sec_low_z_i
,alarm_clk,change,turn,LED_hr,LED_min);
input alarm_set,change,turn,alarm_clk;
input[3:0] hr_high_alarm_i,hr_low_alarm_i,sec_high_z_i,sec_low_z_i;
output alarm,LED_hr,LED_min;
output[3:0] hr_high_alarm_o,hr_low_alarm_o;
reg[3:0] hr_high_alarm_o,hr_low_alarm_o;
reg alarm;
reg change_t,alarm_set_t;
reg alarm_div;

initial
begin
hr_high_alarm_o<=1;
hr_low_alarm_o<=8;
alarm_div<=0;
end



always @(posedge alarm_clk)
begin
change_t<=change;
alarm_set_t<=alarm_set;
end

always @(posedge alarm_clk)  
begin  
    if(alarm_set_t==0&&alarm_set==1);
	else if(alarm_set_t==1&&alarm_set==0);
	else if(change_t!=change)
	begin
    if(turn)  
      begin  
        if((hr_high_alarm_o==2)&&(hr_low_alarm_o==3))  
          begin  
            hr_high_alarm_o<=1;  
            hr_low_alarm_o<=8;  
          end  
        else  
          if(hr_low_alarm_o==9)  
            begin  
              hr_low_alarm_o<=0;  
              hr_high_alarm_o<=hr_high_alarm_o+1;  
            end  
          else  
            hr_low_alarm_o<=hr_low_alarm_o+1;  
      end 
      end 
    end  
	  
always @(posedge alarm_clk)  
begin
alarm_div<=!alarm_div;
if(alarm_set==0)
begin
	if(sec_high_z_i==0&&((hr_high_alarm_i<hr_high_alarm_o)||(hr_high_alarm_i==hr_high_alarm_o&&hr_low_alarm_i<hr_low_alarm_o)))
		alarm<=!alarm; 
	else if(hr_high_alarm_i<hr_high_alarm_o&&alarm_div)
		alarm<=!alarm; 
	else if(hr_high_alarm_i==hr_high_alarm_o&&hr_low_alarm_i<hr_low_alarm_o&&alarm_div)
		alarm<=!alarm;
end
end


assign LED_hr=turn&&alarm_set;
assign LED_min=!turn&&alarm_set;


endmodule

