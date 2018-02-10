function SelectMusicOrCourse()
	if IsNetSMOnline() then
		return "ScreenNetSelectMusic"
	elseif GAMESTATE:IsCourseMode() then
		return "ScreenSelectCourse"
	else
		return "ScreenSelectMusic"
	end
end

Branch={
    -- Machine type pref
	Init = function()
        if ConsoleType() ~= nil then
            return "ScreenWarning"
        else
            return "ScreenSetConsoleType"
        end
	end,
    AfterInit = function()
        return Branch.TitleMenu()
    end,
	Network = function()
		return IsNetConnected() and "ScreenTitleMenu" or "ScreenTitleMenu"
    end,
    AfterStart = function()
        if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
            return "ScreenSelectProfile"
        else
            return "ScreenUSBEntry"
        end
    end,   
    AfterUSBEntry = function()
        if PROFILEMAN:GetNumLocalProfiles() >= 1 and ShowSelectProfile() == true then
            return "ScreenSelectProfile"
        else
            return "ScreenCaution"
        end
    end,
    -- E-Amuse-style
	AfterProfile = function()
		if GetPrevScreenName() == "ScreenWarning" or
           GetPrevScreenName() == "ScreenCompany" or
           GetPrevScreenName() == "ScreenMovie" or            
           GetPrevScreenName() == "ScreenLogo" or            
           GetPrevScreenName() == "ScreenDemonstration" then
			return Branch.TitleMenu()
		else
			return "ScreenCaution"
		end
	end,    
	TitleMenu = function()
		if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
			return "ScreenTitleMenu"
		end
		-- arcade junk:
		if GAMESTATE:GetCoinsNeededToJoin() > GAMESTATE:GetCoins() then
			return "ScreenLogo"
		else
			return "ScreenTitleJoin"
		end
	end,
	OptionsEdit = function()
		-- Similar to above, don't let anyone in here with 0 songs.
		if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
			return "ScreenHowToInstallSongs"
		end
		return "ScreenEditMenu"
	end,     
	AfterTitleMenu = function()
        return Branch.StartGame()
	end,   
    StartGame = function()
        return "ScreenUSBEntry"
    end,
    AfterSelectProfile = function()
        if PROFILEMAN:IsPersistentProfile(GAMESTATE:GetMasterPlayerNumber()) then
            return "ScreenNestyProfileCustomize"
        else
            return "ScreenCaution"
        end
    end,
    AfterSMOLogin = function()
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		if not IsSMOnlineLoggedIn(pn) then
			return "ScreenSMOnlineLogin"
		end
	end
    return "ScreenNetRoom"
    end,
    AfterSelectMusic = function()
		if SCREENMAN:GetTopScreen():GetGoToOptions() then
			return SelectFirstOptionsScreen()
		else
			return "ScreenStageInformation"
		end
	end,
	PlayerOptions = function()
		if SCREENMAN:GetTopScreen():GetGoToOptions() then
			return "ScreenNestyPlayerOptions"
		else
			return "ScreenStageInformation"
		end
	end,
	SongOptions = function()
		if SCREENMAN:GetTopScreen():GetGoToOptions() then
			return "ScreenSongOptions"
		else
			return "ScreenStageInformation"
		end
	end,
	GameplayScreen = function()
		return "ScreenGameplay"
	end,   
    BackOutOfStageInformation = function()
        return SelectMusicOrCourse()
    end,
	EvaluationScreen= function()
		if IsNetSMOnline() then
			return "ScreenNetEvaluation"
		else
			return "ScreenEvaluationNormal"
		end
	end,    
    AfterEvaluation = function()
		if GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() >= 1 then
			return "ScreenSelectMusic"
		elseif GAMESTATE:GetCurrentStage() == "Stage_Extra1" or GAMESTATE:GetCurrentStage() == "Stage_Extra2" then
			return "ScreenEvaluationSummary"
		elseif STATSMAN:GetCurStageStats():AllFailed() then
			return "ScreenProfileSaveSummary"
		elseif GAMESTATE:IsCourseMode() then
			return "ScreenProfileSaveSummary"
		else
			return "ScreenEvaluationSummary"
		end
	end,
	AfterSummary = function()
		return "ScreenProfileSaveSummary"
	end,
 	AfterSaveSummary = function()
 		return "ScreenGameOver"
	end,    
}