module timing(mode,reset_sec,clk,hr_high_timing_i,hr_low_timing_i,min_high_timing_i,min_low_timing_i,hr_high_timing_o,hr_low_timing_o,min_high_timing_o,min_low_timing_o,sec_high_timing_o,sec_low_timing_o,alarm);
input reset_sec,clk,mode;
output alarm;
reg alarm;
input[3:0] hr_high_timing_i,hr_low_timing_i,min_high_timing_i,min_low_timing_i;
output[3:0] hr_high_timing_o,min_high_timing_o,sec_high_timing_o,hr_low_timing_o,min_low_timing_o,sec_low_timing_o;
reg[3:0] hr_high_timing_o,min_high_timing_o,sec_high_timing_o,hr_low_timing_o,min_low_timing_o,sec_low_timing_o;
wire carry_sec,carry_min;


initial
begin
hr_high_timing_o<=0;
min_high_timing_o<=0;
sec_high_timing_o<=0;
hr_low_timing_o<=0;
min_low_timing_o<=0;
sec_low_timing_o<=0;
end


always @(posedge clk) //sec_low_timing
begin
	if(!reset_sec) sec_low_timing_o<=0;  
  else if(sec_low_timing_o==9)  
    sec_low_timing_o<=0;  
  else  
    sec_low_timing_o<=sec_low_timing_o+1;  
end  

always @(posedge clk)  //sec_high_timing
begin  
  if(!reset_sec) sec_high_timing_o<=0;  
  else if(sec_low_timing_o==9)  
    begin  
      if(sec_high_timing_o==5)  
        sec_high_timing_o<=0;  
      else  
        sec_high_timing_o<=sec_high_timing_o+1;  
    end  
end  

assign carry_sec=((sec_high_timing_o==5)&&(sec_low_timing_o==9))?1:0;  

always @(posedge clk)  //min_low_timing
begin  
  if(carry_sec)  
    begin  
     if(min_low_timing_o==9)  
        min_low_timing_o<= 0;  
     else 
        min_low_timing_o<=min_low_timing_o+1; 
     
    end 
   else  if(!mode)
		min_low_timing_o<=min_low_timing_i;
end  

always @(posedge clk)  //min_high_timing
begin   
  if(carry_sec)  
    begin  
    if(min_low_timing_o==9)  
      begin  
      if(min_high_timing_o==5)  
        min_high_timing_o <= 0;  
      else 
        min_high_timing_o<= min_high_timing_o+1; 
      end  
    end 
    else if (!mode) 
		min_high_timing_o<=min_high_timing_i; 
end  

assign carry_min = ((min_high_timing_o==5)&&(min_low_timing_o==9))?1:0; 

always @(posedge clk)  //hr_low_timing
begin
  if(carry_min&&carry_sec)  
  begin  
    if((hr_high_timing_o==2)&&(hr_low_timing_o==3))   
      hr_low_timing_o<=0;  
    else
       if(hr_low_timing_o==9)  
        hr_low_timing_o <=0;  
       else  
        hr_low_timing_o <= hr_low_timing_o + 1; 
  end 
  else if(!mode)
	hr_low_timing_o<=hr_low_timing_i;
end  

always @(posedge clk)  //hr_high_timing
begin   
  if(carry_min&&carry_sec)  
  begin  
      if((hr_high_timing_o==2)&&(hr_low_timing_o==3))  
        hr_high_timing_o <= 0;  
      else if(hr_low_timing_o==9)  
        hr_high_timing_o<=hr_high_timing_o+1;  
  end  
  else if(!mode)
	hr_high_timing_o<=hr_high_timing_i;
end  

always @(negedge clk)  
      begin  
        if(!reset_sec) //important!!!  
        begin  
			alarm<=0;
		end
		
		else
		begin
			if((min_high_timing_o==5&&min_low_timing_o==9&&sec_high_timing_o==5&&(sec_low_timing_o==0||sec_low_timing_o==2||sec_low_timing_o==4||sec_low_timing_o==6||sec_low_timing_o==8)
			    ||(min_high_timing_o==0&&min_low_timing_o==0&&sec_high_timing_o==0&&sec_low_timing_o==0))
			    &&(!(hr_high_timing_o==0&&(hr_low_timing_o==0||hr_low_timing_o==1||hr_low_timing_o==2||hr_low_timing_o==3||hr_low_timing_o==4||hr_low_timing_o==5||hr_low_timing_o==6)))
			&&mode)
			alarm<=1;
			else
			alarm<=0;
		end
	end
endmodule



