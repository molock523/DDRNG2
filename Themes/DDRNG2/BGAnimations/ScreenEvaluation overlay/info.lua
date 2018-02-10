local player = ...
local theme_config= theme_config:get_data()

local function x_pos(self,offset)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
		self:x(_screen.w/2+335+offset);
	end
end

local function PlayerPanel()
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
        local score = pss:GetScore();
        local grade = pss:GetGrade();
        local fc = pss:GetStageAward();
        local EXScore = LoadFile(ToEnumShortString(player).."_ex.txt","playerstats");
        local StageStars = LoadFile(ToEnumShortString(player).."_stars.txt","playerstats");         
            if song then
            local steps = GAMESTATE:GetCurrentSteps(player);
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
                        c.Img_grade:Load(THEME:GetPathG("","_grade/"..grade))  
                    else
                        c.Img_record:setstate(3):diffusealpha(0.5):diffuse(color("0.8,0.8,0.8,0.5"))
                    end
                    c.Bar_underlay:diffuse(PlayerColor(player))                    
                    c.Img_grade:visible(true)
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
                    c.Bar_judgments:diffusealpha(0.15)
                    c.Text_stepsdisplay:settext("")
                end
            end
        end;
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

local function ClearPanel()
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
            if song then
                    c.Img_graph:visible(true)
                if pss:GetGrade()=="Grade_Failed" then
                    c.Img_status:Load(THEME:GetPathG("","_failed"))
                else
                    c.Img_status:Load(THEME:GetPathG("","_cleared"))
                end
            end
        end;
		Def.GraphDisplay {
            Name="Img_graph";
			InitCommand=cmd(horizalign,left;addx,-272/2+10;vertalign,bottom;addy,170);
			OnCommand=function(self)
                self:Load("GraphDisplay")
                local playerStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
                local stageStats = STATSMAN:GetCurStageStats()
                self:Set(stageStats, playerStageStats)
			end;
		};       
        Def.Sprite{
            Name="Img_status";
            OnCommand=cmd(addy,60;diffusealpha,0;zoomx,0.4;zoomy,0.25;sleep,4;accelerate,0.2;zoom,0.4;diffusealpha,1);
        };       
};
return t
end

local function StatsPanel()
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
        local score = pss:GetScore();
        local grade = pss:GetGrade();
            if song then
                c.Img_grade:visible(true)
                c.Img_grade:Load(THEME:GetPathG("","_grade/"..grade))
                if score ~= 0 then
                    local scorel3 = score%1000
                    local scorel2 = (score/1000)%1000
                    local scorel1 = (score/1000000)%1000000
                    c.Text_score:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
                end
                if pss:FullComboOfScore('TapNoteScore_W1') then
                    c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
                    c.Img_combo:visible(true)
                    c.Img_combo:setstate(0)
                elseif pss:FullComboOfScore('TapNoteScore_W2') then
                    c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
                    c.Img_combo:visible(true)
                    c.Img_combo:setstate(1)                    
                elseif pss:FullComboOfScore('TapNoteScore_W3') then
                    c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
                    c.Img_combo:visible(true)
                    c.Img_combo:setstate(2)                    
                elseif pss:FullComboOfScore('TapNoteScore_W4') then
                    c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"]) 
                    c.Img_combo:visible(true)
                    c.Img_combo:setstate(3)                    
                else
                    c.Img_fc:visible(false)
                    c.Img_combo:visible(false)
                end
            else
                c.Img_combo:visible(false)
                c.Img_fc:visible(false)
                c.Img_grade:visible(false)
                c.Text_score:settext("")
            end
        end;        
        LoadActor(THEME:GetPathG("ScreenGameplay","ScoreFrame"..ToEnumShortString(player)))..{
            Name="Img_scoreframe";
            InitCommand=cmd(addy,160;cropleft,0.185;cropright,0.185);
        };
        LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
            Name="Img_fc";
            InitCommand=cmd(zoom,1;addx,50;glowblink;effectperiod,0.2);
        };              
        Def.Sprite{
            Name="Img_grade";
            InitCommand=cmd(zoom,1;addy,50);
        };
        LoadActor(THEME:GetPathG("","Player combo/splash"))..{
            Name="Img_combo";
            InitCommand=cmd(zoom,0.8;animate,false;addy,100;glowshift;effectperiod,0.2);
            OnCommand=cmd(diffusealpha,0;zoomy,0.5;zoomx,0.8;sleep,2;bounceend,0.2;zoom,0.8;diffusealpha,1);
        };        
        LoadFont("Common Normal")..{
            Name="Text_score";
            Text="";
            InitCommand=cmd(addy,160;horizalign,center;zoomx,1.6;diffuse,color("#ffffff"));
        };      
};
return t
end

