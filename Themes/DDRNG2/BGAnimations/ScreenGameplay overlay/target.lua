local player = ...
local ts = {0,0};

local TargetScore_JudgeCmdsPlayer = {
	TapNoteScore_W1 = THEME:GetMetric( "Judgment", "TargetScore_default_JudgmentW1Command" );
	TapNoteScore_W2 = THEME:GetMetric( "Judgment", "TargetScore_default_JudgmentW2Command" );
	TapNoteScore_W3 = THEME:GetMetric( "Judgment", "TargetScore_default_JudgmentW3Command" );
	TapNoteScore_W4 = THEME:GetMetric( "Judgment", "TargetScore_default_JudgmentW4Command" );
	TapNoteScore_W5 = THEME:GetMetric( "Judgment", "TargetScore_default_JudgmentW5Command" );
	TapNoteScore_Miss = THEME:GetMetric( "Judgment", "TargetScore_default_JudgmentMissCommand" );
};

local t = Def.ActorFrame {};

-- Load HighScore List
local function GetMachinePersonalHighScores()
    local profile = PROFILEMAN:GetMachineProfile();
    
    if player_config:get_data(pn).Target == "Local" or "World" then profile = PROFILEMAN:GetMachineProfile();
    elseif player_config:get_data(pn).Target == "Personal" then profile = PROFILEMAN:GetProfile(player); end
    
    local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse()
    local steps = GAMESTATE:GetCurrentSteps(player) or GAMESTATE:GetCurrentTrail(player)
    local diff = steps:GetDifficulty()    
    scorelist = profile:GetHighScoreList(song,steps);
    assert(scorelist);
    return scorelist:GetHighScores();
end;

local p=((player == PLAYER_1) and 1 or 2);

local steps = GAMESTATE:GetCurrentSteps(player) or GAMESTATE:GetCurrentTrail(player)
local rv = steps:GetRadarValues(player);
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
local maxsteps = math.max(rv:GetValue('RadarCategory_TapsAndHolds')
+rv:GetValue('RadarCategory_Holds')+rv:GetValue('RadarCategory_Rolls'),1);

local scores = GetMachinePersonalHighScores(player);
assert(scores);
local topscore=0;
if scores[1] then
    for i = 1, #scores do
        if scores[i] then
            local topscore2 = GetNormalScore(maxsteps,scores[i],player);
            if topscore2 > topscore then
                topscore = topscore2;
            end;
        else
            break;
        end;
    end;
end;
assert(topscore);

local moto = topscore/maxsteps;
setenv("TopScoreSave"..ToEnumShortString(player),topscore);

t[#t+1] = Def.ActorFrame {
        LifeChangedMessageCommand=function(self,params)
            if params.Player ~= player then return end;
            if params.LivesLeft == 0 then
                self:visible(false);
            else
                self:visible(true);
            end;
        end;
        Def.BitmapText{
        Font="Common Bold", Text="";
        InitCommand=function(self)
            self:xy(THEME:GetMetric(Var "LoadingScreen","Player"..ToEnumShortString(player).."MiscX")+30,_screen.cy-40)
                :zoom(0.8):horizalign(left):strokecolor(color("#000000")):shadowlength(2)
        end;
        JudgmentMessageCommand=function(self,params)
            if params.Player ~= player then return end;
            if params.HoldNoteScore then 
                self:visible(false);
            else
                self:visible(true);
            end;
            self:finishtweening();
            if params.TapNoteScore and
               params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and
               params.TapNoteScore ~= 'TapNoteScore_HitMine' and
               params.TapNoteScore ~= 'TapNoteScore_CheckpointMiss' and
               params.TapNoteScore ~= 'TapNoteScore_CheckpointHit' and
               params.TapNoteScore ~= 'TapNoteScore_None'
            then
                local ret=0;
                local w1=pss:GetTapNoteScores('TapNoteScore_W1');
                local w2=pss:GetTapNoteScores('TapNoteScore_W2');
                local w3=pss:GetTapNoteScores('TapNoteScore_W3');
                local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
                if params.HoldNoteScore=='HoldNoteScore_Held' then
                    hd=hd+1;
                elseif params.TapNoteScore=='TapNoteScore_W1' then
                    w1=w1+1;
                elseif params.TapNoteScore=='TapNoteScore_W2' then
                    w2=w2+1;
                elseif params.TapNoteScore=='TapNoteScore_W3' then
                    w3=w3+1;
                end;
                ret = w1*3 + w2*2 + w3;
                ts[p] = ts[p] + moto
                local last = math.round(ret-ts[p]);
                if last > 0 then
                    self:diffuse(color("#8a97ee")):strokecolor(Color.Black):settext("+"..last)
                elseif last < 0 then
                    self:diffuse(color("#ff89b1")):strokecolor(Color.Black):settext(last)
                else
                    self:diffuse(color("#ffffff")):strokecolor(Color.Black):settext("0")
                end;
            end;
        end;
    };
};
return t;
