local pn = ...;
assert(pn);
local t = Def.ActorFrame{};
local Center1Player = PREFSMAN:GetPreference('Center1Player');
local NumPlayers = GAMESTATE:GetNumPlayersEnabled();
local NumSides = GAMESTATE:GetNumSidesJoined();
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
local st = GAMESTATE:GetCurrentStyle():GetStepsType();

local function GetPosition(pn)
	if st == "StepsType_Dance_Double" or st == "StepsType_Dance_Solo" or Center1Player then return SCREEN_WIDTH/2;
	else
    if pn == PLAYER_1 then
        if st == "StepsType_Dance_Single" then return THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")+30;
        end
    elseif pn == PLAYER_2 then
        if st == "StepsType_Dance_Single" then return THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")-30;
        end
    end
end;
end;

local function GradationWidth()
	if st == "StepsType_Dance_Double" then return (2);
	elseif st == "StepsType_Dance_Solo" then return (1.5);
	else return (1);
	end;
end;

local function DownGradationWidth()
	if st == "StepsType_Dance_Double" then return (SCREEN_WIDTH);
	elseif st == "StepsType_Dance_Solo" then return (384);
	else return (256);
	end;
end;

local function TextZoom()
	if st == "StepsType_Dance_Double" then return (1.61);
	elseif st == "StepsType_Dance_Solo" then return (1.3);
	else return (1);
	end;
end;

-- FullComboColor base from Default Extended by A.C
local function GetFullComboEffectColor(pss)
	local r;
		if pss:FullComboOfScore('TapNoteScore_W1') == true then
			r=color("#ffffff");
		elseif pss:FullComboOfScore('TapNoteScore_W2') == true then
			r=color("#fafc44");
		elseif pss:FullComboOfScore('TapNoteScore_W3') == true then
			r=color("#06fd32");
		elseif pss:FullComboOfScore('TapNoteScore_W4') == true then
			r=color("#3399ff");
		end;
	return r;
end;

-- FullComboColor2 Ring
local function GetFullComboEffectColor2(pss)
	local r;
		if pss:FullComboOfScore('TapNoteScore_W1') == true then
			r=color("#fefed0");
		elseif pss:FullComboOfScore('TapNoteScore_W2') == true then
			r=color("#f8fd6d");
		elseif pss:FullComboOfScore('TapNoteScore_W3') == true then
			r=color("#01e603");
		elseif pss:FullComboOfScore('TapNoteScore_W4') == true then
			r=color("#3399ff");
		end;
	return r;
end;

-- Sound
t[#t+1] = LoadActor("Combo_Splash") .. {
	OffCommand=function(self)
		if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
			self:play();
		end;
	end;
};

