local t = Def.ActorFrame{
    OnCommand=function(self)
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Intro"..math.random(1,9)))
        self:hibernate(2)
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Cheer"))
    end;
    RollHitMessageCommand=function(self)
        SOUND:PlayOnce(THEME:GetPathS("player","rollhit"))
    end;
};
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
t[#t+1] = LoadActor(THEME:GetPathG("ScreenGameplay","InfoFrame"),pn)..{
		InitCommand=cmd(draworder,49;x,GameplayPlacement.StepsFrameX(pn);zoomx,GameplayPlacement.StepsFrameZoomX());
        OnCommand=cmd(playcommand,"Set";croptop,1;sleep,3.15;linear,0.15;croptop,0);
        OffCommand=cmd(sleep,0.3;accelerate,0.15;croptop,1);
		SetCommand=function(self)
            self:player(pn);
            if pn == PLAYER_1 then
                self:horizalign(left);
            elseif pn == PLAYER_2 then
                self:rotationy(180);
                self:horizalign(left);
            end
			if notefield_prefs_config:get_data(pn).reverse == -1 then
				self:y(SCREEN_CENTER_Y-280);
				self:rotationx(180);
			else
				self:y(SCREEN_CENTER_Y+263);
			end;
		end;
	};
-- steps display
t[#t+1] = Def.ActorFrame{
        InitCommand=cmd(draworder,49;xy,GameplayPlacement.StepsDisplayX(pn),GameplayPlacement.StepsDisplayY(pn);zoom,0.8;horizalign,center);
        LoadFont("Common Normal")..{
        OnCommand=cmd(playcommand,"Set");
        SetCommand=function(self)
        local diff = string.gsub(GAMESTATE:GetCurrentSteps(pn):GetDifficulty(),"Difficulty_","");
        self:settext(THEME:GetString("CustomDifficulty",diff)):uppercase(true):diffuse(CustomDifficultyToColor(diff))
        self:playcommand("Animate")
		end;
        AnimateCommand=cmd(diffusealpha,0;y,-10;sleep,3;linear,0.15;diffusealpha,1;y,0;sleep,3;linear,0.15;diffusealpha,0;y,10;queuecommand,"Animate");
        OffCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
        };
        LoadFont("Common Normal")..{
        OnCommand=cmd(playcommand,"Set";horizalign,center;diffusealpha,0;sleep,3.45;queuecommand,"Animate");
        SetCommand=function(self)
        local meter = GAMESTATE:GetCurrentSteps(pn):GetMeter();
        local diff = string.gsub(GAMESTATE:GetCurrentSteps(pn):GetDifficulty(),"Difficulty_","");
        self:settext(meter):uppercase(true):diffuse(CustomDifficultyToColor(diff))
		end;
        AnimateCommand=cmd(diffusealpha,0;y,-10;sleep,3;linear,0.15;diffusealpha,1;y,0;sleep,2.55;linear,0.15;diffusealpha,0;y,10;sleep,0.45;queuecommand,"Animate");
        OffCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
        };        
    };
t[#t+1] = LoadActor("calories.lua", pn)..{
	InitCommand=cmd(draworder,50;visible,false;playcommand,"Condition");
    OnCommand=cmd(diffusealpha,0;sleep,3.25;linear,0.15;diffusealpha,1);
    OffCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
    ConditionCommand=function(self)
    if theme_config:get_data().Mode == "Starter" then return end
        if player_config:get_data(pn).CalorieDisplay then 
            self:visible(true)
        else
            self:visible(false)
        end
		self:xy(GameplayPlacement.CaloriesX(pn),GameplayPlacement.CaloriesY(pn))         
    end;
	};
t[#t+1] = LoadActor(THEME:GetPathG("ScreenGameplay","EXFrame"),pn)..{
		InitCommand=cmd(draworder,49;visible,false;zoomy,-1;y,_screen.cy+297+20;vertalign,bottom;playcommand,"Condition");
        OnCommand=cmd(playcommand,"Set";croptop,1;sleep,3.4;linear,0.15;croptop,0);
        OffCommand=cmd(sleep,0.3;accelerate,0.15;croptop,1);
		SetCommand=function(self)
            self:player(pn);
            if pn == PLAYER_1 then
                self:x(_screen.cx-162);
                self:horizalign(left);
                self:rotationy(180);
            elseif pn == PLAYER_2 then
                self:x(_screen.cx+162);
                self:horizalign(left);
            end
		end;
    ConditionCommand=function(self)
    if theme_config:get_data().Mode == "Starter" then return end
        if player_config:get_data(pn).EXScore then 
            self:visible(true)
        else
            self:visible(false)
        end
    end;
	};
