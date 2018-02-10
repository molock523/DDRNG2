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
        OffCommand=cmd(sleep,0.7;linear,0.2;zoomy,0);
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,-(xsize/2)-offset,-(ysize/2)-offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OffCommand=cmd(sleep,0.5;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OffCommand=cmd(sleep,0.5;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,(xsize/2)+offset,(ysize/2)+offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OffCommand=cmd(sleep,0.5;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OffCommand=cmd(sleep,0.5;linear,0.1;croptop,1);
        };
    };
};
return t
end

local tt={1,2,3,4,5};
local rv={1,2,3,4,5};
local vx={
    0,
    -103,
    -77,
    77,
    103,
};
local vy={
    -100,
    -40,
    60,
    60,
    -40,
};

local function Radar_ValuesSingle(player, ValueTable)
for i in ivalues(rv) do
    value = LoadFile("single_"..i.."_"..ToEnumShortString(player)..".txt","playerradar") 
    ValueTable[i]=tonumber(value);
end
end

local function Radar_TextSingle(player)
local t = Def.ActorFrame{}
for i in ivalues(rv) do
    value = LoadFile("single_"..i.."_"..ToEnumShortString(player)..".txt","playerradar") 
    t[#t+1] = LoadFont("Common Normal")..{
        Text=value*100;
        InitCommand=cmd(zoom,0.8;xy,vx[i],vy[i];diffuse,PlayerColor(PLAYER_1);horizalign,right;addx,-1);
    };       
end
return t
end

local function Radar_ValuesDouble(player, ValueTable)
for i in ivalues(rv) do
    value = LoadFile("double_"..i.."_"..ToEnumShortString(player)..".txt","playerradar")    
    ValueTable[i]=tonumber(value);
end
end

local function Radar_TextDouble(player)
local t = Def.ActorFrame{}
for i in ivalues(rv) do
    value = LoadFile("double_"..i.."_"..ToEnumShortString(player)..".txt","playerradar") 
    t[#t+1] = LoadFont("Common Normal")..{
        Text=value*100;
        InitCommand=cmd(zoom,0.8;xy,vx[i],vy[i];diffuse,PlayerColor(PLAYER_2);horizalign,left;addx,1);
    };       
end
return t
end

local function DefaultInfo(player)
local level = (PROFILEMAN:GetProfile(player):GetSongsAndCoursesPercentCompleteAllDifficulties('StepsType_Dance_Single')+
              PROFILEMAN:GetProfile(player):GetSongsAndCoursesPercentCompleteAllDifficulties('StepsType_Dance_Double'))
local StarsFile = LoadFile(ToEnumShortString(player).."_stars.txt","playerstats")
local t = Def.ActorFrame{}
t[#t+1] = Def.ActorFrame{
Name="Info_top";
InitCommand=cmd(addy,-140);
    LoadFont("Common Bold")..{
        Name="Text_location";
        Text="PC";
        InitCommand=cmd(addx,120;horizalign,right;zoom,0.8;diffuse,color("#ffffff"));
    };        
    Def.Quad{
        Name="Bar_ddrcode";
        InitCommand=cmd(setsize,272,40;shadowlengthy,1;shadowcolor,color("#eaeaea");addy,42);
    }; 
    LoadFont("Common Normal")..{
        Name="Text_ddrcode";
        Text=string.upper(string.sub(PROFILEMAN:GetProfile(player):GetGUID(),1,4).."-"..string.sub(PROFILEMAN:GetProfile(player):GetGUID(),5,8));
        InitCommand=cmd(addx,-90;horizalign,left;zoom,0.8;diffuse,color("#2e2e2e");addy,42);
    };
    Def.Quad{
        Name="Bar_level";
        InitCommand=cmd(setsize,272-36,4;horizalign,left;addx,-272/2+36;shadowlengthy,-1;shadowcolor,color("#61ff61");addy,21-2;diffusebottomedge,color("#00ff00");diffusetopedge,color("#00c000");zoomx,1*level/10);
    }; 
    Def.Quad{
        Name="Box_level";
        InitCommand=cmd(setsize,36,40;diffuse,color("#ffffff");addx,-120);
    };        
    LoadFont("Common Bold")..{
        Name="Text_level";
        Text=string.format("%01d",level);
        InitCommand=cmd(addx,-120;zoom,0.8;diffuse,color("#2e2e2e"));
    };     
    Def.Quad{
        Name="Bar_stars";
        InitCommand=cmd(setsize,272,40;shadowlengthy,1;shadowcolor,color("#eaeaea");addy,42*2);
    };
    LoadFont("Common Normal")..{
        Name="Text_stars";
        Text=StarsFile;
        InitCommand=cmd(zoom,0.8;addy,42*2;addx,-90;horizalign,left;diffuse,color("#2e2e2e"));
    };
    LoadActor(THEME:GetPathG("","_stagestar"))..{
        Name="Text_stars";
        InitCommand=cmd(zoom,0.25;addy,42*2;addx,-120);
    };        
        
};
local stars = StarsFile or {1,2,3,4,5,6,7,8,9}
for i in ivalues(stars) do
t[#t+1] = LoadActor(THEME:GetPathG("","_stagestar"))..{
        Name="Img_stars";
        InitCommand=cmd(zoom,0.2;addy,-140+42*2;x,20*stars[i];addx,-110;horizalign,left);
    };
