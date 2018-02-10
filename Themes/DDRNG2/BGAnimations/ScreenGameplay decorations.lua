local t = Def.ActorFrame{}
t[#t+1] = StandardDecorationFromFileOptional("ScoreFrameP1","ScoreFrameP1");
t[#t+1] = StandardDecorationFromFileOptional("ScoreFrameP2","ScoreFrameP2");
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
t[#t+1] = Def.Actor{
    Name="ScoringController",
    JudgmentMessageCommand = function(_,params)
        if not (( ScoringInfo[params.Player]) and
            (ScoringInfo.seed == GAMESTATE:GetStageSeed())) then
            SN2Scoring.PrepareScoringInfo()
            ScoringInfo.seed = GAMESTATE:GetStageSeed()
        end
        local stage = GAMESTATE:IsCourseMode() and GAMESTATE:GetCourseSongIndex() + 1 or nil
        local info = ScoringInfo[params.Player]
        if params.HoldNoteScore then
            info.AddHoldScore(params.HoldNoteScore, stage)
        else
            info.AddTapScore(params.TapNoteScore, stage)
        end
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player)
        pss:SetScore(info.GetCurrentScore())
        pss:SetCurMaxScore(info.GetCurrentMaxScore())
        local es = (GAMESTATE:Env()).EndlessState
        if es then
            es.scoring.handleNoteScore(params.HoldNoteScore or params.TapNoteScore,
                GAMESTATE:GetCurrentStageIndex()+1,
                pss:GetCurrentCombo())
        end
    end,
}
return t