local Target = player_config:get_data(player).Target

local graphheight = 150

local function GetMachinePersonalHighScores()
    local profile = PROFILEMAN:GetMachineProfile();
    
    if Target == "Local" or "World" then profile = PROFILEMAN:GetMachineProfile();
    elseif Target == "Personal" then profile = PROFILEMAN:GetProfile(player); end
    local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
    local diff = GAMESTATE:GetCurrentSteps(player):GetDifficulty()
    local steps = GAMESTATE:GetCurrentSteps(player);
    scorelist = profile:GetHighScoreList(song,steps);
    assert(scorelist);
    return scorelist:GetHighScores();
end;

local function TargetPanel()
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        AnimateTargetMessageCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
        local scores = GetMachinePersonalHighScores(player);
        local rscore;
            if scores[1] ~= nil then rscore = scores[1]:GetScore()
            else rscore = 0
        end
        local pscore = pss:GetScore() 
            if song then
                c.Bar_rback:visible(true)
                c.Bar_pback:visible(true)
                c.Bar_rfill:visible(true):zoomy(0):smooth(1):zoomy(1*(rscore/1000000))
                c.Bar_pfill:visible(true):zoomy(0):smooth(1):zoomy(1*(pscore/1000000)) 
            end
        end;
        LoadActor(THEME:GetPathG("GraphDisplay","backing"))..{
            Name="Img_bg";
            InitCommand=cmd(scaletoclipped,256,graphheight;vertalign,bottom;addy,170);
        };
        Def.Quad{
            Name="Bar_rback";
            InitCommand=cmd(setsize,10,graphheight;diffuse,color("#2e2e2e");diffusealpha,1;vertalign,bottom;horizalign,right;addx,-5;addy,170);
        };
        Def.Quad{
            Name="Bar_rfill";
            InitCommand=cmd(setsize,10,graphheight;diffuse,color("#3cbbf6");diffusealpha,1;vertalign,bottom;horizalign,right;addx,-5;addy,170);
        };
        Def.Quad{
            Name="Bar_pback";
            InitCommand=cmd(setsize,10,graphheight;diffuse,color("#2e2e2e");diffusealpha,1;vertalign,bottom;horizalign,left;addx,5;addy,170);
        }; 
        Def.Quad{
            Name="Bar_pfill";
            InitCommand=cmd(setsize,10,graphheight;diffuse,PlayerColor(player);diffusealpha,1;vertalign,bottom;horizalign,left;addx,5;addy,170);
        };
        Def.Quad{
            Name="Bar_target";
            InitCommand=cmd(setsize,272,40;shadowlengthy,1;shadowcolor,color("#eaeaea"));
        }; 
        LoadFont("Common Normal")..{
            Name="Text_target";
            Text="Target: "..Target;
            InitCommand=cmd(horizalign,left;addx,-120;zoom,0.8;diffuse,color("#2e2e2e"));
        };         
};
return t
end

