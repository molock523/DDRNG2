local function InputHandler(event)
if event.type == "InputEventType_Release" then return false end
    if event.DeviceInput.button == "DeviceButton_1" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))
        MESSAGEMAN:Broadcast("KP1")
    elseif event.DeviceInput.button == "DeviceButton_2" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
        MESSAGEMAN:Broadcast("KP2")
    elseif event.DeviceInput.button == "DeviceButton_3" then
        SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
        MESSAGEMAN:Broadcast("KP3")              
    end          
end

local t = Def.ActorFrame{
OnCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
    local sp1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1)
    local sp2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2)
    local stats;
    if GAMESTATE:GetNumPlayersEnabled()<2 then 
        stats=STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
    else
        if sp1:GetScore()<=sp2:GetScore() then
            stats=sp1
        else
            stats=sp2
        end
    end
    local grade = stats:GetGrade()
    local record = stats:GetMachineHighScoreIndex()
    if record ~= -1 then
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenEvaluation_CommentRecord"..math.random(1,7)))
    else
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenEvaluation_Comment_"..Renaming.sgrade(grade)..math.random(1,3)))
    end
end;
};
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
t[#t+1] = LoadActor("info.lua", pn);
end

t[#t+1] = Def.ActorFrame{
    InitCommand=cmd();
    LoadFont("Common Bold")..{
        InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+105,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2;horizalign,left;vertalign,top;zoom,1);
        OnCommand=cmd(playcommand,"Set";cropright,1;sleep,1.5;linear,0.2;cropright,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(": "..song:GetDisplayFullTitle())
            end
        end;
    };
    LoadFont("Common Bold")..{
        InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+120,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2+30;horizalign,left;vertalign,top;zoom,0.5);
        OnCommand=cmd(playcommand,"Set";cropbottom,1;sleep,1.7;linear,0.2;cropbottom,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(song:GetDisplayArtist())
            end
        end;
    }; 
};

t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2();
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra1" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		OnCommand=cmd(play);
    };
};

return t