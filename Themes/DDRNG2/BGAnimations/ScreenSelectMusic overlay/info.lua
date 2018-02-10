local player = ...

local function x_pos(self,offset)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
        if MusicWheelType()=="MusicWheelOld-style" then 
            self:x(_screen.w/2-50+offset);
        else
            self:x(_screen.w/2+335+offset);
        end
	end
end

local function PlayerPanel()
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end;
        CurrentStepsP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end;
        CurrentTrailP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end;
        CurrentTrailP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end;        
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();
            if song then
            local steps = GAMESTATE:GetCurrentSteps(player) or GAMESTATE:GetCurrentTrail(player);
                if steps then
                    c.Bar_underlay:visible(true)
                    scorelist = PROFILEMAN:GetProfile(player):GetHighScoreList(song,steps)
                    local scores = scorelist:GetHighScores()
                    local topscore=0
                        local temp=#scores;                
                    if scores[1] then
                        topscore = scores[1]:GetScore()
                        topgrade = scores[1]:GetGrade()
                        fc = scores[1]:GetStageAward()
                    end
                        assert(topscore);
                    if topscore ~= 0  then
                        c.Bar_underlay:diffuse(color("#ffffff"))
                        c.Img_place:visible(true)
                    local scorel3 = topscore%1000
                    local scorel2 = (topscore/1000)%1000
                    local scorel1 = (topscore/1000000)%1000000
                        c.Text_score:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
                            if scores[1]:GetName() ~= nil then
                                if scores[1]:GetName() == "" then
                                    c.Text_name:settext(PROFILEMAN:GetProfile(player):GetDisplayName())
                                else
                                    c.Text_name:settext(scores[1]:GetName())
                                end
                            else
                                c.Text_name:settext("STEP")
                            end
                        c.Bar_underlay:diffuse(PlayerColor(player))
                        c.Img_grade:visible(true)
                        c.Img_grade:Load(THEME:GetPathG("","_grade/"..topgrade))
                        if fc=="StageAward_FullComboW4" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"])
                        elseif fc=="StageAward_FullComboW3" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
                        elseif fc=="StageAward_FullComboW2" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
                        elseif fc=="StageAward_FullComboW1" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
                        else
                            c.Img_fc:visible(false)
                        end
                        for i=1,temp do 
                        if scores[i] then
                            topscore = scores[i];
                            assert(topscore);
                            c.Bar_judgments:diffusealpha(1)
                            c.Text_judgmenttitles:diffusealpha(1)
                            c.Text_judgments:settext(topscore:GetTapNoteScore("TapNoteScore_W1").."\n"
                            ..topscore:GetTapNoteScore("TapNoteScore_W2").."\n"
                            ..topscore:GetTapNoteScore("TapNoteScore_W3").."\n"
                            ..topscore:GetTapNoteScore("TapNoteScore_W4").."\n"
                            ..topscore:GetHoldNoteScore("HoldNoteScore_Held").."\n"
                            ..topscore:GetTapNoteScore("TapNoteScore_W5")+topscore:GetTapNoteScore("TapNoteScore_Miss")):diffusealpha(1)
                        else
                            c.Text_judgments:settext("0\n0\n0\n0\n0\n0"):diffusealpha(0.15)
                            c.Bar_judgments:diffusealpha(0.15)
                            c.Text_judgmenttitles:diffusealpha(0.15)
                        end;
                        end;
                    else
                        c.Img_place:visible(false)
                        c.Bar_underlay:diffuse(color("#eaeaea"))
                        c.Text_score:settext("")
                        c.Text_name:settext("")
                        c.Img_grade:visible(false)
                        c.Img_fc:visible(false)
                        c.Text_judgments:settext("0\n0\n0\n0\n0\n0"):diffusealpha(0.15)
                        c.Bar_judgments:diffusealpha(0.15)
                        c.Text_judgmenttitles:diffusealpha(0.15)
                    end 
                end
            end
        end;
        Def.Quad{
            Name="Bar_underlay";
            InitCommand=cmd(setsize,272,40;shadowlengthy,1;shadowcolor,color("#eaeaea"));
        }; 
        LoadActor(THEME:GetPathG("","_rival/_rival"))..{
            Name="Img_place";
            InitCommand=cmd(addx,-120;zoom,0.8;diffuse,color("#2e2e2e");animate,false;setstate,0);
        };          
        LoadFont("Common Normal")..{
            Name="Text_place";
            Text=rival;
            InitCommand=cmd(addx,-120;zoom,0.8;diffuse,color("#ffffff"));
        };           
        LoadFont("Common Normal")..{
            Name="Text_name";
            Text="";
            InitCommand=cmd(addx,-90;horizalign,left;zoom,0.8;diffuse,color("#000000"));
        };
        LoadFont("Common Normal")..{
            Name="Text_score";
            Text="";
            InitCommand=cmd(addx,100;horizalign,right;zoom,0.8;diffuse,color("#000000"));
        };
        LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
            Name="Img_fc";
            InitCommand=cmd(zoom,0.35;addx,122;addy,-5;glowblink;effectperiod,0.2);
        };              
        Def.Sprite{
            Name="Img_grade";
            InitCommand=cmd(zoom,0.15;addx,116);
        };
        Def.Quad{
            Name="Bar_judgments";
            InitCommand=cmd(setsize,272,24*6;addy,96);
        };
        LoadFont("Common Normal")..{
            Name="Text_judgmenttitles";
            InitCommand=cmd(zoom,0.6;diffuse,color("#000000");horizalign,left;addx,-120;addy,96);
            OnCommand=function(self)
                self:settext("Marvelous\nPerfect\nGreat\nGood\nOK\nMiss")
            end;
        };        
        LoadFont("Common Normal")..{
            Name="Text_judgments";
            InitCommand=cmd(zoom,0.6;diffuse,color("#000000");horizalign,right;addx,100;addy,96);
        };  
};   
return t
end

