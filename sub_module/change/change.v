module change(mode,clk,alarm_clk,choose,change,turn,LED_hr,LED_min,hr_high_setting_i,hr_low_setting_i,min_high_setting_i,min_low_setting_i,hr_high_setting_o,hr_low_setting_o,min_high_setting_o,min_low_setting_o);
input mode,change,turn,clk,alarm_clk,choose;
output LED_hr,LED_min,hr_high_setting_o,hr_low_setting_o,min_high_setting_o,min_low_setting_o;
input[3:0] hr_high_setting_i,hr_low_setting_i,min_high_setting_i,min_low_setting_i;
reg[3:0] hr_high_setting_o,hr_low_setting_o,min_high_setting_o,min_low_setting_o;
reg mode_t,change_t,clk_t;

always @(posedge alarm_clk)
begin
mode_t<=mode;
change_t<=change;
clk_t<=clk;
end

always @(posedge alarm_clk)  
begin  
    if(mode_t==1&&mode==0)
    begin
		hr_high_setting_o<=hr_high_setting_i;  
		hr_low_setting_o<=hr_low_setting_i; 
	end
	else if(mode_t==0&&mode==1);
	else if(choose)
	begin
	if(change_t!=change)
	begin
    if(turn)  
      begin  
        if((hr_high_setting_o==2)&&(hr_low_setting_o==3))  
          begin  
            hr_high_setting_o<=0;  
            hr_low_setting_o<=0;  
          end  
        else  
          if(hr_low_setting_o==9)  
            begin  
              hr_low_setting_o<=0;  
              hr_high_setting_o<=hr_high_setting_o+1;  
            end  
          else  
            hr_low_setting_o<=hr_low_setting_o+1;  
      end 
      end 
    end  
    else if(!choose)
    begin
	if(clk_t!=clk)
	begin
    if(turn)  
      begin  
        if((hr_low_setting_o==3)&&(hr_high_setting_o==2))  
          begin  
            hr_high_setting_o<=0;  
            hr_low_setting_o<=0;  
          end  
        else  
          if(hr_low_setting_o==9)  
            begin  
              hr_low_setting_o<=0;  
              hr_high_setting_o<=hr_high_setting_o+1;  
            end  
          else  
            hr_low_setting_o<=hr_low_setting_o+1;  
      end 
      end 
    end  
    
    
    
   end   
always @(posedge alarm_clk)  
    begin  
     if(mode_t==1&&mode==0)
     begin
		min_low_setting_o<=min_low_setting_i;  
        min_high_setting_o<=min_high_setting_i;
      end
      else if(mode_t==0&&mode==1);
      else if(choose)
      begin
      if(change_t!=change)
      begin
		if(!turn)  
        begin  
          if((min_low_setting_o==9)&&(min_high_setting_o==5))  
            begin  
              min_low_setting_o<=0;  
              min_high_setting_o<=0;  
            end  
          else   
            if(min_low_setting_o==9)  
              begin  
                min_low_setting_o<=0;  
                min_high_setting_o<=min_high_setting_o+1;  
              end  
            else  
              min_low_setting_o<=min_low_setting_o+1;  
        end  
        end
      end  
      else if(!choose)
      begin
      if(clk_t!=clk)
      begin
		if(!turn)  
        begin  
          if((min_low_setting_o==9)&&(min_high_setting_o==5))  
            begin  
              min_low_setting_o<=0;  
              min_high_setting_o<=0;  
            end  
          else   
            if(min_low_setting_o==9)  
              begin  
                min_low_setting_o<=0;  
                min_high_setting_o<=min_high_setting_o+1;  
              end  
            else  
              min_low_setting_o<=min_low_setting_o+1;  
        end  
        end
      end  
	end
assign LED_hr=turn&&!mode;
assign LED_min=!turn&&!mode;

endmodule