local function CaloriesPanel()
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame{
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
        SetCommand=function(self)
        local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
        local stage = GAMESTATE:GetCurrentStageIndex();
        local stagecal = pss:GetCaloriesBurned();
        local totalcal = PROFILEMAN:GetProfile(player):GetTotalCaloriesBurned();
        local addcal = PROFILEMAN:GetProfile(player):GetCaloriesBurnedToday();
            if song then
                if not PROFILEMAN:IsPersistentProfile(player) then
                    c.Bar_stagecal:visible(true)
                    c.Text_stagetitle:visible(true)
                    c.Text_stagecal:settext(string.format("%01d",stagecal).."kcal")
                    c.Bar_addcal:visible(true)
                    c.Text_addtitle:visible(true)
                    c.Text_addcal:settext(string.format("%01d",addcal).."kcal")
                    c.Bar_totalcal:visible(false)
                    c.Text_totaltitle:visible(false)
                    c.Text_totalcal:settext("")
                    c.Img_cals:visible(true)
                    c.Bar_amountBG:visible(true)
                    c.Text_food:settext("")
                    
                else
                    c.Bar_stagecal:visible(true)
                    c.Text_stagetitle:visible(true)
                    c.Text_stagecal:settext(string.format("%01d",stagecal).."kcal")
                    c.Bar_addcal:visible(true)
                    c.Text_addtitle:visible(true)
                    c.Text_addcal:settext(string.format("%01d",addcal).."kcal")
                    c.Bar_totalcal:visible(true)
                    c.Text_totaltitle:visible(true)
                    c.Text_totalcal:settext(string.format("%01d",totalcal).."kcal")
                    c.Img_cals:visible(true)
                    c.Bar_amountBG:visible(true)
                    c.Text_food:settext("")
                end
                if totalcal >=0 and totalcal <=5 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/005"))
                    c.Bar_amountfill:zoomy(totalcal/5)
                    c.Text_food:settext("Peanuts")
                    c.Text_percent:settext(string.format("%01d",totalcal/5).."%")
                elseif totalcal >=5.05 and totalcal <=30 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/030"))
                    c.Bar_amountfill:zoomy(totalcal/30)
                    c.Text_food:settext("Orange")
                    c.Text_percent:settext(string.format("%01d",totalcal/30).."%")
                elseif totalcal >=30.05 and totalcal <=50 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/050"))
                    c.Bar_amountfill:zoomy(totalcal/50)
                    c.Text_food:settext("Grapes")
                    c.Text_percent:settext(string.format("%01d",totalcal/50).."%")
                elseif totalcal >=50.05 and totalcal <=60 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/060"))
                    c.Bar_amountfill:zoomy(totalcal/60)
                    c.Text_food:settext("Kiwi")
                    c.Text_percent:settext(string.format("%01d",totalcal/60).."%")
                elseif totalcal >=60.05 and totalcal <=70 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/070"))
                    c.Bar_amountfill:zoomy(totalcal/70)
                    c.Text_food:settext("Banana")
                    c.Text_percent:settext(string.format("%01d",totalcal/70).."%")
                elseif totalcal >=70.05 and totalcal <=85 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/085"))
                    c.Bar_amountfill:zoomy(totalcal/85)
                    c.Text_food:settext("Raw egg")
                    c.Text_percent:settext(string.format("%01d",totalcal/85).."%")
                elseif totalcal >=85.05 and totalcal <=100 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/100"))
                    c.Bar_amountfill:zoomy(totalcal/100)
                    c.Text_food:settext("Apple")
                    c.Text_percent:settext(string.format("%01d",totalcal/100).."%")
                elseif totalcal >=100.05 and totalcal <=120 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/120"))
                    c.Bar_amountfill:zoomy(totalcal/120)
                    c.Text_food:settext("Cow's milk 200g")
                    c.Text_percent:settext(string.format("%01d",totalcal/120).."%")
                elseif totalcal >=120.05 and totalcal <=150 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/150"))
                    c.Bar_amountfill:zoomy(totalcal/150)
                    c.Text_food:settext("Ume onigiri")
                    c.Text_percent:settext(string.format("%01d",totalcal/150).."%")
                elseif totalcal >=150.05 and totalcal <=200 then
                    c.Img_cals:Load(THEME:GetPathG("","_calories/200"))
                    c.Bar_amountfill:zoomy(totalcal/200)
                    c.Text_food:settext("Pudding")
                    c.Text_percent:settext(string.format("%01d",totalcal/200).."%")                    
                end                
            end
        end;
        Def.Quad{
            Name="Bar_stagecal";
            InitCommand=cmd(setsize,272,30;shadowlengthy,1;shadowcolor,color("#eaeaea");addy,100);
        };
        LoadFont("Common Normal")..{
            Name="Text_stagetitle";
            Text="Calories from song:";
            InitCommand=cmd(horizalign,left;addx,-120;zoom,0.7;diffuse,color("#000000");addy,100);
        };        
        LoadFont("Common Normal")..{
            Name="Text_stagecal";
            Text="";
            InitCommand=cmd(horizalign,right;addx,120;zoom,0.7;diffuse,color("#000000");addy,100);
        };
        Def.Quad{
            Name="Bar_addcal";
            InitCommand=cmd(setsize,272,30;shadowlengthy,1;shadowcolor,color("#eaeaea");addy,32+100);
        };
        LoadFont("Common Normal")..{
            Name="Text_addtitle";
            Text="Calories so far:";
            InitCommand=cmd(horizalign,left;addx,-120;zoom,0.7;diffuse,color("#000000");addy,32+100);
        };        
        LoadFont("Common Normal")..{
            Name="Text_addcal";
            Text="";
            InitCommand=cmd(horizalign,right;addx,120;zoom,0.7;diffuse,color("#000000");addy,32+100);
        };
        Def.Quad{
            Name="Bar_totalcal";
            InitCommand=cmd(setsize,272,30;shadowlengthy,1;shadowcolor,color("#eaeaea");addy,32*2+100);
        }; 
        LoadFont("Common Normal")..{
            Name="Text_totaltitle";
            Text="Total Calories:";
            InitCommand=cmd(horizalign,left;addx,-120;zoom,0.7;diffuse,color("#000000");addy,32*2+100);
        };         
        LoadFont("Common Normal")..{
            Name="Text_totalcal";
            Text="";
            InitCommand=cmd(horizalign,right;addx,120;zoom,0.7;diffuse,color("#000000");addy,32*2+100);
        };  
        Def.Sprite{
            Name="Img_cals";
            InitCommand=cmd(horizalign,left;addx,-100;zoom,0.4);
        };
        LoadFont("Common Normal")..{
            Name="Text_food";
            Text="";
            InitCommand=cmd(horizalign,left;vertalign,bottom;addx,-120;zoom,0.6;diffuse,color("#000000");addy,70);
        };
        LoadFont("Common Large Normal")..{
            Name="Text_percent";
            Text="";
            InitCommand=cmd(horizalign,right;vertalign,bottom;addx,110;zoom,0.6;diffuse,color("#000000");addy,60);
        };        
        Def.Quad{
            Name="Bar_amountBG";
            InitCommand=cmd(horizalign,right;vertalign,bottom;addy,80-2;addx,272/2;setsize,12,120;diffuse,color("#eaeaea"));
        };
        Def.Quad{
            Name="Bar_amountfill";
            InitCommand=cmd(horizalign,right;vertalign,bottom;addy,80-2;addx,272/2;setsize,12,120;diffuse,color("#ffff00");zoomy,0);
        };        
};
return t
end