local function DifficultyPanel()
local t = Def.ActorFrame{};
local difficulties = {"Beginner", "Easy", "Medium", "Hard", "Challenge"}
local tLocation = {
    Beginner	= 42*0,
    Easy 		= 42*1,
    Medium		= 42*2,
    Hard		= 42*3,
    Challenge	= 42*4,
};
for diff in ivalues(difficulties) do
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
        CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end;
        CurrentStepsP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end;
        CurrentTrailP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end;
        CurrentTrailP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end;            
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
        local bHasStepsTypeAndDifficulty = false;
        local curDiff;
        local steps;
            if song then
            local st = GAMESTATE:GetCurrentStyle():GetStepsType()
            if not GAMESTATE:IsCourseMode() then 
                bHasStepsTypeAndDifficulty = song:HasStepsTypeAndDifficulty( st, diff )
                steps = song:GetOneSteps( st, diff )
            else
                steps = GAMESTATE:GetCurrentTrail(player)
            end
                if steps then
                    c.Bar_meter:diffuse(CustomDifficultyToColor(diff)):visible(true)
                        if not GAMESTATE:IsCourseMode() then
                            c.Text_meter:settext(steps:GetMeter()):visible(true)
                        end
                    c.Text_difficulty:settext(THEME:GetString("CustomDifficulty",diff)):visible(true)
                    local cursteps = GAMESTATE:GetCurrentSteps(player) or GAMESTATE:GetCurrentTrail(player)
                    if steps:GetRadarValues(player):GetValue('RadarCategory_Mines') ~= 0 then
                        c.Img_important:visible(true)
                    else
                        c.Img_important:visible(false)
                    end                    
                        if cursteps then
                            curDiff = cursteps:GetDifficulty(player);
                            if ToEnumShortString(curDiff) == diff then
                                c.Bar_underlay:diffuse(CustomDifficultyToColor(diff))
                                c.Text_difficulty:diffuse(color("#ffffff"))
                                c.Text_score:diffuse(color("#ffffff"))
                                    if steps:GetRadarValues(player):GetValue('RadarCategory_Mines') ~= 0 then
                                        --c.Sound_shockarrows:play()
                                    else
                                        --c.Sound_shockarrows:stop()
                                    end
                            else
                                c.Bar_underlay:diffuse(color("#ffffff"))
                                c.Text_difficulty:diffuse(CustomDifficultyToColor(diff))
                                c.Text_score:diffuse(color("#000000"))
                                c.Sound_shockarrows:stop()
                            end
                        end
                        scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(song,steps)
                        local scores = scorelist:GetHighScores()
                        local topscore=0
                        if scores[1] then
                            topscore = scores[1]:GetScore()
                            topgrade = scores[1]:GetGrade()
                            fc = scores[1]:GetStageAward()
                        end
                        if topscore ~= 0  then
                        local scorel3 = topscore%1000
                        local scorel2 = (topscore/1000)%1000
                        local scorel1 = (topscore/1000000)%1000000
                            c.Text_score:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
                            c.Img_grade:visible(true)
                            c.Img_grade:Load(THEME:GetPathG("","_grade/"..topgrade))
                            if fc=="StageAward_FullComboW4" then
                                c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"])
                            elseif fc=="StageAward_FullComboW3" then
                                c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
                            elseif fc=="StageAward_FullComboW2" then
                                c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
                            elseif fc=="StageAward_FullComboW1" then
                                c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
                            else
                                c.Img_fc:visible(false)
                            end
                        else
                            c.Text_score:settext("")
                            c.Img_grade:visible(false)
                            c.Img_fc:visible(false)
                        end                            
                else
                    c.Bar_underlay:diffuse(color("#ffffff"))
                    c.Bar_meter:visible(false)
                    c.Text_meter:settext("")  
                    c.Text_difficulty:settext("")
                    c.Img_important:visible(false)
                    c.Text_score:settext("")
                    c.Img_grade:visible(false) 
                    c.Img_fc:visible(false)
                    c.Sound_shockarrows:stop()
                end
            else
                c.Bar_underlay:diffuse(color("#ffffff"))
                c.Bar_meter:visible(false)
                c.Text_meter:settext("")
                c.Text_difficulty:settext("")
                c.Img_important:visible(false)
                c.Text_score:settext("")
                c.Img_grade:visible(false)
                c.Img_fc:visible(false)
                c.Sound_shockarrows:stop()
            end
        end;
        OffCommand=function(self)
        local c = self:GetChildren();
            c.Sound_shockarrows:stop()
        end;
        Def.ActorFrame{
            Name="Bar_underlay";
            InitCommand=cmd(y,tLocation[diff]);
            Def.Quad{
                InitCommand=cmd(setsize,272,38;faderight,0.75;diffusealpha,0.15);      
            };
            Def.Quad{
                InitCommand=cmd(setsize,272,2;faderight,0.5;addy,-18;diffusealpha,0.5);      
            };
        };         
        Def.Quad{
            Name="Bar_meter";
            InitCommand=cmd(addx,-120;setsize,36,38;y,tLocation[diff]);                    
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
        LoadFont("Common Normal")..{
            Name="Text_score";
            Text="";
            InitCommand=cmd(addx,100;horizalign,right;zoom,0.8;y,tLocation[diff];diffuse,color("#000000"));
        };
        LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
            Name="Img_fc";
            InitCommand=cmd(y,tLocation[diff];zoom,0.35;addx,122;addy,-5;glowblink;effectperiod,0.2);
        };              
        Def.Sprite{
            Name="Img_grade";
            InitCommand=cmd(y,tLocation[diff];zoom,0.15;addx,116);
        };            
        LoadActor(THEME:GetPathG("","_important.png"))..{
            Name="Img_important";
            InitCommand=cmd(y,tLocation[diff];addy,-30;horizalign,left;zoom,0.3;diffuseshift;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0.5;effectclock,'beatnooffset');
            OnCommand=function(self)
                if player == PLAYER_1 then
                    self:addx(131);
                elseif player == PLAYER_2 then
                    self:addx(-131);
                    self:rotationy(180);
                end
            end;
        };
        LoadActor(THEME:GetPathS("","_shock arrow"))..{
            Name="Sound_shockarrows";
            SupportPan = true;
            InitCommand=cmd();
        };
};
end    
return t
end

