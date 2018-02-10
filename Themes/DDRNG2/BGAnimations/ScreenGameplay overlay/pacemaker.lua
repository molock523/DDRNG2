local player = ...

local grades= {
    "AAA",
    "AA",
    "A",
};

local tierheight= {
    0.99,
    0.89,
    0.79,
};

local graphheight = (SCREEN_HEIGHT/1.3)*0.75

local Target = player_config:get_data(player).Target

-- Load HighScore List
local function GetMachinePersonalHighScores()
    local profile = PROFILEMAN:GetMachineProfile();
    
    if Target == "Local" or "World" then profile = PROFILEMAN:GetMachineProfile();
    elseif Target == "Personal" then profile = PROFILEMAN:GetProfile(player); end
    local song = GAMESTATE:GetCurrentSong()
    local diff = GAMESTATE:GetCurrentSteps(player):GetDifficulty()
    local steps = GAMESTATE:GetCurrentSteps(player);
    scorelist = profile:GetHighScoreList(song,steps);
    assert(scorelist);
    return scorelist:GetHighScores();
end;

local t = Def.ActorFrame {
    InitCommand=cmd(xy,GameplayPlacement.PacemakerX(player),_screen.cy)
};

t[#t+1] = Def.ActorFrame{
    InitCommand=function(self)
    end;
    Def.Quad{
        InitCommand=cmd(setsize,100,_screen.h;diffuse,color("#eaeaea"));
        OnCommand=function(self)
            if player == PLAYER_1 then
                self:faderight(1);
            elseif player == PLAYER_2 then
                self:fadeleft(1);
            end
        end;
    };
    Def.Quad{
        InitCommand=cmd(setsize,10,graphheight;diffuse,color("#2e2e2e");diffusealpha,1);
    };
    Def.Quad{
        InitCommand=cmd(setsize,10,graphheight;diffuse,PlayerColor(player);vertalign,bottom;xy,0,graphheight/2;zoomy,0);
        JudgmentMessageCommand=function(self)
            if player ~= nil then
			local steps = GAMESTATE:GetCurrentSteps(player)
			if steps then
				local TotalSteps = steps:GetRadarValues(player):GetValue('RadarCategory_TapsAndHolds')
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
                local score = pss:GetScore()                 
				local data = pss:GetTapNoteScores('TapNoteScore_W1') + pss:GetTapNoteScores('TapNoteScore_W2')
						   + pss:GetTapNoteScores('TapNoteScore_W3') + pss:GetTapNoteScores('TapNoteScore_W4')
						   + pss:GetTapNoteScores('TapNoteScore_W5');
				self:linear(0.025):zoomy(1*(score/1000000))
			end
            end
        end;
    };
    -- rival
    Def.ActorFrame{
        InitCommand=function(self)
            if Target=="Off" or nil then self:visible(false) else self:visible(true) end 
            if player==PLAYER_1 then self:addx(-15)
            elseif player==PLAYER_2 then self:addx(15)
            end
        end;
        LoadActor(THEME:GetPathG("","_rival/_rival"))..{
            InitCommand=cmd(addy,graphheight/2+14;animate,false;zoom,0.6);
            OnCommand=function(self)
                if Target=="Personal" then self:setstate(0):visible(true)
                elseif Target=="Local" then self:setstate(1):visible(true)
                elseif Target=="World" then self:setstate(2):visible(true)
                else self:visible(false)
                end
            end;
        };
        Def.Quad{
            InitCommand=cmd(setsize,10,graphheight;diffuse,color("#2e2e2e");diffusealpha,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,10,graphheight;diffuse,color("#3cbbf6");vertalign,bottom;xy,0,graphheight/2;zoomy,0);
            JudgmentMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            local sec = GAMESTATE:GetSongPosition():GetMusicSeconds()
                if player ~= nil then
                local scores = GetMachinePersonalHighScores(player);
                    if scores[1] ~= nil then
                        self:setsize(10,graphheight-(sec/graphheight))
                        self:zoomy(1*(scores[1]:GetScore()/1000000))
                    end
                end
            end;
        };  
    };
};   
for i=1,#grades do
t[#t+1] = Def.ActorFrame{      
    LoadFont("Common Normal")..{
        InitCommand=cmd(xy,0,graphheight*0.5;vertalign,top;zoom,0.75);
        OnCommand=function(self)
            if player==PLAYER_1 then self:addx(-5):horizalign(left):settext("__"..grades[i]):addy(-tierheight[i]*graphheight)
            elseif player==PLAYER_2 then self:addx(5):horizalign(right):settext(grades[i].."__"):addy(-tierheight[i]*graphheight)
            end
        end;
    };
};
end;
return t;