t[#t+1] = LoadActor("exscore.lua", pn)..{
	InitCommand=cmd(draworder,50;visible,false;y,_screen.cy+297+40;playcommand,"Condition");
    OnCommand=cmd(diffusealpha,0;sleep,3.55;linear,0.15;diffusealpha,1);
    OffCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
    ConditionCommand=function(self)
    if theme_config:get_data().Mode == "Starter" then return end
        if player_config:get_data(pn).EXScore then 
            self:visible(true)
        else
            self:visible(false)
        end
    end;
	};
t[#t+1] = LoadActor("stagestars.lua", pn)..{
	InitCommand=cmd(draworder,50;visible,false;y,_screen.cy+297+34;playcommand,"Condition");
    OnCommand=cmd(diffusealpha,0;sleep,3.7;linear,0.15;diffusealpha,1);
    OffCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
    ConditionCommand=function(self)
    if theme_config:get_data().Mode == "Starter" then return end
        if player_config:get_data(pn).StageStars then 
            self:visible(true)
        else
            self:visible(false)
        end
    end;
	};
t[#t+1] = LoadActor("target.lua", pn)..{
	InitCommand=cmd(draworder,50;visible,false;playcommand,"Condition");
    OnCommand=cmd(diffusealpha,0;sleep,3.85;linear,0.15;diffusealpha,1);
    OffCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
    ConditionCommand=function(self)
    if theme_config:get_data().Mode == "Starter" then return end
        if player_config:get_data(pn).Target ~= "Off" then 
            self:visible(true)
        else
            self:visible(false)
        end
    end;
	};
t[#t+1] = LoadActor("pacemaker.lua", pn)..{
	InitCommand=cmd(draworder,48;visible,false;playcommand,"Condition");
    OnCommand=cmd(diffusealpha,0;sleep,3.85;linear,0.15;diffusealpha,1);
    OffCommand=cmd(sleep,0.15;linear,0.15;diffusealpha,0);
    ConditionCommand=function(self)
    if theme_config:get_data().Mode == "Starter" then return end
        if player_config:get_data(pn).Pacemaker ~= "Off" then 
            self:visible(true)
        else
            self:visible(false)
        end
    end;
	};   
t[#t+1] = LoadActor("modicons", pn)..{
	InitCommand=cmd(draworder,49;y,GameplayPlacement.ModiconsY(pn);playcommand,"Condition");
    OnCommand=cmd(diffusealpha,0;sleep,3.15;linear,0.2;diffusealpha,1);
    OffCommand=cmd(linear,0.2;diffusealpha,0);
    ConditionCommand=function(self)
    if theme_config:get_data().Mode == "Starter" then self:visible(false) else self:visible(true) end
    end;
	};       