local function CourseContents()
local t = Def.ActorFrame{};
t[#t+1] = Def.CourseContentsList{
    InitCommand=cmd(addy,84);
	MaxSongs = 20;
    NumItemsToDraw = 5;
	SetCommand=function(self)
		self:SetFromGameState();
		self:SetCurrentAndDestinationItem(2);
		self:SetPauseCountdownSeconds(1);
		self:SetSecondsPauseBetweenItems( 0.25 );
		self:SetTransformFromHeight(42);
		self:SetLoop(false);
		self:SetMask(280,42);     
        self:SetDestinationItem(math.max(2,self:GetNumItems()-4));
	end;
    CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
    SetSongCommand=cmd(playcommand,"Set");
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
    Display = Def.ActorFrame { 
		InitCommand=cmd(setsize,272,38);  
        Def.ActorFrame{
            Name="Bar_underlay";
            SetSongCommand=function(self,params)
                self:diffuse( CustomDifficultyToColor(params.Difficulty) );
            end;
            Def.Quad{
                InitCommand=cmd(setsize,272,38;faderight,0.75;diffusealpha,0.15);
            };
            Def.Quad{
                InitCommand=cmd(setsize,272,2;faderight,0.5;addy,-18;diffusealpha,0.5);      
            };
        };
        Def.Quad{
            Name="Bar_meter";
            InitCommand=cmd(addx,-120;setsize,36,38);
            SetSongCommand=function(self,params)
                self:diffuse(CustomDifficultyToColor(params.Difficulty))
            end;
        };
        LoadFont("Common Normal")..{
            Name="Text_meter";
            Text="";
            InitCommand=cmd(addx,-120;horizalign,center;zoom,0.8);
            SetSongCommand=function(self,params)
                self:settext(params.Meter)
            end;
        };
        LoadFont("Common Normal")..{
            Name="Text_song";
            Text="";
            InitCommand=cmd(addx,-90;horizalign,left;zoom,0.8;diffuse,color("#2e2e2e");maxwidth,272-42);
            SetSongCommand=function(self,params)
                if params.Song then
                    self:settext(params.Song:GetDisplayMainTitle())
                end
            end;
        };            
        
    };
};
return t;
end;

