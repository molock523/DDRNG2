local player = ...

local function GetX(self,offset)
    if player==PLAYER_1 then
        self:x(THEME:GetMetric("ScreenGameplay","PlayerP1MiscX")-303)
    elseif player==PLAYER_2 then
        self:x(THEME:GetMetric("ScreenGameplay","PlayerP2MiscX")+53-24)
    end
end

local playermod;

if player==PLAYER_1 then playermod = "#216491"
elseif player==PLAYER_2 then playermod = "#91212e"
end

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		GetX(self,0)
	end;
    -- 1speed
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod));
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).speed_mod ~= nil then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    LoadFont("Common Normal")..{
    InitCommand=cmd(maxwidth,44;zoom,0.5);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).speed_mod ~= nil then
            self:visible(true):settext("x"..notefield_prefs_config:get_data(player).speed_mod)
        else
            self:visible(false)
        end
    end;
    }; 
    -- 2boost
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25);
    OnCommand=function(self)
        self:visible(false)
    end;
    };    
    -- 3appearance
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*2);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).hidden == true or
            notefield_prefs_config:get_data(player).sudden == true then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*2;diffusealpha,0.5);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).hidden == true or
            notefield_prefs_config:get_data(player).sudden == true then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };     
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*2);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).hidden == true then
            self:visible(true):croptop(0.25)
        elseif notefield_prefs_config:get_data(player).sudden == true then
            self:visible(true):cropbottom(0.25)
        else
            self:visible(false)
        end
    end;
    };    
    -- 4turn
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*3);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'mirror') or
           GAMESTATE:PlayerIsUsingModifier(player,'left') or
           GAMESTATE:PlayerIsUsingModifier(player,'right') or
           GAMESTATE:PlayerIsUsingModifier(player,'shuffle') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    LoadActor(THEME:GetPathG("","_modicons/turn"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*3);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'mirror') then
            self:visible(true):rotationz(-90)
        elseif GAMESTATE:PlayerIsUsingModifier(player,'left') then
            self:visible(true):rotationz(0)
        elseif GAMESTATE:PlayerIsUsingModifier(player,'right') then
            self:visible(true):rotationz(180)
        else
            self:visible(false)
        end
    end;
    };
    LoadFont("Common Normal")..{
    Text="?";
    InitCommand=cmd(maxwidth,44;zoom,0.5;addx,25*3);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'shuffle') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    }; 
    -- 5dark
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*4);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).dark == true then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    LoadActor(THEME:GetPathG("","_modicons/dark"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*4);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).dark == true then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };    
    -- 6reverse
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*5);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).reverse == -1 then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    }; 
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(scaletoclipped,18,18;rotationz,180;addx,25*5);
    OnCommand=function(self)
        if notefield_prefs_config:get_data(player).reverse == -1 then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };     
    -- 7noteskins
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*6);
    OnCommand=function(self)
            self:visible(true)
    end;
    }; 
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*6);
    };      
    -- 8cut
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*7);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'Little') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(zoom,0.4;addx,25*7);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'Little') then
            self:visible(true):zoom(0.5):addy(-5):diffusealpha(1)
        else
            self:visible(false)
        end
    end;
    }; 
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(zoom,0.4;addx,25*7);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'Little') then
            self:visible(true):zoom(0.5):addy(5):diffusealpha(0.5)
        else
            self:visible(false)
        end
    end;
    };  
    -- 9holds
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*8);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'NoHolds') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    }; 
    LoadActor(THEME:GetPathG("","_modicons/freeze"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*8);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'NoHolds') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    -- 10jumps
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*9);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'NoJumps') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(zoom,0.4;addx,25*9);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'NoJumps') then
            self:visible(true):zoom(0.4):addx(-5):diffusealpha(0.5):rotationz(-90)
        else
            self:visible(false)
        end
    end;
    }; 
    LoadActor(THEME:GetPathG("","_modicons/arrow"))..{
    InitCommand=cmd(zoom,0.4;addx,25*9);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'NoJumps') then
            self:visible(true):zoom(0.4):addx(5):diffusealpha(0.5):rotationz(90)
        else
            self:visible(false)
        end
    end;
    };    
    -- 11mines
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*10);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'NoMines') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };
    LoadActor(THEME:GetPathG("","_modicons/shock"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*10);
    OnCommand=function(self)
        if GAMESTATE:PlayerIsUsingModifier(player,'NoMines') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };    
    -- 12Risky
    Def.Quad{
    InitCommand=cmd(setsize,24,24;diffuse,color(playermod);addx,25*11;visible,false);
    OnCommand=function(self)
        if not GAMESTATE:PlayerIsUsingModifier(player,'LifeType_Normal') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    }; 
    LoadActor(THEME:GetPathG("","_modicons/risky"))..{
    InitCommand=cmd(scaletoclipped,18,18;addx,25*11;visible,false);
    OnCommand=function(self)
        if not GAMESTATE:PlayerIsUsingModifier(player,'LifeType_Normal') then
            self:visible(true)
        else
            self:visible(false)
        end
    end;
    };  
};
return t;