end
t[#t+1] = Def.ActorFrame{
Name="Info_bottom";
InitCommand=cmd(addy,120);
    LoadActor(THEME:GetPathG("","_grooveradar"))..{
        Name="Img_radar";
        InitCommand=cmd();
    };
	Def.GrooveRadar {
		OnCommand=function(self)
            Radar_ValuesSingle(player,tt);
            self:SetFromValues(player,tt):diffuse(PlayerColor(PLAYER_1))
        end;
	};
    Radar_TextSingle(player);
	Def.GrooveRadar {
        Name="Radar_double";
		OnCommand=function(self)
            Radar_ValuesDouble(player,tt);
            self:SetFromValues(player,tt):diffuse(PlayerColor(PLAYER_2))
        end;
	};
    Radar_TextDouble(player);
};
return t
end

function LoadPlayerStuff(player)
	local ret = {};

	local pn = (player == PLAYER_1) and 1 or 2;
	
	t = Def.ActorFrame {
		Name = 'BigFrame';
		commonpanel(310-20,SCREEN_HEIGHT/1.3-20,10,0.5,color("#f2f2f2"),PlayerColor(player));
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
            self:diffusealpha(0):sleep(0.5):linear(0.2):diffusealpha(1);
        end;
        OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };
        Def.Quad{
            InitCommand=cmd(horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+50;setsize,90,5;diffuse,PlayerColor(player));
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };        
    };
    table.insert( ret, t );
    t = Def.ActorFrame{
        Name='PlayerBar';
        InitCommand=cmd(addy,-140);
        OnCommand=cmd(diffusealpha,0;sleep,0.5;linear,0.2;diffusealpha,1);
        OffCommand=cmd(diffusealpha,0);
        Def.Quad{
            Name="Bar_name";
            InitCommand=cmd(setsize,272,40;shadowlengthy,1;shadowcolor,color("#eaeaea");diffuse,PlayerColor(player));
        }; 
        LoadFont("Common Bold")..{
            Name="Text_name";
            Text=PROFILEMAN:GetProfile(player):GetDisplayName();
            InitCommand=cmd(addx,-90;horizalign,left;zoom,0.8;diffuse,color("#ffffff"));
        };        
    };
    table.insert( ret, t );
    t = Def.ActorFrame{DefaultInfo(player)..{
        OnCommand=cmd(diffusealpha,0;sleep,0.5;linear,0.2;diffusealpha,1);
        OffCommand=cmd(diffusealpha,0);
        }
    };
	table.insert( ret, t );
    t = Def.HelpDisplay {
    File = THEME:GetPathF("Common", "Bold");
    Name="Help";
    OnCommand=cmd(zoom,0.75;addy,-200+8;addx,-272/2+10;wrapwidthpixels,320;horizalign,left;diffusealpha,0;sleep,0.5;linear,0.2;diffusealpha,1);
    OffCommand=cmd(diffusealpha,0);
    InitCommand=function(self)
    local s = THEME:GetString(Var "LoadingScreen","HelpText");
        self:SetTipsColonSeparated(s);
        self:SetSecsBetweenSwitches(4);
    end;
    SetHelpTextCommand=function(self, params)
        self:SetTipsColonSeparated( params.Text );
    end;
    };
    table.insert( ret, t );    
    return ret;
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
            SCREENMAN:GetTopScreen():Finish()
            MESSAGEMAN:Broadcast("StartButton")
            MESSAGEMAN:Broadcast("NextScreen")
		end,
		Back= function()
            SCREENMAN:GetTopScreen():Cancel()
		end,
	}
	if input_functions[code] then
		input_functions[code]()
	end
end

local t = Def.ActorFrame {
	OnCommand=function(self, params)
		main_frame= self:GetParent()
		SCREENMAN:GetTopScreen():AddInputCallback(input)
	end;
    NextScreenMessageCommand=function(self)
        self:finishtweening()
        SCREENMAN:GetTopScreen():Finish()
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end;    
    
	children = {         
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
	};
};

return t;