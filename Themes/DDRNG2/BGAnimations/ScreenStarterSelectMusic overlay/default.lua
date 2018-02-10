local cstage={
	Stage_1st		= "1st Stage",
	Stage_2nd		= "2nd Stage",
	Stage_3rd		= "3rd Stage",
	Stage_4th		= "4th Stage",
	Stage_5th		= "5th Stage",
	Stage_6th		= "6th Stage",
    Stage_Final     = "Final Stage",
    Stage_Extra1    = "Extra Stage",
    Stage_Extra2    = "Extra Stage",
    Stage_Nonstop   = "Pro Mode",
    Stage_Event     = "Event Mode",
};

local function InputHandler(event)
local player = event.PlayerNumber
local MusicWheel = SCREENMAN:GetTopScreen("ScreenStarterSelectMusic"):GetChild("MusicWheel");   
    if event.type == "InputEventType_Release" then return false end
        if ConsoleType() ~= "2" then
            if event.DeviceInput.button == "DeviceButton_1" then
                SOUND:PlayOnce(THEME:GetPathS("","_common switch"))
                MESSAGEMAN:Broadcast("P1_1",{player = PLAYER_1 })
            elseif event.DeviceInput.button == "DeviceButton_2" then
                SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
                MESSAGEMAN:Broadcast("P1_2",{player = PLAYER_1 })
            elseif event.DeviceInput.button == "DeviceButton_3" then
                SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
                MESSAGEMAN:Broadcast("P1_3",{player = PLAYER_1 })              
            elseif event.DeviceInput.button == "DeviceButton_KP 1" then
                SOUND:PlayOnce(THEME:GetPathS("","_common switch"))
                MESSAGEMAN:Broadcast("P2_1",{player = PLAYER_2 })
            elseif event.DeviceInput.button == "DeviceButton_KP 2" then
                SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
                MESSAGEMAN:Broadcast("P2_2",{player = PLAYER_2 })
            elseif event.DeviceInput.button == "DeviceButton_KP 3" then
                SOUND:PlayOnce(THEME:GetPathS("","_common switch"))                    
                MESSAGEMAN:Broadcast("P2_3",{player = PLAYER_2 })              
            end        
        end
        if MusicWheel ~= nil then  
            if event.GameButton == "MenuLeft" then 
                MESSAGEMAN:Broadcast("SongUnchosen") 
                MESSAGEMAN:Broadcast("TwoPartConfirmCancelled")            
                MusicWheel:Move(-1):Move(0) 
            end
            if event.GameButton == "MenuUp" then 
                MESSAGEMAN:Broadcast("SongUnchosen") 
                MESSAGEMAN:Broadcast("TwoPartConfirmCancelled")
                if MusicWheelType()=="MusicWheelGrid" then MusicWheel:Move(-3):Move(0) end
            end
            if event.GameButton == "MenuRight" then 
                MESSAGEMAN:Broadcast("SongUnchosen") 
                MESSAGEMAN:Broadcast("TwoPartConfirmCancelled")            
                MusicWheel:Move(1):Move(0) 
            end
            if event.GameButton == "MenuDown" then 
                MESSAGEMAN:Broadcast("SongUnchosen") 
                MESSAGEMAN:Broadcast("TwoPartConfirmCancelled")
                if MusicWheelType()=="MusicWheelGrid" then MusicWheel:Move(3):Move(0) end                                
            end
        end   
	end

local t = Def.ActorFrame{
OnCommand=function(self)
    local MusicWheel = SCREENMAN:GetTopScreen("ScreenStarterSelectMusic"):GetChild("MusicWheel")
    MusicWheel:ChangeSort("SortOrder_Preferred");
    SONGMAN:SetPreferredSongs("Starter");
    SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectMusic_CommentNormal"..math.random(1,8)))
        if theme_config:get_data().MusicWheel == "Grid" then 
            (cmd(zoom,0.45;zwrite,true;ztest,true;draworder,10;z,10;fov,60;addx,_screen.w/4;diffusealpha,0;decelerate,0.8;addx,-_screen.w/4;diffusealpha,1))(MusicWheel)
        elseif theme_config:get_data().MusicWheel == "List" then 
            (cmd(zoom,0.85;zwrite,true;ztest,true;draworder,10;z,10))(MusicWheel)
        elseif theme_config:get_data().MusicWheel == "X2" then 
            (cmd(zoom,0.8;draworder,-19;fov,100;vanishpoint,_screen.cx,_screen.cy-90;SetDrawByZPosition,true))(MusicWheel)
        elseif theme_config:get_data().MusicWheel == "Old-style" then 
            (cmd(addx,_screen.w;linear,0.2;addx,-_screen.w/2-335;zwrite,true;ztest,true;draworder,10;z,10;))(MusicWheel)             
        end
    SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) 
end;
SongChosenMessageCommand=function(self)
    SCREENMAN:GetTopScreen("ScreenStarterSelectMusic"):GetChild("MusicWheel"):Move(0)      
    SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler)
end;
SongUnchosenMessageCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
end;
TwoPartConfirmCanceledMessageCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
end;
OffCommand=function(self)
    SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectMusic_CommentStarter"..math.random(1,4)))
end;
};
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
    if GAMESTATE:GetCurrentStage() ~= "Stage_Extra1" or "Stage_Extra2" then
    t[#t+1] = LoadActor("starter.lua", pn);
    end
end

t[#t+1] = Def.ActorFrame{
    InitCommand=cmd();
    OffCommand=cmd(linear,0.2;diffusealpha,0);
    -- stage
    LoadFont("Common Bold")..{
        InitCommand=function(self)
            if aspectratio()=="16:9" then
                self:horizalign(right):vertalign(bottom):y(_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+32+20)
            elseif aspectratio()=="4:3" then
                self:horizalign(left):vertalign(bottom):y(_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+32-20):wrapwidthpixels(100)
            end
            self:zoom(1):rotationz(-90):x(_screen.cx-(SCREEN_WIDTH/1.3*0.5)-11+10-2)
        end;
        OnCommand=cmd(playcommand,"Set";cropright,1;sleep,0.2;linear,0.2;cropright,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(cstage[GAMESTATE:GetCurrentStage()]):uppercase(true)
            end
        end;
    };    
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
    LoadFont("Common Bold")..{
        InitCommand=cmd(xy,_screen.cx+205,_screen.cy+242;horizalign,right;vertalign,top;zoom,0.75);
        OnCommand=cmd(playcommand,"Set";cropright,1;sleep,1.5;linear,0.2;cropright,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            if song then
                local bpmtext;
                bpmtext = song:GetDisplayBpms();
                if bpmtext[1] == bpmtext[2] then
                    bpmtext = round(bpmtext[1],0);
                else
                    bpmtext = string.format("%d-%3d",round(bpmtext[1],0),round(bpmtext[2],0));
                end
                self:settext("BPM: "..bpmtext);
                self:visible(true);
            else
                self:visible(false);
            end
        end;
    };
};
return t