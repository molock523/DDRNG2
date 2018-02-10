local function x_pos(self,offset,player)
	if player == PLAYER_1 then
		self:x(_screen.w/2-335+offset);
	elseif player == PLAYER_2 then
        self:x(_screen.w/2+335+offset);
	end
end

function getcharacters()
local characters = FILEMAN:GetDirListing("Themes/"..THEME:GetCurThemeName().."/Graphics/_characters/")
local t = Def.ActorFrame{}
for i in ivalues(characters) do
    t[#t+1] = Def.ActorFrame{          
        Def.Sprite{
        InitCommand=function(self)
            self:Load(THEME:GetPathG("","_characters/"..i))
        end;
        };
        LoadFont("Common Large Bold")..{
            Text=string.upper(i:gsub(".png",""));
            OnCommand=cmd(horizalign,left;vertalign,bottom;addy,200;addx,-272/2-120);        
        };              
    };
end
return t
end;

local function playerstuff(pn)
    return Def.ActorScroller{
	Name="Scroller";
	NumItemsToDraw=1,
	SecondsPerItem=0.1,
	OnCommand=cmd(zoom,0.35;addy,20;SetDestinationItem,0;SetFastCatchup,true;fov,60;zwrite,true;ztest,true;draworder,8;z,8;playcommand,"CodeMessage");
    OffCommand=cmd(linear,0.2;diffusealpha,0);
	TransformFunction=function(self, offset, itemIndex, numItems)
		self:x(math.floor( offset*(0) ));
    end;      
	CodeMessageCommand=function(self,params)
	local DI = self:GetCurrentItem();          
	if params.PlayerNumber == pn then 
        if params.Name=="Left" then
            if DI>0 then 
                self:SetDestinationItem(DI-1) 
                SOUND:PlayOnce(THEME:GetPathS("","Pane Sound"))
            end
        end
        if params.Name=="Right" then 
            if DI<14 then 
                self:SetDestinationItem(DI+1) 
                SOUND:PlayOnce(THEME:GetPathS("","Pane Sound"))
            end
        end
		if params.Name == "Back" then
			SCREENMAN:GetTopScreen():Cancel()
		end
		if params.Name == "Start" then
            SOUND:PlayOnce(THEME:GetPathS("common","Start"))
			SCREENMAN:GetTopScreen():Cancel()
            player_config:get_data().Character = DI+1
            player_config:set_dirty()
            player_config:save()
		end                
	end;
	end;
    children=getcharacters()
    };    
end

local t = Def.ActorFrame{}
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = playerstuff(pn)..{
    InitCommand=function(self)
        self:zoom(0.75)
        x_pos(self,0,pn)
        self:CenterY();
    end; 
    };
end;
return t