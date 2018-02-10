local function x_pos(self,offset,player)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
        self:x(_screen.w/2+335+offset);
	end
end

function GetLocalProfiles()
	local ret = {};

	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local profile=PROFILEMAN:GetLocalProfileFromIndex(p);
		local item = Def.ActorFrame {
			LoadFont("Common Normal") .. {
				Text=profile:GetDisplayName();
				InitCommand=cmd(shadowlength,1;y,-10;zoom,1;ztest,true);
			};
		};
		table.insert( ret, item );
	end;

	return ret;
end;

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
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,-(xsize/2)-offset,-(ysize/2)-offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,0.7;linear,0.1;cropright,0);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,0.7;linear,0.1;cropbottom,0);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,(xsize/2)+offset,(ysize/2)+offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,0.7;linear,0.1;cropleft,0);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,0.7;linear,0.1;croptop,0);
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
		Name = 'SelFrame';
        Def.Quad{
        InitCommand=cmd(setsize,272,40;shadowlengthy,1;shadowcolor,color("#eaeaea");diffuse,PlayerColor(player));
        OnCommand=cmd(zoomy,0;sleep,1.9;linear,0.2;zoomy,1);
        }; 
	};
	table.insert( ret, t );    
    t = Def.ActorFrame{
        Name = 'PlayerTitle';
        LoadFont("Common Bold") .. {
        InitCommand=cmd(maxwidth,270;zoom,0.8;horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+20;diffuse,PlayerColor(player));
        OnCommand=function(self)
            if player== PLAYER_1 then
                self:settext("Player 1");
            else
                self:settext("Player 2");
            end
            self:diffusealpha(0):sleep(1.5):linear(0.1):diffusealpha(1);
        end;
        OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };
        Def.Quad{
            InitCommand=cmd(horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+50;setsize,90,5;diffuse,PlayerColor(player));
            OnCommand=cmd(cropright,1;sleep,1.6;linear,0.1;cropright,0);
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };        
    };
    table.insert( ret, t );   
	t = Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=3;
		OnCommand=cmd(y,10;SetFastCatchup,true;SetMask,272,40;SetSecondsPerItem,0.15;diffusealpha,0;sleep,1.7;linear,0.1;diffusealpha,1);
		TransformFunction=function(self, offset, itemIndex, numItems)
			local focus = scale(math.abs(offset),0,2,1,0);
			self:visible(false);
			self:y(math.floor( offset*40 ));
		end;
		children = GetLocalProfiles();
	};
	table.insert( ret, t );
    t = Def.ActorFrame{
    Name="SelExp";
    InitCommand=cmd(addy,-140;diffusealpha,0;sleep,1.5;linear,0.1;diffusealpha,1);
        Def.Quad{
            InitCommand=cmd(y,142+20-10+3/0.75+250*0.75+2;setsize,200/0.75,66/0.75;diffuse,color("#000000");diffusealpha,0.15);
        };
        LoadFont("Common Normal")..{
            Text=THEME:GetString("ScreenSelectProfile","SelectExplanation");
            InitCommand=cmd(xy,-100/0.75+10,133/0.75+250*0.75+2-50;wrapwidthpixels,380;zoom,0.5/0.75;horizalign,left;vertalign,top);
            AnimateExplanationMessageCommand=cmd(cropright,1;linear,0.5;cropright,0);
        };
    };
    table.insert( ret, t );
	return ret;
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
            c.SelFrame:visible(true);
            c.SelExp:visible(true);
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
        c.SelFrame:visible(false);
        c.SelExp:visible(false);
		c.Scroller:visible(false);
        c.BigFrame:visible(false);
        c.PlayerTitle:visible(false);
	end;
end;

-- Will be set to the main ActorFrame for the screen in its OnCommand.
local main_frame= false

local function input(event)
	if event.type == "InputEventType_Release" then return end
	local pn= event.PlayerNumber
	local code= event.GameButton
	if not pn or not code then return end
	local input_functions= {
		Start= function()
            MESSAGEMAN:Broadcast("StartButton")
            if not GAMESTATE:IsHumanPlayer(pn) then
                SCREENMAN:GetTopScreen():SetProfileIndex(pn, -1)
            else
                SCREENMAN:GetTopScreen():Finish()
            end
		end,
		Back= function()
			if GAMESTATE:GetNumPlayersEnabled()==0 then
				SCREENMAN:GetTopScreen():Cancel()
			else
				MESSAGEMAN:Broadcast("BackButton")
				SCREENMAN:GetTopScreen():SetProfileIndex(pn, -2)
			end
		end,
		MenuUp= function()
			if GAMESTATE:IsHumanPlayer(pn) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn)
				if ind > 1 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind - 1) then
						MESSAGEMAN:Broadcast("DirectionButton")
						main_frame:queuecommand('UpdateInternal2')
					end
				end
			end
		end,
		MenuDown= function()
			if GAMESTATE:IsHumanPlayer(pn) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn)
				if ind > 0 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + 1) then
						MESSAGEMAN:Broadcast("DirectionButton")
						main_frame:queuecommand('UpdateInternal2')
					end
				end
			end
		end
	}
	input_functions.MenuLeft= input_functions.MenuUp
	input_functions.MenuRight= input_functions.MenuDown
	if input_functions[code] then
		input_functions[code]()
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
    
	OffCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;    
    
	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;
    NextScreenMessageCommand=function(self)
        SCREENMAN:GetTopScreen():Finish()
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
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
            OnCommand=cmd(player,PLAYER_1;queuecommand,'UpdateInternal2');
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
            InitCommand=function(self)
                    self:zoom(0.75)
                    x_pos(self,0,PLAYER_2)
                    self:CenterY();
            end; 
            OnCommand=cmd(player,PLAYER_2;queuecommand,'UpdateInternal2');
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
		LoadActor( THEME:GetPathS("","Profile_Move") )..{
			IsAction= true,
			DirectionButtonMessageCommand=cmd(play);
		};
	};    
};

return t;
