local function InputHandler(event)
local player = event.PlayerNumber
local MusicWheel = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");   
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
        if event.GameButton == "Select" then
            if GAMESTATE:GetCurrentStage() ~= "Extra1" or "Extra2" then 
                SCREENMAN:AddNewScreenToTop("ScreenNestyPlayerOptions")
            end
        end    
	end

local t = Def.ActorFrame{
OnCommand=function(self)
    local MusicWheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
    if GAMESTATE:IsCourseMode() then
        SONGMAN:SetPreferredCourses("Pro");
    else
        MusicWheel:ChangeSort("SortOrder_Preferred");
        if GAMESTATE:GetCurrentStage() == "Stage_Extra1" then 
            SONGMAN:SetPreferredSongs("Extra1")
        elseif GAMESTATE:GetCurrentStage() == "Stage_Extra2" then 
            SONGMAN:SetPreferredSongs("Extra2")
        else
            SONGMAN:SetPreferredSongs("Default");
        end
    end
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
    SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectMusic_Intro"..math.random(1,9)))        
end;
SongChosenMessageCommand=function(self)
    SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel"):Move(0)      
    SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler)
    SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectMusic_Difficulty"..math.random(1,3)))
end;
SongUnchosenMessageCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
end;
TwoPartConfirmCanceledMessageCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
end;
OffCommand=function(self)
    if SCREENMAN:GetTopScreen():GetGoToOptions() then
        SCREENMAN:AddNewScreenToTop("ScreenNestyPlayerOptions")
    end
    if GAMESTATE:GetCurrentStage()=="Stage_Extra1" or GAMESTATE:GetCurrentStage()=="Stage_Extra2" then
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectMusic_CommentExtra"..math.random(1,7)))
    else
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectMusic_CommentNormal"..math.random(1,8)))
    end
end;
CodeMessageCommand=function(self,params)
    if params.PlayerNumber then
        if params.Name=="SortWheel" then
            if GAMESTATE:GetCurrentStage() ~= "Stage_Extra1" or "Stage_Extra2" then 
                SCREENMAN:AddNewScreenToTop("ScreenSortList");
            end
        end        
    end
end;
};
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
    if GAMESTATE:GetCurrentStage() ~= "Stage_Extra1" or "Stage_Extra2" then
        t[#t+1] = LoadActor("info.lua", pn);
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
        CurrentCourseChangedMessageCommand=cmd(playcommand,"Set"); 
        SetCommand=function(self)
            local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();
            if song then
                self:settext(THEME:GetString("ScreenStageInformation",GAMESTATE:GetCurrentStage()))
            end
        end;
    };    
    LoadFont("Common Bold")..{
        InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+105,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2;horizalign,left;vertalign,top;zoom,1);
        OnCommand=cmd(playcommand,"Set";cropright,1;sleep,1.5;linear,0.2;cropright,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
        CurrentCourseChangedMessageCommand=cmd(playcommand,"Set"); 
        SetCommand=function(self)
            local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();
            if song then
                    self:settext(": "..song:GetDisplayFullTitle())
            else
                self:settext("")
            end
        end;
    };
    LoadFont("Common Bold")..{
        InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+120,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2+30;horizalign,left;vertalign,top;zoom,0.5);
        OnCommand=cmd(playcommand,"Set";cropbottom,1;sleep,1.7;linear,0.2;cropbottom,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set"); 
        CurrentCourseChangedMessageCommand=cmd(playcommand,"Set"); 
        SetCommand=function(self)
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();
            if song then
                if GAMESTATE:IsCourseMode() then
                    self:settext(song:GetScripter())
                else
                    self:settext(song:GetDisplayArtist())
                end
            else
                self:settext("")
            end
        end;
    };
    -- Group
    LoadFont("Common Bold")..{
        Condition=not GAMESTATE:IsCourseMode();
        InitCommand=function(self)
            if aspectratio()=="16:9" then
                self:horizalign(right):vertalign(top):y(_screen.cy+(SCREEN_HEIGHT/1.3*0.5)-32-20)
            elseif aspectratio()=="4:3" then
                self:horizalign(left):vertalign(top):y(_screen.cy+(SCREEN_HEIGHT/1.3*0.5)-32+20):wrapwidthpixels(100)
            end
            self:zoom(1):rotationz(90):x(_screen.cx+(SCREEN_WIDTH/1.3*0.5)+11-10+2)
        end;
        OnCommand=cmd(playcommand,"Set";cropright,1;sleep,0.2;linear,0.2;cropright,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext("Origin"):uppercase(true)
            end
        end;
    };
    LoadActor(THEME:GetPathG("","header_icons/None"))..{
        InitCommand=cmd(xy,_screen.cx+(SCREEN_WIDTH/1.3*0.5)+11-10+2,_screen.cy+(SCREEN_HEIGHT/1.3*0.5)-25+2;addx,-9;addy,-9);
        OnCommand=cmd(rotationz,-90;zoom,0.15;diffusealpha,0;sleep,0.9;spring,0.3;zoom,0.25;diffusealpha,1;rotationz,0);
    };    
    LoadFont("Common Bold")..{
        Condition=not GAMESTATE:IsCourseMode();
        InitCommand=cmd(xy,_screen.cx+(SCREEN_WIDTH/1.3*0.5)+11-10+2-50+9,_screen.cy+(SCREEN_HEIGHT/1.3*0.5)-25+2-16;horizalign,right;vertalign,top;zoom,1);
        OnCommand=cmd(playcommand,"Set";cropleft,1;sleep,1.5;linear,0.2;cropleft,0);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(Renaming.songgroup(song:GetGroupName())):wrapwidthpixels(200)
            else
                self:settext("")
            end
        end;
    };
    -- BPM
    LoadFont("Common Bold")..{
        Condition=not GAMESTATE:IsCourseMode();
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