local function RivalsPanel(rival)
local t = Def.ActorFrame{};
local rivals = {1, 2, 3, 4, 5}    
for rival in ivalues(rivals) do
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end;
        CurrentStepsP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end;
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();
            if song then
            local steps = GAMESTATE:GetCurrentSteps(player) or GAMESTATE:GetCurrentTrail(player);
                if steps then
                    c.Bar_underlay:visible(true)
                    if rival == 1 then
                        c.Bar_place:diffuse(color("#3cbbf6"))
                    elseif rival == 2 then
                        c.Bar_place:diffuse(color("#d6d7d4"))
                    elseif rival == 3 then
                        c.Bar_place:diffuse(color("#f6cc40"))
                    else
                        c.Bar_place:diffuse(color("#f22133"))
                    end
                    local profile = PROFILEMAN:GetMachineProfile();
                    scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(song,steps)
                    local scores = scorelist:GetHighScores()
                    local topscore=0
                    if scores[rival] then
                        topscore = scores[rival]:GetScore()
                        topgrade = scores[rival]:GetGrade()
                        fc = scores[rival]:GetStageAward()
                    end
                    if topscore ~= 0  then
                        c.Bar_underlay:diffuse(color("#ffffff"))
                    local scorel3 = topscore%1000
                    local scorel2 = (topscore/1000)%1000
                    local scorel1 = (topscore/1000000)%1000000
                        c.Text_score:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
                            if scores[rival]:GetName() ~= nil then
                                if scores[rival]:GetName() == "" then
                                    c.Text_name:settext("NO NAME")
                                else
                                    c.Text_name:settext(scores[rival]:GetName())
                                end
                            else
                                c.Text_name:settext("STEP")
                            end
                        c.Img_grade:visible(true)
                        c.Img_grade:Load(THEME:GetPathG("","_grade/"..topgrade))
                        if fc=="StageAward_FullComboW4" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"])
                        elseif fc=="StageAward_FullComboW3" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
                        elseif fc=="StageAward_FullComboW2" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
                        elseif fc=="StageAward_FullComboW1" then
                            c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
                        else
                            c.Img_fc:visible(false)
                        end
                    else
                        c.Bar_underlay:diffuse(color("#eaeaea"))
                        c.Text_score:settext("")
                        c.Text_name:settext("")
                        c.Img_grade:visible(false)
                        c.Img_fc:visible(false)
                    end 
                end
            end
        end;
        Def.ActorFrame{
            Name="Bar_underlay";
            InitCommand=cmd(y,rivals[rival]*42-42);
            Def.Quad{
                InitCommand=cmd(setsize,272,38;faderight,0.75;diffusealpha,0.15);      
            };
            Def.Quad{
                InitCommand=cmd(setsize,272,2;faderight,0.5;addy,-18;diffusealpha,0.5);      
            };
        };            
        Def.Quad{
            Name="Bar_place";
            InitCommand=cmd(addx,-120;setsize,36,40;y,rivals[rival]*42-42);                    
        }; 
        LoadFont("Common Normal")..{
            Name="Text_place";
            Text=rival;
            InitCommand=cmd(addx,-120;zoom,0.8;diffuse,color("#ffffff");y,rivals[rival]*42-42);
        };           
        LoadFont("Common Normal")..{
            Name="Text_name";
            Text="";
            InitCommand=cmd(addx,-90;horizalign,left;zoom,0.8;diffuse,color("#000000");y,rivals[rival]*42-42);
        };
        LoadFont("Common Normal")..{
            Name="Text_score";
            Text="";
            InitCommand=cmd(addx,100;horizalign,right;zoom,0.8;diffuse,color("#000000");y,rivals[rival]*42-42);
        };
        LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
            Name="Img_fc";
            InitCommand=cmd(zoom,0.35;addx,122;addy,-5;glowblink;effectperiod,0.2;y,rivals[rival]*42-42);
        };              
        Def.Sprite{
            Name="Img_grade";
            InitCommand=cmd(zoom,0.15;addx,116;y,rivals[rival]*42-42);
        };            
};
end    
return t
end

