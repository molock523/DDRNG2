local function x_pos(self,offset,player)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
        self:x(_screen.w/2+335+offset);
	end
end

local choices={1,2};
local curchoice=1;

function LoadPlayerStuff(player)
local t = Def.ActorFrame{}
    t[#t+1] = commonpanel(310-20,424/2,10,0.5,color("#000000"),color("#00ff12")); 
    t[#t+1] = LoadFont("Common Bold")..{
        Text=THEME:GetString("ScreenPrompt","ProfileCustomizeHeading");
        InitCommand=cmd(addx,-272/2+5;addy,-424/4+20;vertalign,top;horizalign,left;zoom,0.75);
        OnCommand=cmd(cropright,1;sleep,0.3;linear,0.2;cropright,0);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    };
    t[#t+1] = LoadFont("Common Normal")..{
        Text=THEME:GetString("ScreenPrompt","ProfileCustomizeBody");
        InitCommand=cmd(addx,-272/2+5;addy,-424/4+45;vertalign,top;horizalign,left;zoom,0.65);
        OnCommand=cmd(cropright,1;sleep,0.6;linear,0.2;cropright,0);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    };    
    t[#t+1] = LoadFont("Common Normal")..{
        Text=THEME:GetString("ScreenPrompt","1");
        InitCommand=cmd(xy,-50,40);    
        OnCommand=cmd(diffusealpha,0;sleep,0.8;linear,0.2;diffusealpha,1;playcommand,"FocusYesMessage");
        OffCommand=cmd(diffusealpha,0);
        FocusYesMessageCommand=cmd(zoom,1);
        FocusNoMessageCommand=cmd(zoom,0.5);
    };
    t[#t+1] = LoadFont("Common Normal")..{
        Text=THEME:GetString("ScreenPrompt","2");
        InitCommand=cmd(xy,50,40);    
        OnCommand=cmd(diffusealpha,0;sleep,0.8;linear,0.2;diffusealpha,1;playcommand,"FocusYesMessage");
        OffCommand=cmd(diffusealpha,0);
        FocusYesMessageCommand=cmd(zoom,0.5);
        FocusNoMessageCommand=cmd(zoom,1);
    };
return t
end;

function UpdateInternal3(self, player)
	local pn = (player == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pn));
    local c = frame:GetChildren();

	if GAMESTATE:IsHumanPlayer(player) then
		frame:visible(true);
        c.PlayerTitle:visible(true);
		if MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none' and PROFILEMAN:GetNumLocalProfiles()~=0 then
			--using profile if any
            c.BigFrame:visible(true);
			c.Scroller:visible(true);
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(player);
			if ind > 0 then
				c.Scroller:SetDestinationItem(ind-1);
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(player, 1) then
					c.Scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					c.Scroller:visible(false);
				end;
			end;
		else
			--using card
			c.Scroller:visible(false);
			SCREENMAN:GetTopScreen():SetProfileIndex(player, 0);
		end;
	else
		c.Scroller:visible(false);
        c.BigFrame:visible(false);
        c.PlayerTitle:visible(false);
	end;
end;

local main_frame= false

local function input(event)
	if event.type == "InputEventType_Release" then return end
	local pn= event.PlayerNumber
	local code= event.GameButton
	if not pn or not code then return end
	local input_functions= {
		Start= function()
            if curchoice==1 then
                MESSAGEMAN:Broadcast("NextScreen")
                SCREENMAN:GetTopScreen():Finish()
            elseif curchoice==2 then
                MESSAGEMAN:Broadcast("NextScreen")
                SCREENMAN:GetTopScreen():Cancel()
            end
		end,
		Back= function()
            SCREENMAN:GetTopScreen():Cancel()
		end,
		MenuUp= function()
			if GAMESTATE:IsHumanPlayer(pn) then
				if curchoice==2 then
                    MESSAGEMAN:Broadcast("FocusYes") 
                    curchoice=1
                end
			end
		end,
		MenuDown= function()
			if GAMESTATE:IsHumanPlayer(pn) then
				if curchoice==1 then
                    MESSAGEMAN:Broadcast("FocusNo") 
                    curchoice=2
                end
			end
		end,        
	}
	input_functions.MenuLeft= input_functions.MenuUp
	input_functions.MenuRight= input_functions.MenuDown
	if input_functions[code] then
		input_functions[code]()
	end
end

local t = Def.ActorFrame {
	OnCommand=function(self, params)
		main_frame= self:GetParent()
		SCREENMAN:GetTopScreen():AddInputCallback(input)
	end;
	children = {
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
		LoadActor( THEME:GetPathS("Common","value") )..{
			IsAction= true,
			DirectionButtonMessageCommand=cmd(play);
		};
    PlayerJoinedMessageCommand=cmd(playcommand,"Init");
};    
};

return t;
