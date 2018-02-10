local player = ...

local function ChangeEXScore(params)
	local ret = 0;
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
	local w1 = pss:GetTapNoteScores('TapNoteScore_W1');
	local w2 = pss:GetTapNoteScores('TapNoteScore_W2');
	local w3 = pss:GetTapNoteScores('TapNoteScore_W3');
	local hd = pss:GetHoldNoteScores('HoldNoteScore_Held');
	if params.HoldNoteScore == 'HoldNoteScore_Held' then
		hd = hd+1;
	elseif params.TapNoteScore == 'TapNoteScore_W1' then
		w1 = w1+1;
	elseif params.TapNoteScore == 'TapNoteScore_W2' then
		w2 = w2+1;
	elseif params.TapNoteScore == 'TapNoteScore_W3' then
		w3 = w3+1;
	end;
	ret = w1*3 + w2*2 + w3*1 + hd*3;
	return ret;
end;

local function GetX(self,offset)
        if player==PLAYER_1 then
				self:x(_screen.cx-162-offset)
        elseif player==PLAYER_2 then
				self:x(_screen.cx+162+offset)
        end
end

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		GetX(self, 80)
	end;
    LoadFont("Common Normal")..{
        Text="EX";
        InitCommand=cmd(horizalign,left;addx,-50;zoom,0.8;vertalign,bottom);
    };
	--Integers
    Def.RollingNumbers{
        Font= "Common Normal",
        InitCommand=function(self)
            self:set_chars_wide(1):set_text_format("%01.0f"):target_number(0):set_approach_seconds(0.2)
                :zoom(0.8):vertalign(bottom):horizalign(right):addx(50):set_number_attribute{Diffuse= color("#FFFFFF")}
        end;
		StepMessageCommand=cmd(playcommand,"On");
		OnCommand=function(self)
            self:target_number(ChangeEXScore(player));
            LoadFile(ToEnumShortString(player).."_ex.txt","playerstats");
            WriteFile(ToEnumShortString(player).."_ex.txt",ChangeEXScore(player),"playerstats")      
		end;
        OffCommand=function(self)
            LoadFile(ToEnumShortString(player).."_ex.txt","playerstats");
            WriteFile(ToEnumShortString(player).."_ex.txt",ChangeEXScore(player),"playerstats")
        end;
    };
};
return t;