--main info
local function PlayerInfo(player)
local t = Def.ActorFrame{};
t[#t+1] = PlayerPanel()..{
    InitCommand=cmd(vertalign,bottom);    
    };
return t
end;

--main scroller
local function Scroller(player)
local t = Def.ActorFrame{};
t[#t+1] = Def.HelpDisplay {
    File = THEME:GetPathF("HelpDisplay", "text");
    OnCommand=cmd(zoom,0.75;xy,-100/0.75,_screen.cy-52;wrapwidthpixels,320;horizalign,left);
    InitCommand=function(self)
    local s = THEME:GetString(Var "LoadingScreen","PanelText");
        self:SetTipsColonSeparated(s);
        self:SetSecsBetweenSwitches(4);
    end;
    SetHelpTextCommand=function(self, params)
        self:SetTipsColonSeparated( params.Text );
    end;
};
t[#t+1] = Def.ActorScroller{
	Name="ScrollerMain";
	NumItemsToDraw=1,
	SecondsPerItem=0.1,
	OnCommand=cmd(SetDestinationItem,0;SetFastCatchup,true;SetMask,320,20;fov,60;zwrite,true;ztest,true;draworder,8;z,8;playcommand,"CodeMessage");
	TransformFunction=function(self, offset, itemIndex, numItems)
		self:x(math.floor( offset*(10) ));
		self:diffusealpha(1-math.abs(offset));
    end;     
	CodeMessageCommand=function(self,params)
	local DI = self:GetCurrentItem();          
	if params.PlayerNumber == player then 
        if params.Name=="Left" then
            if DI>0 then 
                self:SetDestinationItem(DI-1) 
                SOUND:PlayOnce(THEME:GetPathS("","Pane Sound"))
            end
        end
        if params.Name=="Right" then 
            if DI<2 then 
                self:SetDestinationItem(DI+1) 
                SOUND:PlayOnce(THEME:GetPathS("","Pane Sound"))
            end
        end            
	end;
	end;
        
	-- difficulty
	Def.ActorFrame{
		Name="ScrollerItem1";
        Condition=not GAMESTATE:IsCourseMode();
		InitCommand=cmd();
        -- draworder hack
		DifficultyPanel()..{
		InitCommand=cmd(y,_screen.cy);
        };
	};
	-- groove radar
	Def.ActorFrame{
		Name="ScrollerItem2";
        Condition=not GAMESTATE:IsCourseMode();
		InitCommand=cmd();       
		StandardDecorationFromFileOptional( "GrooveRadarPane"..ToEnumShortString(player), "GrooveRadarPane"..ToEnumShortString(player))..{
		InitCommand=cmd(zoom,0.8;addy,65);
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(CenterY;diffuse,color("#2e2e2e");addy,60);
			SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
			local steps = GAMESTATE:GetCurrentSteps(player);
				if steps then
					self:settext(steps:GetMeter())
                else
                    self:settext("")
				end
            else
                self:settext("")
			end
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		};
	};
        
	-- coursecontents
	Def.ActorFrame{
		Name="ScrollerItem1";
        Condition=GAMESTATE:IsCourseMode();
		CourseContents()..{
		InitCommand=cmd(y,_screen.cy);
		};
	};
        
	-- difficulty
	Def.ActorFrame{
		Name="ScrollerItem2";
        Condition=GAMESTATE:IsCourseMode();
		InitCommand=cmd();
        -- draworder hack
		DifficultyPanel()..{
		InitCommand=cmd(y,_screen.cy);
        };
	};        
        
    -- scores
	Def.ActorFrame{
		Name="ScrollerItem3";
		RivalsPanel()..{
		InitCommand=cmd(y,_screen.cy);
		};
	};
};	
return t
end

