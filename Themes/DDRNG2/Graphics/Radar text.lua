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

local function CreatePaneDisplayGraph( _pnPlayer, _sLabel, _rcRadarCategory )
	return Def.ActorFrame {
		LoadFont("Common Normal") .. {
			InitCommand=cmd(zoom,0.8;horizalign,center;x,30);
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
					self:settext(_sLabel.."")
				else
					self:settextf("%0.0f",GetRadarData( _pnPlayer, _rcRadarCategory )*100);
				end
			end;
		};
	};
end;

--[[ Numbers ]]
t[#t+1] = Def.ActorFrame {
	--percentage stuff for groove radar
	CreatePaneDisplayGraph( iPN, "S", 'RadarCategory_Stream' ) .. {
		InitCommand=cmd(x,-32+1;y,-112+5+4+2+1);
	};
	CreatePaneDisplayGraph( iPN, "V", 'RadarCategory_Voltage' ) .. {
		InitCommand=cmd(x,-142+3+1+2;y,-50+5+4+1+1);
	};
	CreatePaneDisplayGraph( iPN, "A", 'RadarCategory_Air' ) .. {
		InitCommand=cmd(x,-112+3+2;y,52+4+4+1);
	};
	CreatePaneDisplayGraph( iPN, "F", 'RadarCategory_Freeze' ) .. {
		InitCommand=cmd(x,49-3-1;y,52+4+4);
	};
	CreatePaneDisplayGraph( iPN, "C", 'RadarCategory_Chaos' ) .. {
		InitCommand=cmd(x,78-3;y,-50+5+4+1);
	};
};
return t;