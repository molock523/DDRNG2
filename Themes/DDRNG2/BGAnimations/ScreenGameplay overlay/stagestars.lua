local player = ...

local function ThisStageStars(player)
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
local curstars = 0
    if pss:GetGrade() == "Grade_Tier01" then
        curstars = 3
    elseif pss:GetGrade() == "Grade_Tier02" then
        curstars = 2
    elseif pss:GetGrade() == "Grade_Tier07" or pss:GetGrade() == "Grade_Failed" then
        curstars = 0
    else
        curstars = 1
    end
    return curstars;
end

local function TotalStageStars(player)
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
local StarsFile = RageFileUtil:CreateRageFile(THEME:GetCurrentThemeDirectory().."Save/playerstats/"..ToEnumShortString(player).."_stars.txt")
StarsFile:Open(THEME:GetCurrentThemeDirectory().."Save/playerstats/"..ToEnumShortString(player).."_stars.txt",1)
local savedstars = StarsFile:Read()
local curstars = savedstars + 0
    if pss:GetGrade() == "Grade_Tier01" then
        curstars = savedstars + 3
    elseif pss:GetGrade() == "Grade_Tier02" then
        curstars = savedstars + 2
    elseif pss:GetGrade() == "Grade_Tier07" or pss:GetGrade() == "Grade_Failed" then
        curstars = savedstars + 0
    else
        curstars = savedstars + 1
    end
    StarsFile:Close()
    return curstars;
end

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
		GetX(self, 200)
	end;
    LoadActor(THEME:GetPathG("","_stagestar"))..{
        Name="Img_stagestar";
        InitCommand=cmd(zoom,0.17;addx,-10);
    };    
	--Integers
    Def.RollingNumbers{
        Font= "Common Normal",
        InitCommand=function(self)
            self:set_chars_wide(1):set_text_format("%01.0f"):target_number(0):set_approach_seconds(0.2)
                :zoom(0.7):horizalign(left):set_number_attribute{Diffuse= color("#FFFFFF")}
        end;
		StepMessageCommand=cmd(playcommand,"On");
		OnCommand=function(self)
            self:target_number(ThisStageStars(player));
		end;
    };
    OffCommand=function(self)
        local StarsFile = OpenFile("playerstats","_stars",player,2);
        StarsFile:Write(TotalStageStars(player,2))
        StarsFile:Close()
    end;
};
return t;