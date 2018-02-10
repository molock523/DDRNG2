local player = ...

local function x_pos(self,offset)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
		self:x(_screen.w/2+335+offset);
	end
end

local function StageStatsPanel(Stage)
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
		local c = self:GetChildren();
        local pss = STATSMAN:GetPlayedStageStats(Stage):GetPlayerStageStats(player);
        local song = STATSMAN:GetPlayedStageStats(Stage):GetPlayedSongs()[1];
        local score = pss:GetScore();
        local grade = pss:GetGrade();
        local fc = pss:GetStageAward();
        local EXScore = LoadFile(ToEnumShortString(player).."_ex.txt","playerstats");
        local StageStars = LoadFile(ToEnumShortString(player).."_stars.txt","playerstats");       
        local steps = pss:GetPlayedSteps()[Stage];
        if song then
                if song:GetJacketPath()~=nil then
                    c.Img_jacket:Load(song:GetJacketPath())
                elseif song:GetBackgroundPath()~=nil then
                    c.Img_jacket:Load(song:GetBackgroundPath())
                else
                    c.Img_jacket:Load(THEME:GetPathG("","Common fallback jacket"))
                end
                c.Text_songtitle:settext(song:GetDisplayFullTitle())
                c.Text_songartist:settext(song:GetDisplayArtist())
                if steps then
                local diff = steps:GetDifficulty();
                    c.Img_stagestar:visible(true)
                    c.Text_stagestar:settext(StageStars)
                    c.Text_exdisplay:settext("EX: "..EXScore)
                    c.Text_stepsdisplay:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff))):diffuse(CustomDifficultyToColor(diff)):uppercase(true)
                    c.Bar_underlay:visible(true)
                    scorelist = PROFILEMAN:GetProfile(player):GetHighScoreList(song,steps)
                    local scores = scorelist:GetHighScores()
                    local scorel3 = score%1000
                    local scorel2 = (score/1000)%1000
                    local scorel1 = (score/1000000)%1000000
                    c.Text_score:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
                    c.Text_name:settext(PROFILEMAN:GetProfile(player):GetDisplayName())
                    if scores[1]~=nil and scores[2]~=nil and scores[3]~=nil then
                        if score < scores[3]:GetScore() then
                            c.Img_record:setstate(3):diffusealpha(0.5):diffuse(color("0.8,0.8,0.8,0.5"))
                        elseif score < scores[2]:GetScore() and score > scores[3]:GetScore() then
                            c.Img_record:setstate(2)
                        elseif score < scores[1]:GetScore() and score > scores[2]:GetScore() then
                            c.Img_record:setstate(1)
                        elseif score > scores[1]:GetScore() then
                            c.Img_record:setstate(0)                        
                        end
                    else
                        c.Img_record:setstate(3):diffusealpha(0.5):diffuse(color("0.8,0.8,0.8,0.5"))
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
                    c.Bar_judgments:diffusealpha(1);
                    c.Text_judgments:settext(pss:GetTapNoteScores("TapNoteScore_W1").."\n"
                    ..pss:GetTapNoteScores("TapNoteScore_W2").."\n"
                    ..pss:GetTapNoteScores("TapNoteScore_W3").."\n"
                    ..pss:GetTapNoteScores("TapNoteScore_W4").."\n"
                    ..pss:GetHoldNoteScores("HoldNoteScore_Held").."\n"
                    ..pss:GetTapNoteScores("TapNoteScore_W5")+pss:GetTapNoteScores("TapNoteScore_Miss"))
                else
                    c.Bar_underlay:diffuse(color("#eaeaea"))
                    c.Text_score:settext("0,000,000")
                    c.Text_name:settext("- - - - - -")
                    c.Img_grade:visible(false)
                    c.Img_fc:visible(false)
                    c.Text_judgments:settext("0\n0\n0\n0\n0\n0")
                    c.Bar_judgments:diffusealpha(0.5)
                    c.Text_stepsdisplay:settext("")
                end
            end
        end;
        Def.Banner{
            Name="Img_jacket";
            InitCommand=cmd(scaletoclipped,200,200;addy,-50;vertalign,bottom);
        };
        LoadFont("Common Bold")..{
            Name="Text_songtitle";
            Text="";
            InitCommand=cmd(horizalign,left;vertalign,top;zoom,1);
        };
        LoadFont("Common Bold")..{
            Name="Text_songartist";
            Text="";
            InitCommand=cmd(horizalign,left;vertalign,top;zoom,0.5;addy,30);
        };        
        Def.Quad{
            Name="Bar_underlay";
            InitCommand=cmd(setsize,272,40;shadowlengthy,1;shadowcolor,color("#eaeaea"));
        }; 
        LoadActor(THEME:GetPathG("","_record"))..{
            Name="Img_record";
            InitCommand=cmd(addx,-120;horizalign,left;animate,false;zoom,0.75;setstate,0);
        };           
        LoadFont("Common Normal")..{
            Name="Text_name";
            Text="";
            InitCommand=cmd(addx,-90+6;horizalign,left;zoom,0.8;diffuse,color("#000000"));
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
        LoadActor(THEME:GetPathG("ScreenGameplay","InfoFrame"))..{
            Name="Img_infoframe";
            InitCommand=cmd(zoom,0.8;vertalign,bottom;addy,-19;cropright,0.125);
            OnCommand=function(self)
                if player == PLAYER_1 then
                    self:horizalign(left):addx(-272/2)
                elseif player == PLAYER_2 then
                    self:horizalign(left):addx(272/2):rotationy(180)
                end
            end;
        };
        LoadFont("Common Normal")..{
            Name="Text_stepsdisplay";
            Text="";
            InitCommand=cmd(zoom,0.655;vertalign,bottom;addy,-24);
            OnCommand=function(self)
                if player == PLAYER_1 then
                    self:horizalign(left):addx(-272/2+17)
                elseif player == PLAYER_2 then
                    self:horizalign(right):addx(272/2-17)
                end
            end;
        };
        LoadFont("Common Normal")..{
            Name="Text_exdisplay";
            Text="";
            InitCommand=cmd(zoom,0.655;vertalign,bottom;addy,-23);
            OnCommand=function(self)
                if player == PLAYER_1 then
                    self:horizalign(right):addx(100)
                elseif player == PLAYER_2 then
                    self:horizalign(left):addx(-120)
                end
            end;
        };
        LoadActor(THEME:GetPathG("","_stagestar"))..{
            Name="Img_stagestar";
            InitCommand=cmd(zoom,0.3;addx,-120;addy,190);
        };
        LoadFont("Common Normal")..{
            Name="Text_stagestar";
            Text="";
            InitCommand=cmd(zoom,0.655;horizalign,left;addy,190;addx,-120+20;diffuse,color("#000000"));
        };        
};   
return t
end