local function DifficultySelect(player)
local t = Def.ActorFrame{};
local difficulties = {"Beginner","Easy","Medium","Hard","Challenge"--[[,"Edit"]]};
local tLocation = {
    Beginner	= 42*0,
    Easy 		= 42*1,
    Medium		= 42*2,
    Hard		= 42*3,
    Challenge	= 42*4,
    --Edit        = 42*5,
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
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
        local bHasStepsTypeAndDifficulty = false;
        local curDiff;
        local diff = diff;
            if song then
            local st = GAMESTATE:GetCurrentStyle():GetStepsType()
            if not GAMESTATE:IsCourseMode() then 
                bHasStepsTypeAndDifficulty = song:HasStepsTypeAndDifficulty( st, diff )
                steps = song:GetOneSteps( st, diff )
            else
                steps = GAMESTATE:GetCurrentTrail(player)
            end
                if steps then
                    c.Bar_meter:diffuse(CustomDifficultyToColor(diff)):visible(true)
                        if not GAMESTATE:IsCourseMode() then
                            c.Text_meter:settext(steps:GetMeter()):visible(true)
                        end
                    c.Text_difficulty:settext(THEME:GetString("CustomDifficulty",diff)):visible(true)
                    local cursteps = GAMESTATE:GetCurrentSteps(player) or GAMESTATE:GetCurrentTrail(player)
                    if steps:GetRadarValues(player):GetValue('RadarCategory_Mines') ~= 0 then
                        c.Img_important:visible(true)
                    else
                        c.Img_important:visible(false)
                    end                    
                            if cursteps then
                            curDiff = cursteps:GetDifficulty(player);
                            if ToEnumShortString(curDiff) == diff then
                                c.Bar_underlay:diffuse(CustomDifficultyToColor(diff))
                                c.Text_difficulty:diffuse(color("#ffffff"))
                                c.Frame_exp:visible(true)
                                c.Text_exp:settext(THEME:GetString("DifficultyExplanations",diff)):cropright(1):linear(.5):cropright(0)
                                    if steps:GetRadarValues(player):GetValue('RadarCategory_Mines') ~= 0 then
                                        --c.Sound_shockarrows:play()
                                    else
                                        --c.Sound_shockarrows:stop()
                                    end
                            else
                                c.Bar_underlay:diffuse(color("#ffffff"))
                                c.Text_difficulty:diffuse(CustomDifficultyToColor(diff))
                                c.Frame_exp:visible(false)
                                c.Text_exp:settext("")
                                c.Sound_shockarrows:stop()
                            end
                        end                           
                else
                    c.Bar_underlay:diffuse(color("#ffffff"))
                    c.Bar_meter:visible(false)
                    c.Text_meter:settext("")  
                    c.Text_difficulty:settext("")
                    c.Frame_exp:visible(false)
                    c.Text_exp:settext("")
                    c.Img_important:visible(false)
                    c.Sound_shockarrows:stop()
                end
            else
                c.Bar_underlay:diffuse(color("#ffffff"))
                c.Bar_meter:visible(false)
                c.Text_meter:settext("")
                c.Text_difficulty:settext("")
                c.Frame_exp:visible(false)
                c.Text_exp:settext("")
                c.Img_important:visible(false)
                c.Sound_shockarrows:stop()
            end
        end;
        OffCommand=function(self)
        local c = self:GetChildren();
            c.Sound_shockarrows:stop()
        end;
        Def.ActorFrame{
            Name="Bar_underlay";
            InitCommand=cmd(y,tLocation[diff]);
            Def.Quad{
                InitCommand=cmd(setsize,272,38;faderight,0.75;diffusealpha,0.15);      
            };
            Def.Quad{
                InitCommand=cmd(setsize,272,2;faderight,0.5;addy,-18;diffusealpha,0.5);      
            };
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
        LoadActor(THEME:GetPathG("","_important.png"))..{
            Name="Img_important";
            InitCommand=cmd(y,tLocation[diff];addy,-30;horizalign,left;zoom,0.3;diffuseshift;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0.5;effectclock,'beatnooffset');
            OnCommand=function(self)
                if player == PLAYER_1 then
                    self:addx(131);
                elseif player == PLAYER_2 then
                    self:addx(-131);
                    self:rotationy(180);
                end
            end;
        };
        LoadActor(THEME:GetPathS("","_shock arrow"))..{
            Name="Sound_shockarrows";
            SupportPan = true;
            InitCommand=cmd();
        };
        Def.Quad{
            Name="Frame_exp";
            InitCommand=cmd(y,142+20-10+3/0.75+250*0.75+2;setsize,200/0.75,66/0.75;diffuse,color("#000000");diffusealpha,0.15);
            SongChosenMessageCommand=cmd(zoomy,0;sleep,0.2;linear,0.2;zoomy,1);
            SongUnchosenMessageCommand=cmd(linear,0.2;zoomy,0);
            TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;zoomy,0);
        };
        LoadFont("Common Normal")..{
            Name="Text_exp";
            Text="";
            InitCommand=cmd(xy,-100/0.75+10,133/0.75+250*0.75+2-50;wrapwidthpixels,380;zoom,0.5/0.75;horizalign,left;vertalign,top);
            SongChosenMessageCommand=cmd(diffusealpha,0;sleep,0.2;linear,0.2;diffusealpha,1);              
        };
};
end
t[#t+1] = Def.HelpDisplay {
    File = THEME:GetPathF("HelpDisplay", "text");
    OnCommand=cmd(zoom,0.75;addy,-52;addx,-100/0.75;wrapwidthpixels,320;horizalign,left);
    InitCommand=function(self)
    local s = THEME:GetString(Var "LoadingScreen","DifficultyText");
        self:SetTipsColonSeparated(s);
        self:SetSecsBetweenSwitches(4);
    end;
    SetHelpTextCommand=function(self, params)
        self:SetTipsColonSeparated( params.Text );
    end;
};
return t
end