-- Parts
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,GetPosition(pn);diffusealpha,0);
	OffCommand = function(self)
		if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
			self:diffuse(GetFullComboEffectColor(pss));
		end;
	end;

	-- Note flash star
	Def.ActorFrame{
		InitCommand=function(self)
			if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
				self:y(SCREEN_CENTER_Y);
				self:addy(SCREEN_HEIGHT/4);
			else
				self:y(SCREEN_CENTER_Y);
				self:addy(-SCREEN_HEIGHT/4);
			end;
			self:diffusealpha(1);
		end;
		-- Left - down in single
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(-48);
					self:rotationz(-25);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(65);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(155);
				end;
			end;
		};
		-- Right - up in single
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(48);
					self:rotationz(35);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(-55);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(-145);
				end;
			end;
		};
		-- Left2 - left in single
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(-144);
					self:rotationz(-60);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(30);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(120);
				end;
			end;
		};
		-- Right2 - right in single
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(144);
					self:rotationz(90);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(0);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(-90);
				end;
			end;
		};
		-- Left3 Solo and Double
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(-240);
					self:rotationz(-15);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(75);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(165);
				end;
			end;
			Condition=st == "StepsType_Dance_Double" or st == "StepsType_Dance_Solo";
		};
		-- Right3 Solo and Double
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(240);
					self:rotationz(90);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(0);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(-90);
				end;
			end;
			Condition=st == "StepsType_Dance_Double" or st == "StepsType_Dance_Solo";
		};
		-- Left4 Double
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(-336);
					self:rotationz(-60);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(30);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(120);
				end;
			end;
			Condition=st == "StepsType_Dance_Double";
		};
		-- Right4 Double
		LoadActor("Star") .. {
			InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,1);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(1);
					self:addx(336);
					self:rotationz(35);
					self:zoom(2);
					self:linear(0.5);
					self:zoom(0.3);
					self:rotationz(-55);
					self:linear(0.25);
					self:zoom(0);
					self:rotationz(-145);
				end;
			end;
			Condition=st == "StepsType_Dance_Double";
		};
	};
	
	-- Up gradation
	LoadActor("Down") .. {
		InitCommand=cmd(vertalign,bottom);
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
					self:y(SCREEN_BOTTOM);
					self:diffusealpha(0.5);
					self:zoomx(GradationWidth());
					self:zoomy(1);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(GradationWidth()+0.25);
					self:zoomy(2);
					self:linear(0.25);
					self:zoomx(GradationWidth());
					self:zoomy(1.5);
					self:diffusealpha(0);
				else
					self:y(SCREEN_TOP);
					self:diffusealpha(0.5);
					self:zoomx(GradationWidth());
					self:zoomy(-1);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(GradationWidth()+0.25);
					self:zoomy(-2);
					self:linear(0.25);
					self:zoomx(GradationWidth());
					self:zoomy(-1.5);
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	
	-- Slim light
	Def.ActorFrame{
		InitCommand=function(self)
			if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
				self:y(SCREEN_CENTER_Y+SCREEN_HEIGHT/4);
			else
				self:y(SCREEN_CENTER_Y-SCREEN_HEIGHT/4);
			end;
		end;
		-- Center
		LoadActor("Slim") .. {
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(0.5);
					self:zoomx(0);
					self:zoomy(0.5);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(1);
					self:zoomy(1.75);
					self:linear(0.25);
					self:zoomx(0);
					self:zoomy(0.5);
					self:diffusealpha(0);
				end;
			end;
		};
		-- Left
		LoadActor("Slim") .. {
			InitCommand=cmd(addx,-64);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(0.5);
					self:zoomx(0);
					self:zoomy(0.5);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(1);
					self:zoomy(1.75);
					self:linear(0.25);
					self:zoomx(0);
					self:zoomy(0.5);
					self:diffusealpha(0);
				end;
			end;
		};
		-- Right
		LoadActor("Slim") .. {
			InitCommand=cmd(addx,64);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(0.5);
					self:zoomx(0);
					self:zoomy(0.5);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(1);
					self:zoomy(1.75);
					self:linear(0.25);
					self:zoomx(0);
					self:zoomy(0.5);
					self:diffusealpha(0);
				end;
			end;
		};
		-- Solo and Double left
		LoadActor("Slim") .. {
			InitCommand=cmd(addx,-128);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(0.5);
					self:zoomx(0);
					self:zoomy(0.5);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(1);
					self:zoomy(1.75);
					self:linear(0.25);
					self:zoomx(0);
					self:zoomy(0.5);
					self:diffusealpha(0);
				end;
			end;
			Condition=st == "StepsType_Dance_Double" or st == "StepsType_Dance_Solo";
		};
		-- Solo and Double right
		LoadActor("Slim") .. {
			InitCommand=cmd(addx,128);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(0.5);
					self:zoomx(0);
					self:zoomy(0.5);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(1);
					self:zoomy(1.75);
					self:linear(0.25);
					self:zoomx(0);
					self:zoomy(0.5);
					self:diffusealpha(0);
				end;
			end;
			Condition=st == "StepsType_Dance_Double" or st == "StepsType_Dance_Solo";
		};
		-- Double left
		LoadActor("Slim") .. {
			InitCommand=cmd(addx,-192);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(0.5);
					self:zoomx(0);
					self:zoomy(0.5);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(1);
					self:zoomy(1.75);
					self:linear(0.25);
					self:zoomx(0);
					self:zoomy(0.5);
					self:diffusealpha(0);
				end;
			end;
			Condition=st == "StepsType_Dance_Double";
		};
		-- Double right
		LoadActor("Slim") .. {
			InitCommand=cmd(addx,192);
			OffCommand=function(self)
				if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
					self:diffusealpha(0.5);
					self:zoomx(0);
					self:zoomy(0.5);
					self:linear(0.25);
					self:diffusealpha(0.25);
					self:zoomx(1);
					self:zoomy(1.75);
					self:linear(0.25);
					self:zoomx(0);
					self:zoomy(0.5);
					self:diffusealpha(0);
				end;
			end;
			Condition=st == "StepsType_Dance_Double";
		};
	};
	
	-- Star
	LoadActor("Star") .. {
		InitCommand=cmd(blend,Blend.Add);
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
					self:y(SCREEN_CENTER_Y+SCREEN_HEIGHT/4+40);
					self:diffusealpha(1);
					self:zoomx(0);
					self:linear(0.1);
					self:zoomx(4);
					self:zoomy(1);
					self:linear(0.12);
					self:zoomx(1);
					self:addy(-120);
					self:linear(0.36);
					self:addy(-720);
				else
					self:y(SCREEN_CENTER_Y-SCREEN_HEIGHT/4-40);
					self:diffusealpha(1);
					self:zoomx(0);
					self:linear(0.1);
					self:zoomx(4);
					self:zoomy(1);
					self:linear(0.12);
					self:zoomx(1);
					self:addy(120);
					self:linear(0.36);
					self:addy(720);
				end;
			end;
		end;
	};

	-- Down gradation
	LoadActor("Down") .. {
		InitCommand=cmd(vertalign,bottom);
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
					self:y(SCREEN_TOP);
					self:diffusealpha(0);
					self:sleep(0.48);
					self:diffusealpha(0.5);
					self:zoomto(64,0);
					self:linear(0.5);
					self:zoomto(DownGradationWidth()+52,-480);
					self:linear(0.3);
					self:diffusealpha(0);
					self:zoomto(DownGradationWidth(),-480);
				else
					self:y(SCREEN_BOTTOM);
					self:diffusealpha(0);
					self:sleep(0.48);
					self:diffusealpha(0.5);
					self:zoomto(64,0);
					self:linear(0.5);
					self:zoomto(DownGradationWidth()+52,480);
					self:linear(0.3);
					self:diffusealpha(0);
					self:zoomto(DownGradationWidth(),480);
				end;
			end;
		end;
	};

	-- Left gradation
	LoadActor("Gradation") .. {
		InitCommand=cmd(vertalign,top;horizalign,right);
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
					self:y(SCREEN_BOTTOM);
					self:addx(46);
					self:zoomx(0.75);
					self:zoomy(-0.5);
					self:diffusealpha(0);
					self:sleep(0.24);
					self:diffusealpha(1);
					self:linear(0.24);
					self:zoomy(-1);
					
					self:linear(0.5);
					self:zoomx(1);
					self:addx(-14);
					self:linear(0.1);
					self:addx(-28);
					self:linear(0.2);
					self:addx(-GradationWidth()*128-64);
					self:diffusealpha(0);
				else
					self:y(SCREEN_TOP);
					self:addx(46);
					self:zoomx(0.75);
					self:zoomy(0.5);
					self:diffusealpha(0);
					self:sleep(0.24);
					self:diffusealpha(1);
					self:linear(0.24);
					self:zoomy(1);
					
					self:linear(0.5);
					self:zoomx(1);
					self:addx(-14);
					self:linear(0.1);
					self:addx(-28);
					self:linear(0.2);
					self:addx(-GradationWidth()*128-64);
					self:diffusealpha(0);
				end;
			end;
		end;
	};
	
	-- Right gradation
	LoadActor("Gradation") .. {
		InitCommand=cmd(vertalign,top;horizalign,right);
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
					self:y(SCREEN_BOTTOM);
					self:addx(-46);
					self:zoomx(-0.75);
					self:zoomy(-0.5);
					self:diffusealpha(0);
					self:sleep(0.24);
					self:diffusealpha(1);
					self:linear(0.24);
					self:zoomy(-1);
					
					self:linear(0.5);
					self:zoomx(-1);
					self:addx(14);
					self:linear(0.1);
					self:addx(28);
					self:linear(0.2);
					self:addx(GradationWidth()*128+64);
					self:diffusealpha(0);
				else
					self:y(SCREEN_TOP);
					self:addx(-46);
					self:zoomx(-0.75);
					self:zoomy(0.5);
					self:diffusealpha(0);
					self:sleep(0.24);
					self:diffusealpha(1);
					self:linear(0.24);
					self:zoomy(1);
					
					self:linear(0.5);
					self:zoomx(-1);
					self:addx(14);
					self:linear(0.1);
					self:addx(28);
					self:linear(0.2);
					self:addx(GradationWidth()*128+64);
					self:diffusealpha(0);
				end;
			end;
		end;
	};

	-- Double only left gradation2
	LoadActor("Gradation") .. {
		InitCommand=cmd(horizalign,right);
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				self:y(SCREEN_CENTER_Y);
				self:addx(46);
				self:diffusealpha(0);
				self:zoomx(0.75);
				self:sleep(0.98);
				self:linear(0.1);
				self:diffusealpha(1);
				self:zoomx(1);
				self:addx(-14);
				self:linear(0.1);
				self:addx(-28);
				self:linear(0.2);
				self:addx(-GradationWidth()*128-64);
				self:diffusealpha(0);
			end;
		end;
		Condition=st == "StepsType_Dance_Double";
	};

	-- Double only right gradation2
	LoadActor("Gradation") .. {
		InitCommand=cmd(horizalign,right);
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				self:y(SCREEN_CENTER_Y);
				self:addx(-46);
				self:diffusealpha(0);
				self:zoomx(-0.75);
				self:sleep(0.98);
				self:linear(0.1);
				self:diffusealpha(1);
				self:zoomx(-1);
				self:addx(14);
				self:linear(0.1);
				self:addx(28);
				self:linear(0.2);
				self:addx(GradationWidth()*128+64);
				self:diffusealpha(0);
			end;
		end;
		Condition=st == "StepsType_Dance_Double";
	};

	-- Ring star
	LoadActor( "Star" ) .. {
		InitCommand=function(self)
			self:zoom(0);
			self:blend(Blend.Add);
			if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
				self:y(SCREEN_CENTER_Y+57);
			else
				self:y(SCREEN_CENTER_Y-65);
			end;
		end;
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				self:sleep(0.65);
				self:diffusealpha(1);
				self:zoomx(2);
				self:zoomy(0);
				self:linear(0.1);
				self:zoomy(2);
				self:rotationz(0);
				self:linear(0.5);
				self:zoom(1.2);
				self:diffusealpha(0.4);
				self:rotationz(90);
				self:linear(0.05);
				self:diffusealpha(0);
			end;
		end;
	};

	-- Ring star highlight
	LoadActor( "SStar" ) .. {
		InitCommand=function(self)
			self:zoom(0);
			self:blend("BlendMode_Add");
			if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
				self:y(SCREEN_CENTER_Y+57);
			else
				self:y(SCREEN_CENTER_Y-65);
			end;
		end;
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				self:diffuse(color("#ffffff"));
				self:sleep(0.65);
				self:diffusealpha(0.8);
				self:zoomx(2);
				self:zoomy(0);
				self:linear(0.1);
				self:zoomy(2);
				self:rotationz(0);
				self:linear(0.5);
				self:zoom(1.2);
				self:rotationz(90);
				self:diffusealpha(0.4);
				self:linear(0.05);
				self:diffusealpha(0);
			end;
		end;
	};
	
	
	-- Ring
	LoadActor( "Fullcombo01" ) .. {
		InitCommand=function(self)
			self:zoom(0);
			if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
				self:y(SCREEN_CENTER_Y+57);
			else
				self:y(SCREEN_CENTER_Y-65);
			end;
		end;
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				self:diffuse(GetFullComboEffectColor2(pss));
				self:sleep(0.65);
				self:zoomx(2);
				self:zoomy(0);
				self:linear(0.1);
				self:zoomy(2);
				self:rotationz(0);
				self:linear(0.5);
				self:zoom(1.2);
				self:rotationz(90);
				self:linear(0.15);
				self:zoomy(0);
				self:zoomx(0.5);
				self:diffusealpha(0);
			end;
		end;
	};
	
	-- Ring bar
	LoadActor( "Fullcombo02" ) .. {
		InitCommand=function(self)
			self:zoom(0);
			if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
				self:y(SCREEN_CENTER_Y+57);
			else
				self:y(SCREEN_CENTER_Y-65);
			end;
		end;
		OffCommand=function(self)
			if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
				self:diffuse(GetFullComboEffectColor2(pss));
				self:sleep(0.65);
				self:zoomx(4);
				self:zoomy(0);
				self:linear(0.1);
				self:zoomy(4);
				self:rotationz(0);
				self:linear(0.5);
				self:zoom(1.25);
				self:rotationz(-90);
				self:linear(0.15);
				self:zoomy(0);
				self:zoomx(0.5);
				self:diffusealpha(0);
			end;
		end;
	};
	
};