local function TotalStatsPanel()
local mStages = STATSMAN:GetStagesPlayed();
local i = 0;
local t = Def.ActorFrame{};
for i = 1, mStages do
	local SStats = STATSMAN:GetPlayedStageStats(i);
    local song = SStats:GetPlayedSongs()[1];
    local diff = SStats:GetPlayerStageStats(player):GetPlayedSteps()[1]:GetDifficulty()
    if not song then return end;
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,(mStages-i)*90);
		OnCommand=function(self)
            self:addy(-40);
		end;
        Def.Quad{
        InitCommand=cmd(setsize,272,58;diffuse,color("#ffffff");shadowlengthy,1);        
        };
        LoadActor(THEME:GetPathG("ScreenGameplay","InfoFrame"))..{
            InitCommand=cmd(zoom,0.8;vertalign,bottom;addy,-19-10;cropright,0.13);
            OnCommand=function(self)
                if player == PLAYER_1 then
                    self:horizalign(left):addx(-272/2)
                elseif player == PLAYER_2 then
                    self:horizalign(left):addx(272/2):rotationy(180)
                end
            end;
        };
        LoadFont("Common Normal")..{
            InitCommand=cmd(zoom,0.655;vertalign,bottom;addy,-24-10);
            OnCommand=function(self)
                if player == PLAYER_1 then
                    self:horizalign(left):addx(-272/2+17)
                elseif player == PLAYER_2 then
                    self:horizalign(right):addx(272/2-17)
                end
                self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff))):diffuse(CustomDifficultyToColor(diff)):uppercase(true)
            end;
        };            
        Def.Banner{
        InitCommand=cmd(scaletoclipped,54,54;horizalign,right;addx,-272/2+54);
        OnCommand=function(self)
            if song:GetJacketPath()~=nil then
                self:Load(song:GetJacketPath())
            elseif song:GetBackgroundPath()~=nil then
                self:Load(song:GetBackgroundPath())
            else
                self:Load(THEME:GetPathG("","Common fallback jacket"))
            end
        end;
        };
        LoadFont("Common Normal")..{
        InitCommand=cmd(horizalign,left;vertalign,top;addx,-272/2+54+5;addy,-20;diffuse,color("#2e2e2e");zoom,0.7;maxwidth,270);
        OnCommand=function(self)
            self:settext(song:GetDisplayFullTitle())
        end;
        };
        LoadFont("Common Normal")..{
        InitCommand=cmd(horizalign,right;vertalign,bottom;addx,272/2-54-20+20+20;addy,20;diffuse,color("#2e2e2e");zoom,0.8);
        OnCommand=function(self)
            local score = SStats:GetPlayerStageStats(player):GetScore()
            local scorel3 = score%1000
            local scorel2 = (score/1000)%1000
            local scorel1 = (score/1000000)%1000000
            self:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
        end;
        };
        Def.Sprite{
        InitCommand=cmd(vertalign,bottom;addx,272/2-54+20+20-8;addy,22;zoom,0.13);
        OnCommand=function(self)
            local grade = SStats:GetPlayerStageStats(player):GetGrade()
            self:Load(THEME:GetPathG("","_grade/"..topgrade))           
        end;
        };
        LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
        InitCommand=cmd(zoom,0.35;addx,272/2-45+20+20+20+5-20;addy,10;glowblink;effectperiod,0.2);
        OnCommand=function(self)
            local fc = SStats:GetPlayerStageStats(player):GetStageAward()
            if fc=="StageAward_FullComboW4" then
                self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"])
            elseif fc=="StageAward_FullComboW3" then
                self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
            elseif fc=="StageAward_FullComboW2" then
                self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
            elseif fc=="StageAward_FullComboW1" then
                self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
            else
                self:visible(false)
            end            
        end;
        };            
    };
