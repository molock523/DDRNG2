local iPN = ...;
assert(iPN,"[Graphics/PaneDisplay text.lua] No PlayerNumber Provided.");

local t = Def.ActorFrame {};
local function GetRadarData( pnPlayer, rcRadarCategory )
	local tRadarValues;
	local StepsOrTrail;
	local fDesiredValue = 0;
	if GAMESTATE:GetCurrentSteps( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentSteps( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	elseif GAMESTATE:GetCurrentTrail( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentTrail( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	else
		StepsOrTrail = nil;
	end;
	return fDesiredValue;
end;

local function CreatePaneDisplayItem( _pnPlayer, _sLabel, _rcRadarCategory )
	return Def.ActorFrame {
		LoadFont("Common Bold") .. {
			Text=string.upper( THEME:GetString("PaneDisplay",_sLabel) );
			InitCommand=cmd(horizalign,left;addx,-48);
			OnCommand=cmd(zoom,0.5875);
		};
		LoadFont("Common Bold") .. {
			Text="0";
			InitCommand=cmd(x,48;horizalign,right);
			OnCommand=cmd(zoom,0.5875);
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				if not song and not course then
					self:settext(0);
				else
					self:settext(GetRadarData( _pnPlayer, _rcRadarCategory ));
				end
			end;
		};
	};
end;

local function CreateShockArrow(_pnPlayer, _sLabel, _rcRadarCategory )
	return Def.ActorFrame {
		Def.Sprite{
			OnCommand=cmd(playcommand,"Set");
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				local selection = GAMESTATE:GetCurrentSteps(_pnPlayer);
				if GAMESTATE:IsCourseMode() then
						self:stoptweening();
						self:decelerate(0.2);
						self:zoom(0);
				else
					if selection then
						if GetRadarData( _pnPlayer, _rcRadarCategory) ==0 or not song and not course then
							self:stoptweening();
							self:zoom(1);
							self:diffusealpha(0.7);
							self:Load(THEME:GetPathG("","_shockarrowoff"));
						else
							self:stoptweening();
							self:zoom(1);
							self:diffusealpha(1);
							self:Load(THEME:GetPathG("","_shockarrowon"));
						end;
					end;
				end;
			end;	
		};
	};
end;

--[[ Numbers ]]
t[#t+1] = Def.ActorFrame { 
    InitCommand=cmd(y,-8);
	CreatePaneDisplayItem( iPN, "Taps", 'RadarCategory_TapsAndHolds' ) .. {
		InitCommand=cmd(x,-90;y,110);
	};
	CreatePaneDisplayItem( iPN, "Jumps", 'RadarCategory_Jumps' ) .. {
		InitCommand=cmd(x,-90;y,110+17);
	};
	CreatePaneDisplayItem( iPN, "Holds", 'RadarCategory_Holds' ) .. {
		InitCommand=cmd(x,-90;y,110+17*2);
	};
	CreatePaneDisplayItem( iPN, "Mines", 'RadarCategory_Mines' ) .. {
		InitCommand=cmd(x,90;y,110+17);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
            if GetRadarData( iPN, 'RadarCategory_Mines') ==0 then
                self:diffuse(color("#ffffff"))
            else
                self:diffuse(color("#ff0000"))
            end
        end;
	};
	CreatePaneDisplayItem( iPN, "Rolls", 'RadarCategory_Rolls' ) .. {
		InitCommand=cmd(x,90;y,110+17*2);
        CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
        CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");        
        SetCommand=function(self)
            if GetRadarData( iPN, 'RadarCategory_Rolls') ==0 then
                self:diffuse(color("#ffffff"))
            else
                self:diffuse(color("#ff0000"))
            end
        end;        
	};    
	CreateShockArrow( iPN, "Mines", 'RadarCategory_Mines' ) .. {
		InitCommand=cmd(x,0;y,110+17;zoom,0.8);
	};  
};
return t;