-- Star highlight
t[#t+1] = LoadActor("SStar") .. {
	InitCommand=cmd(x,GetPosition(pn);diffusealpha,0;blend,Blend.Add);
	OffCommand=function(self)
		if pss:FullCombo() or pss:FullComboOfScore('TapNoteScore_W4') then
			if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
				self:y(SCREEN_CENTER_Y+SCREEN_HEIGHT/4);
				self:diffusealpha(0.95);
				self:zoomx(0);
				self:linear(0.1);
				self:zoomx(4);
				self:zoomy(1);
				self:linear(0.12);
				self:zoomx(1);
				self:addy(-120);
				self:linear(0.36);
				self:addy(-720);
			else
				self:y(SCREEN_CENTER_Y-SCREEN_HEIGHT/4);
				self:diffusealpha(0.95);
				self:zoomx(0);
				self:linear(0.1);
				self:zoomx(4);
				self:zoomy(1);
				self:linear(0.12);
				self:zoomx(1);
				self:addy(120);
				self:linear(0.36);
				self:addy(720);
			end;
		end;
	end;
};

-- FullCombo text pictures
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		if GAMESTATE:PlayerIsUsingModifier(pn,'reverse') then
			self:y(SCREEN_CENTER_Y+57);
		else
			self:y(SCREEN_CENTER_Y-76);
		end;
		self:x(GetPosition(pn));
	end;

	-- FullCombo
	LoadActor(THEME:GetPathG("","Player combo/splash"))..{
        InitCommand=cmd(animate,false;visible,false);
		OffCommand=function(self)
            self:visible(true)
			if pss:FullComboOfScore('TapNoteScore_W1') then
				self:setstate(0);
			elseif pss:FullComboOfScore('TapNoteScore_W2') then
				self:setstate(1);
			elseif pss:FullComboOfScore('TapNoteScore_W3') then
				self:setstate(2);
			elseif pss:FullComboOfScore('TapNoteScore_W4') then
				self:setstate(3);
			else
				self:visible(false);
			end;
            self:diffusealpha(0):sleep(0.6):diffusealpha(1):zoomy(0):zoomx(0.5):bounceend(0.5):zoom(1):decelerate(1):zoom(0.95):bouncebegin(0.2):zoomy(0):zoomx(0.75):diffusealpha(0);            
		end;
	};
    -- BlendForPrettiness
	LoadActor(THEME:GetPathG("","Player combo/splash"))..{
        InitCommand=cmd(animate,false;visible,false;blend,Blend.Add);
		OffCommand=function(self)
            self:visible(true)
			if pss:FullComboOfScore('TapNoteScore_W1') then
				self:setstate(0);
			elseif pss:FullComboOfScore('TapNoteScore_W2') then
				self:setstate(1);
			elseif pss:FullComboOfScore('TapNoteScore_W3') then
				self:setstate(2);
			elseif pss:FullComboOfScore('TapNoteScore_W4') then
				self:setstate(3);
			else
				self:visible(false);
			end;
            self:diffusealpha(0):zoom(1):sleep(1):accelerate(0.1):zoom(1.05):diffusealpha(1):decelerate(1):zoom(1.2):diffusealpha(0);            
		end;
	};    
};

return t;