end;
return t
end

--main scroller
local function Scroller(player)
local t = Def.ActorFrame{};

t[#t+1] = Def.ActorScroller{
	Name="ScrollerMain";
	NumItemsToDraw=1,
	SecondsPerItem=0.0001,
	OnCommand=cmd(SetDestinationItem,0;SetFastCatchup,true;SetMask,320,20;fov,60;zwrite,true;ztest,true;draworder,1;z,10;playcommand,"CodeMessage");
	TransformFunction=function(self, offset, itemIndex, numItems)
		self:x(math.floor( offset*(30) ));
		self:diffusealpha(1-math.abs(offset));
    end;
    KP1MessageCommand=cmd(SetDestinationItem,0);
    KP2MessageCommand=cmd(SetDestinationItem,1);
    KP3MessageCommand=cmd(SetDestinationItem,2);
    KP4MessageCommand=cmd(SetDestinationItem,3);
    KP5MessageCommand=cmd(SetDestinationItem,4);
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
    Def.ActorFrame{Name="ScrollerItem1";StageStatsPanel(1)..{
    Condition=STATSMAN:GetStagesPlayed()<=1 and PROFILEMAN:IsPersistentProfile(player)            
    };
    };
    Def.ActorFrame{Name="ScrollerItem2";StageStatsPanel(2)..{
    Condition=STATSMAN:GetStagesPlayed()<=2 and PROFILEMAN:IsPersistentProfile(player)             
    };
    };
    Def.ActorFrame{Name="ScrollerItem3";StageStatsPanel(3)..{
    Condition=STATSMAN:GetStagesPlayed()<=3 and PROFILEMAN:IsPersistentProfile(player)             
    };
    };
    Def.ActorFrame{Name="ScrollerItem4";StageStatsPanel(4)..{
    Condition=STATSMAN:GetStagesPlayed()<=4 and PROFILEMAN:IsPersistentProfile(player)             
    };
    };
    Def.ActorFrame{Name="ScrollerItem5";StageStatsPanel(5)..{
    Condition=STATSMAN:GetStagesPlayed()<=5 and PROFILEMAN:IsPersistentProfile(player)             
    };
    };
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
        InitCommand=cmd(addy,-120);
            OnCommand=cmd(diffusealpha,0;sleep,1.9;linear,0.2;diffusealpha,1);
            OffCommand=cmd(linear,0.2;diffusealpha,0);
        TotalStatsPanel();
        --Scroller(player)..{Condition=PROFILEMAN:IsPersistentProfile(player); InitCommand=cmd(addy,90);};
    };
};
return t