end
--songinfo--
t[#t+1] = Def.ActorFrame{
    Def.Quad{
        InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-58;setsize,450,60;diffuse,color("#000000");diffusealpha,0.75;zoom,0.8;fadeleft,0.25;faderight,0.25);
        OnCommand=cmd(playcommand,"Set";zoomx,0;diffusealpha,0;sleep,3;linear,0.15;zoomx,0.8;diffusealpha,0.75);
        OffCommand=cmd(sleep,0.9;accelerate,0.15;zoomy,0);
    };
    LoadFont("Common Normal")..{
        InitCommand=cmd(horizalign,center;CenterX;y,SCREEN_BOTTOM-58-11;zoom,0.8;draworder,50);
        OnCommand=cmd(diffusealpha,0;sleep,3.3;linear,0.15;diffusealpha,1);
        OffCommand=cmd(sleep,0.3;linear,0.15;diffusealpha,0);
        CurrentSongChangedMessageCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
        local text = song:GetDisplayMainTitle();
            self:diffusealpha(1);
            self:maxwidth(450);
            self:settext(text);
        end;
    };
    --artist--
    LoadFont("Common Normal")..{
        InitCommand=cmd(horizalign,center;CenterX;y,SCREEN_BOTTOM-58+11;zoom,0.6;draworder,50);
        OnCommand=cmd(diffusealpha,0;sleep,3.35;linear,0.15;diffusealpha,1);
        OffCommand=cmd(sleep,0.3;linear,0.15;diffusealpha,0);
        CurrentSongChangedMessageCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
        local text = song:GetDisplayArtist();
            self:diffusealpha(1);
            self:maxwidth(450);
            self:settext(text);
        end;
    };
};
-- ready/go
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do   
t[#t+1] = LoadFont("Common Large Bold")..{
    Text=THEME:GetString("ScreenGameplay","Ready");
	InitCommand=cmd(xy,GameplayPlacement.SplashesX(pn),_screen.cy-SCREEN_HEIGHT/4+64;draworder,105;zoom,0.3;addx,64-128-64;horizalign,left;diffusealpha,0);
	OnCommand=cmd(decelerate,0.8;addx,-64;diffusealpha,1;sleep,2;cropleft,0;accelerate,0.5;diffusealpha,0;addx,-32;cropleft,1);           
};
t[#t+1] = LoadFont("Common Large Bold")..{
    Text=THEME:GetString("ScreenGameplay","Go");
	InitCommand=cmd(xy,GameplayPlacement.SplashesX(pn),_screen.cy+SCREEN_HEIGHT/4;draworder,105;zoom,0.3;addx,128;horizalign,left;diffusealpha,0);
	OnCommand=cmd(sleep,3.3;cropright,1;decelerate,0.8;addx,-64;diffusealpha,1;cropright,0;sleep,2;accelerate,0.5;diffusealpha,0;addx,-32);           
};
-- clear/fc       
t[#t+1] = LoadFont("Common Large Bold")..{
	InitCommand=cmd(xy,GameplayPlacement.SplashesX(pn),_screen.cy-SCREEN_HEIGHT/4+64;draworder,105;zoom,0.3;addx,64-128-64;horizalign,left;diffusealpha,0;shadowlength,2);
    OnCommand=function(self)
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
        if pss:GetGrade()=="Grade_Failed" then
            self:settext(THEME:GetString("ScreenGameplay","Fail"));
        else
            self:settext(THEME:GetString("ScreenGameplay","Clear"));
        end
    end;
	OffCommand=cmd(decelerate,0.8;addx,-64;diffusealpha,1;sleep,2;cropleft,0;accelerate,0.5;diffusealpha,0;addx,-32;cropleft,1);           
};
t[#t+1] = LoadFont("Common Large Bold")..{
	InitCommand=cmd(xy,GameplayPlacement.SplashesX(pn),_screen.cy+SCREEN_HEIGHT/4;draworder,105;zoom,0.3;addx,128;horizalign,left;diffusealpha,0;shadowlength,2);
    OnCommand=function(self)
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
        if pss:FullComboOfScore('TapNoteScore_W1') then self:settext(THEME:GetString("ScreenGameplay","FC_W1"));
        elseif pss:FullComboOfScore('TapNoteScore_W2') then self:settext(THEME:GetString("ScreenGameplay","FC_W2"));
        elseif pss:FullComboOfScore('TapNoteScore_W3') then self:settext(THEME:GetString("ScreenGameplay","FC_W3"));
        elseif pss:FullComboOfScore('TapNoteScore_W4') then self:settext(THEME:GetString("ScreenGameplay","FC_W4"));
        elseif pss:FullComboOfScore('TapNoteScore_W5') then self:settext(THEME:GetString("ScreenGameplay","FC_W5"));
        else self:settext("");
        end  
    end;
	OffCommand=cmd(sleep,3.3;decelerate,0.8;addx,-64;diffusealpha,1;sleep,2;cropright,0;accelerate,0.5;diffusealpha,0;addx,-32;cropright,1);           
};
end;

t[#t+1]= LoadActor(THEME:GetPathG("", "pause_menu"))

-- demo
if SCREENMAN:GetTopScreen() == "ScreenDemonstration" or GAMESTATE:GetNumSidesJoined() == 0 then
t[#t+1] = Def.ActorFrame{
    InitCommand=cmd(Center);
    Def.Quad{
        InitCommand=cmd(setsize,_screen.w,50;diffuse,color("#000000");diffusealpha,0.5);       
    };
    LoadFont("Common Bold")..{
        Text="Demonstration";
        InitCommand=cmd(diffuseshift;effectperiod,1);
    };
};
end;

t[#t+1]= notefield_prefs_actor()
return t;