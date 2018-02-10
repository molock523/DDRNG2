local function x_pos(self,offset,player)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
        self:x(_screen.w/2+335+offset);
	end
end

-- fixing animation between screens
local function localcommonpanel(xsize,ysize,offset,alpha,main_colour,edge_colour)
local main_colour = main_colour
local edge_colour = edge_colour
local alpha = alpha or 0.5
local t = Def.ActorFrame{}   
t[#t+1] = Def.ActorFrame{       
    Def.Quad{
        InitCommand=cmd(setsize,xsize,ysize;diffuse,main_colour;diffusealpha,alpha;shadowlengthy,1;shadowcolor,color("#cccccc"));
        OnCommand=cmd(zoomy,0;sleep,0.5;linear,0.2;zoomy,1);
        OffCommand=cmd(sleep,0.7;linear,0.2;zoomy,0);
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,-(xsize/2)-offset,-(ysize/2)-offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,0.7;linear,0.1;cropright,0);
            OffCommand=cmd(sleep,0.5;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,0.7;linear,0.1;cropbottom,0);
            OffCommand=cmd(sleep,0.5;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,(xsize/2)+offset,(ysize/2)+offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,0.7;linear,0.1;cropleft,0);
            OffCommand=cmd(sleep,0.5;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,0.7;linear,0.1;croptop,0);
            OffCommand=cmd(sleep,0.5;linear,0.1;croptop,1);
        };
    };
};
return t
end

local function prompt_intro(player)
local t = Def.ActorFrame{
    OnCommand=cmd(diffusealpha,0;sleep,1;linear,0.2;diffusealpha,1);
    LoadActor(THEME:GetPathG("","_machine/machine_profile"))..{
        InitCommand=function(self)
            if player==PLAYER_1 then self:rotationy(0)
            elseif player==PLAYER_2 then self:rotationy(180)
            end
        end;
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    };
    Def.ActorFrame{
        InitCommand=function(self)
            if player==PLAYER_1 then self:addx(-58) else self:addx(58) end self:addy(12):zoom(0.9)
        end;
        LoadActor(THEME:GetPathG("","_machine/machine_sel_cir"))..{
            InitCommand=cmd();
            OffCommand=cmd(bounceend,0.15;zoomy,0;diffusealpha,0);
        };
        LoadActor(THEME:GetPathG("","_machine/machine_sel_tri"))..{
            InitCommand=cmd(vertalign,bottom;addy,-96/2-10;zoom,0.25;bounce;effectmagnitude,0,4,0;effectclock,'beat');
            OffCommand=cmd(linear,0.15;zoomy,0;diffusealpha,0);
        };            
    };
    Def.ActorFrame{
        InitCommand=cmd(addy,524/3+30-3+10+2);
        commonpanel(310-20,424/4,10,0.5,color("#000000"),color("#00ff12"));       
        LoadFont("Common Bold")..{
            Text=THEME:GetString("ScreenUSBEntry","Heading");
            InitCommand=cmd(addx,-272/2+5;addy,-524/8+20;vertalign,top;horizalign,left;zoom,0.75);
            OnCommand=cmd(cropright,1;sleep,1;linear,0.2;cropright,0);
            OffCommand=cmd(linear,0.2;diffusealpha,0);
        };
        LoadFont("Common Normal")..{
            Text=THEME:GetString("ScreenUSBEntry","Body");
            InitCommand=cmd(addx,-272/2+5;addy,-524/8+30+40-2;vertalign,top;horizalign,left;zoom,0.65);
            OnCommand=cmd(cropright,1;sleep,1.2;linear,0.2;cropright,0);
            OffCommand=cmd(linear,0.2;diffusealpha,0);
        };
    };
};
return t
end

function LoadPlayerStuff(player)
	local ret = {};

	local pn = (player == PLAYER_1) and 1 or 2;
	
	t = Def.ActorFrame {
		Name = 'BigFrame';
		localcommonpanel(310-20,SCREEN_HEIGHT/1.3-20,10,0.5,color("#f2f2f2"),PlayerColor(player));
	};
	table.insert( ret, t );
    
	t = Def.ActorFrame {
		Name = 'PromptIntro';
		prompt_intro(player);
    
	};
	table.insert( ret, t );
    return ret;
end;

function UpdateInternal3(self, player)
	local pn = (player == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local bigframe = frame:GetChild('BigFrame');
    local promptintro = frame:GetChild('PromptIntro');
    promptintro:visible(true);
    bigframe:visible(true);
	if GAMESTATE:IsHumanPlayer(player) then
		frame:visible(true);
		if MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none' then
            promptintro:visible(true);
			bigframe:visible(true);
		else
            promptintro:visible(false);
		end;
	else
        promptintro:visible(false);
		bigframe:visible(false);
	end;
end;

-- Will be set to the main ActorFrame for the screen in its OnCommand.
local main_frame= false

local function input(event)
if event.type ~= "InputEventType_Release" then
local pn= event.PlayerNumber
if not pn then return end
    if event.GameButton == "Start" then
        MESSAGEMAN:Broadcast("StartButton")
        --SCREENMAN:GetTopScreen():Finish()
        --SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    elseif event.GameButton == "Back" then
        MESSAGEMAN:Broadcast("BackButton")
        SCREENMAN:GetTopScreen():Cancel()
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end
end
end

local t = Def.ActorFrame {
	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;
	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;
	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;
	OnCommand=function(self, params)
		main_frame= self:GetParent()
		SCREENMAN:GetTopScreen():AddInputCallback(input)
		self:queuecommand('UpdateInternal2');
	end;
    StartButtonMessageCommand=function(self, params)
        self:queuecommand('Off')
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
    end;
	MenuTimerExpiredMessageCommand=function(self, params)
		self:queuecommand('NextScreenMessage');
	end;
	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;   
    NextScreenMessageCommand=function(self)
        --SCREENMAN:GetTopScreen():Finish();
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
    end;   
    
	children = {
        -- machine image
        LoadActor(THEME:GetPathG("","_machine/machine_outline"))..{
        OnCommand=function(self)
            self:Center():zoom(0.75)
            if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
                self:diffuseleftedge(PlayerColor(PLAYER_1))
            elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) then
                self:diffuserightedge(PlayerColor(PLAYER_2))
            end
        end;
        PlayerJoinedMessageCommand=cmd(playcommand,"On");
        };        
		Def.ActorFrame {
			Name = 'P1Frame';
            InitCommand=function(self)
                    self:zoom(0.75)
                    x_pos(self,0,PLAYER_1)
                    self:CenterY();
            end; 
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
            InitCommand=function(self)
                    self:zoom(0.75)
                    x_pos(self,0,PLAYER_2)
                    self:CenterY();
            end; 
			children = LoadPlayerStuff(PLAYER_2);
		};
		-- sounds
		LoadActor( THEME:GetPathS("Common","start") )..{
			IsAction= true,
			StartButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("Common","cancel") )..{
			IsAction= true,
			BackButtonMessageCommand=cmd(play);
		};        
	};
};

return t;