local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame{
    InitCommand=function(self)
            self:zoom(0.75)
            x_pos(self,0)
            self:CenterY();
    end;    
    commonpanel(310-20,SCREEN_HEIGHT/1.3-20,10,0.5,color("#f2f2f2"),PlayerColor(player));
    Def.Sprite{
        InitCommand=function(self)
            self:vertalign(top):horizalign(right)
                :scaletoclipped(38,38):xy(135,-(SCREEN_HEIGHT/1.3)*0.5+20)
                :Load(THEME:GetPathG("","_charicons/"..GetCharacter()))
        end;
        OnCommand=cmd(diffusealpha,0;sleep,1.9;linear,0.2;diffusealpha,1);
        OffCommand=cmd(linear,0.1;diffusealpha,0);
    };
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
        PlayerInfo(player)..{
            InitCommand=cmd(addy,90);
            SongChosenMessageCommand=cmd(linear,0.2;diffusealpha,0);
            SongUnchosenMessageCommand=cmd(linear,0.2;diffusealpha,1);
            TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;diffusealpha,1);
        };  
        Scroller(player)..{
            InitCommand=cmd(addy,-500);
            SongChosenMessageCommand=cmd(linear,0.2;diffusealpha,0);
            SongUnchosenMessageCommand=cmd(linear,0.2;diffusealpha,1);
            TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;diffusealpha,1);
        };            
        DifficultySelect(player)..{
            InitCommand=cmd(diffusealpha,0;y,_screen.cy-500);
            SongChosenMessageCommand=cmd(sleep,0.2;linear,0.2;diffusealpha,1);
            SongUnchosenMessageCommand=cmd(linear,0.2;diffusealpha,0);
            TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;diffusealpha,0);
        };
    };
};
return t