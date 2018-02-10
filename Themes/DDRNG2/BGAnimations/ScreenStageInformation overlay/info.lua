local player = ...
local song = GAMESTATE:GetCurrentSong();

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
                    local scorel3 = topscore%1000
                    local scorel2 = (topscore/1000)%1000
                    local scorel1 = (topscore/1000000)%1000000
                        c.Text_score:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
                            if scores[1]:GetName() ~= nil then
                                if scores[1]:GetName() == "" then
                                    c.Text_name:settext("NO NAME")
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

local function RivalsPanel(rival)
local t = Def.ActorFrame{};
local rivals = {1, 2, 3}    
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
                    local profile = PROFILEMAN:GetMachineProfile();                        
                    c.Bar_underlay:visible(true)
                    if rival == 1 then
                        profile = PROFILEMAN:GetProfile(player);                 
                        c.Img_place:setstate(0);                            
                    elseif rival == 2 then
                        profile = PROFILEMAN:GetMachineProfile(); 
                        c.Img_place:setstate(1);  
                    elseif rival == 3 then
                        profile = PROFILEMAN:GetMachineProfile(); 
                        c.Img_place:setstate(2);  
                    end
                    scorelist = profile:GetHighScoreList(song,steps)
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
                                if scores[1]:GetName() == "" then
                                    c.Text_name:settext("NO NAME")
                                else
                                    c.Text_name:settext(scores[1]:GetName())
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
            InitCommand=cmd(addx,-120;setsize,36,40;y,rivals[rival]*42-42;shadowlengthx,1;shadowcolor,color("#eaeaea"));                    
        };             
        LoadActor(THEME:GetPathG("","_rival/_rival"))..{
            Name="Img_place";
            InitCommand=cmd(addx,-120;zoom,0.8;y,rivals[rival]*42-42;diffuse,color("#2e2e2e");animate,false);
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

local profile;
if PROFILEMAN:IsPersistentProfile(player) then 
    profile = PROFILEMAN:GetProfile(player)
else 
    profile = PROFILEMAN:GetMachineProfile()
end
local scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse(),GAMESTATE:GetCurrentSteps(player) or GAMESTATE:GetCurrentTrail(player))
local scores = scorelist:GetHighScores()
if scores[1] ~= nil then
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
                Condition=PROFILEMAN:IsPersistentProfile(player);
                InitCommand=cmd(addy,90);
                SongChosenMessageCommand=cmd(linear,0.2;diffusealpha,0);
                SongUnchosenMessageCommand=cmd(linear,0.2;diffusealpha,1);
                TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;diffusealpha,1);
            };  
            RivalsPanel(player)..{
                InitCommand=cmd(y,_screen.cy-500);
                SongChosenMessageCommand=cmd(linear,0.2;diffusealpha,0);
                SongUnchosenMessageCommand=cmd(linear,0.2;diffusealpha,1);
                TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;diffusealpha,1);
            };            
        };
    };
    return t
end