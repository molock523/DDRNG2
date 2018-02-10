local player = ...
local song = GAMESTATE:GetCurrentSong();

local function x_pos(self,offset)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
		self:x(_screen.w/2+335+offset);
	end
end

local function DifficultyPanel()
local t = Def.ActorFrame{};
local difficulties = {"Beginner", "Easy"}
local tLocation = {
    Beginner	= 42*0,
    Easy 		= 42*1,
};
for diff in ivalues(difficulties) do
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end;
        CurrentStepsP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end;
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong()
        local bHasStepsTypeAndDifficulty = false;
        local curDiff;
            if song then
            local st = GAMESTATE:GetCurrentStyle():GetStepsType()
            bHasStepsTypeAndDifficulty = song:HasStepsTypeAndDifficulty( st, diff );
                local steps = song:GetOneSteps( st, diff );
                if steps then
                    c.Bar_meter:diffuse(CustomDifficultyToColor(diff)):visible(true)
                    c.Text_meter:settext(steps:GetMeter()):visible(true)
                    c.Text_difficulty:settext(THEME:GetString("CustomDifficulty",diff)):visible(true)
                    local cursteps = GAMESTATE:GetCurrentSteps(player);                   
                        if cursteps then
                            curDiff = cursteps:GetDifficulty(player);
                            -- disable hack
                            if difficulties[curDiff] == nil then
                                GAMESTATE:SetPreferredDifficulty(player,"Easy")
                            end
                            
                            if ToEnumShortString(curDiff) == diff then
                                c.Bar_underlay:diffuse(CustomDifficultyToColor(diff))
                                c.Text_difficulty:diffuse(color("#ffffff"))
                            else
                                c.Bar_underlay:diffuse(color("#ffffff"))
                                c.Text_difficulty:diffuse(CustomDifficultyToColor(diff))
                            end
                        end                           
                else
                    c.Bar_underlay:diffuse(color("#ffffff"))
                    c.Bar_meter:visible(false)
                    c.Text_meter:settext("")  
                    c.Text_difficulty:settext("")
                end
            else
                c.Bar_underlay:diffuse(color("#ffffff"))
                c.Bar_meter:visible(false)
                c.Text_meter:settext("")
                c.Text_difficulty:settext("")
            end
        end;
        Def.Quad{
            Name="Bar_underlay";
            InitCommand=cmd(setsize,272,40;y,tLocation[diff];shadowlengthy,1;shadowcolor,color("#eaeaea"));
        };         
        Def.Quad{
            Name="Bar_meter";
            InitCommand=cmd(addx,-120;setsize,36,40;y,tLocation[diff]);                    
        };
        LoadFont("Common Normal")..{
            Name="Text_meter";
            Text="";
            InitCommand=cmd(addx,-120;horizalign,center;zoom,0.8;y,tLocation[diff]);
        };
        LoadFont("Common Normal")..{
            Name="Text_difficulty";
            Text="";
            InitCommand=cmd(addx,-90;horizalign,left;zoom,0.8;y,tLocation[diff]);
        };            
};
end    
return t
end

local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame{
    InitCommand=function(self)
            self:zoom(0.75)
            x_pos(self,0)
            self:CenterY();
    end;    
    LoadActor(THEME:GetPathG("","PlayerPanelDefault"));
	LoadFont("Common Bold") .. {
        InitCommand=cmd(maxwidth,270;zoom,0.8;horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+20;diffuse,PlayerColor(player));
        OnCommand=function(self)
            if player== PLAYER_1 then
                self:settext("Player 1");
            else
                self:settext("Player 2");
            end
            self:diffusealpha(0):sleep(1.5):linear(0.2):diffusealpha(1);
        end;
        OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
    };
    Def.Quad{
        InitCommand=cmd(horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+50;setsize,90,5;diffuse,PlayerColor(player));
        OnCommand=cmd(cropright,1;sleep,1.7;linear,0.2;cropright,0);
        OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
    };
    Def.ActorFrame{
        InitCommand=cmd();
            OnCommand=cmd(diffusealpha,0;sleep,1.9;linear,0.2;diffusealpha,1);
            OffCommand=cmd(linear,0.2;diffusealpha,0);
        DifficultyPanel(player)..{InitCommand=cmd(y,_screen.cy-500);};
    };
};
return t