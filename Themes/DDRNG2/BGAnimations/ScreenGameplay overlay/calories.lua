local player = ...
 
local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
        self:zoom(0.8)
	end;
	--Integers
    Def.RollingNumbers{
        Font= "_Bolster 21px",
        InitCommand=function(self)
            self:set_chars_wide(4):set_text_format("%04.0f"):target_number(0000):set_approach_seconds(0.2)
                :horizalign(right):vertalign(bottom):set_number_attribute{Diffuse= color("#FFFF00")}
        end;
		StepMessageCommand=cmd(playcommand,"On");
		OnCommand=function(self)
			local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
			local CaloriesBurned = pss:GetCaloriesBurned();
			if CaloriesBurned - 0.5 < 0 then
				self:target_number(0);
			else
				self:target_number(CaloriesBurned - 0.5);
			end
		end,        
    },
	--Point
	LoadFont("","_Bolster 21px")..{
		InitCommand=cmd(addx,3;settext,".";vertalign,bottom;diffuse,color("#FFFF00"));
	};
    --Decimals
    Def.RollingNumbers{
        Font= "_Bolster 21px",
        InitCommand=function(self)
            self:set_chars_wide(3):set_text_format("%03.0f"):target_number(0):set_approach_seconds(0.2)
                :addx(6):horizalign(left):vertalign(bottom):zoom(0.8):set_number_attribute{Diffuse= color("#FFFF00")}
        end,
		StepMessageCommand=cmd(playcommand,"On");
		OnCommand=function(self)
			local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
			local CaloriesBurned = pss:GetCaloriesBurned();
            self:target_number((CaloriesBurned*1000)%1000+1000/1000-1);
		end,
    },    
	--Kcal
	LoadFont("","_Bolster 21px")..{
		InitCommand=cmd(addx,54;settext,"kcal";horizalign,left;vertalign,bottom;zoom,0.8;diffuse,color("#FFFF00"));
	};
};
return t;