local function RivalsPanel(rival)
local t = Def.ActorFrame{};
local rivals = {1, 2, 3, 4, 5}    
for rival in ivalues(rivals) do
t[#t+1] = Def.ActorFrame {
        InitCommand=cmd(playcommand,"Set");
        OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
		local c = self:GetChildren();
        local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
            if song then
            local steps = GAMESTATE:GetCurrentSteps(player);
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
                                c.Text_name:settext(scores[rival]:GetName())
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
                InitCommand=cmd(setsize,272,2;faderight,0.5;addy,-23;diffusealpha,0.5);      
            };
        };
        Def.Quad{
            Name="Bar_place";
            InitCommand=cmd(addx,-120;setsize,36,40;y,rivals[rival]*42-42-9);                    
        }; 
        LoadFont("Common Normal")..{
            Name="Text_place";
            Text=rival;
            InitCommand=cmd(addx,-120;zoom,0.8;diffuse,color("#ffffff");y,rivals[rival]*42-42-9);
        };           
        LoadFont("Common Normal")..{
            Name="Text_name";
            Text="";
            InitCommand=cmd(addx,-90;horizalign,left;zoom,0.8;diffuse,color("#000000");y,rivals[rival]*42-42-9);
        };
        LoadFont("Common Normal")..{
            Name="Text_score";
            Text="";
            InitCommand=cmd(addx,100;horizalign,right;zoom,0.8;diffuse,color("#000000");y,rivals[rival]*42-42-9);
        };
        LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
            Name="Img_fc";
            InitCommand=cmd(zoom,0.35;addx,122;addy,-5;glowblink;effectperiod,0.2;y,rivals[rival]*42-42-9);
        };              
        Def.Sprite{
            Name="Img_grade";
            InitCommand=cmd(zoom,0.15;addx,116;y,rivals[rival]*42-42-9);
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
    OnCommand=cmd(y,_screen.cy;zoom,0.75;addy,-52;addx,-100/0.75;wrapwidthpixels,320;horizalign,left);
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
	SecondsPerItem=0.0001,
	OnCommand=cmd(SetDestinationItem,0;SetFastCatchup,true;SetMask,320,20;fov,60;zwrite,true;ztest,true;draworder,1;z,10;playcommand,"CodeMessage");
	TransformFunction=function(self, offset, itemIndex, numItems)
		self:x(math.floor( offset*(30) ));
		self:diffusealpha(1-math.abs(offset));
    end;
	CodeMessageCommand=function(self,params)
	local DI = self:GetCurrentItem();          
	if params.PlayerNumber == player then 
        if params.Name=="Left" then
            if DI>0 then 
                DI = DI-1
                self:SetDestinationItem(DI) 
                SOUND:PlayOnce(THEME:GetPathS("","Pane Sound"))
            end
        end
        if params.Name=="Right" then 
            if DI<4 then 
                DI = DI+1
                self:SetDestinationItem(DI) 
                SOUND:PlayOnce(THEME:GetPathS("","Pane Sound"))
            end
        end
        if DI==2 then MESSAGEMAN:Broadcast("AnimateTarget") end
	end;
	end;
	
	-- Clear
	Def.ActorFrame{
		Name="ScrollerItem1";
		InitCommand=cmd();
		ClearPanel()..{
		InitCommand=cmd(y,_screen.cy);
        };
	};
	-- Score/Grade
	Def.ActorFrame{
		Name="ScrollerItem2";
		InitCommand=cmd();
		StatsPanel()..{
		InitCommand=cmd(y,_screen.cy);
        };
	};        
	-- Target
	Def.ActorFrame{
		Name="ScrollerItem3";
		TargetPanel()..{
		InitCommand=cmd(y,_screen.cy);
		};
	}; 
	-- Calories
	Def.ActorFrame{
		Name="ScrollerItem4";
		InitCommand=cmd();
		CaloriesPanel()..{
		InitCommand=cmd(y,_screen.cy);
        };
	};        
	-- Rivals
	Def.ActorFrame{
		Name="ScrollerItem5";
		RivalsPanel()..{
		InitCommand=cmd(y,_screen.cy);
		};
	};
};	   
return t
end

local t = Def.ActorFrame{
    OffCommand=function(self)
        WriteFile(ToEnumShortString(player).."_ex.txt","0","playerstats")        
    end;
};
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
        PlayerInfo(player)..{InitCommand=cmd(addy,90);};
        Scroller(player)..{InitCommand=cmd(addy,-500);};
    };
};
return t