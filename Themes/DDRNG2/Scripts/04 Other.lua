local numbered_stages= {
	Stage_1st= true,
	Stage_2nd= true,
	Stage_3rd= true,
	Stage_4th= true,
	Stage_5th= true,
	Stage_6th= true,
	Stage_Next= true,
}

function thified_curstage_index(on_eval)
	local cur_stage= GAMESTATE:GetCurrentStage()
	local adjust= 1
	-- hack: ScreenEvaluation shows the current stage, but it needs to show
	-- the last stage instead.  Adjust the amount.
	if on_eval then
		adjust= 0
	end
	if numbered_stages[cur_stage] then
		return FormatNumberAndSuffix(GAMESTATE:GetCurrentStageIndex() + adjust)
	else
		return ToEnumShortString(cur_stage)
	end
end

function check_stop_course_early()
	return course_stopped_by_pause_menu
end

function playmodechoices()
    if not IsNetConnected() then return "Starter,Regular,Pro"
    else return "Starter,Regular,Pro,Net"
    end
end

function aspectratio()
    if _screen.w/_screen.h >=1.3 and _screen.w/_screen.h <=1.4 then
        return "4:3"
    elseif _screen.w/_screen.h >=1.7 and _screen.w/_screen.h <=1.8 then
        return "16:9"
    end
end

function commonpanel(xsize,ysize,offset,alpha,main_colour,edge_colour)
local main_colour = main_colour
local edge_colour = edge_colour
local alpha = alpha or 0.5
local t = Def.ActorFrame{}   
t[#t+1] = Def.ActorFrame{       
    Def.Quad{
        InitCommand=cmd(setsize,xsize,ysize;diffuse,main_colour;diffusealpha,alpha;shadowlengthy,1;shadowcolor,color("#cccccc"));
        OnCommand=cmd(zoomy,0;linear,0.2;zoomy,1);
        OffCommand=cmd(sleep,0.2;linear,0.2;zoomy,0);
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,-(xsize/2)-offset,-(ysize/2)-offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,0.2;linear,0.1;cropright,0);
            OffCommand=cmd(linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,0.2;linear,0.1;cropbottom,0);
            OffCommand=cmd(linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,(xsize/2)+offset,(ysize/2)+offset;diffuse,edge_colour);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,0.2;linear,0.1;cropleft,0);
            OffCommand=cmd(linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,0.2;linear,0.1;croptop,0);
            OffCommand=cmd(linear,0.1;croptop,1);
        };
    };
};
return t
end

Renaming={
    songgroup=function(group)
	local group_names= {
		["DanceDanceRevolution 1stMIX"]= "DDR 1stMIX",
		["DanceDanceRevolution 2ndMIX"]= "DDR 2ndMIX",
		["DanceDanceRevolution 3rdMIX"]= "DDR 3rdMIX",
		["DanceDanceRevolution 4thMIX"]= "DDR 4thMIX",
		["DanceDanceRevolution 5thMIX"]= "DDR 5thMIX",
		["DanceDanceRevolution 6thMIX MAX"]= "DDR MAX",
		["DanceDanceRevolution 7thMIX MAX2"]= "DDR MAX2",
		["DanceDanceRevolution 8thMIX EXTREME"]= "DDR EXTREME",
		["DanceDanceRevolution SuperNOVA"]= "DDR SuperNOVA",
		["DanceDanceRevolution SuperNOVA2"]= "DDR SuperNOVA2",
		["DanceDanceRevolution X"]= "DDR X",
		["DanceDanceRevolution X2"]= "DDR X2",
		["DanceDanceRevolution X3"]= "DDR X3",
		["DDR 2013"]= "DDR 2013",
		["DDR 2014"]= "DDR 2014",
        ["DDR A"]= "DDR A",        
		["DDR Next Generation"]= "DDR NG",
        ["DDR Next Generation 2"]= "DDR NG2",        
	}
	return group_names[group] or group
    end,
    sgrade=function(grade)
    local grade_names= {
        ["Grade_Tier01"] = "AAA",
        ["Grade_Tier02"] = "AA",
        ["Grade_Tier03"] = "AA",
        ["Grade_Tier04"] = "AA",
        ["Grade_Tier05"] = "A",
        ["Grade_Tier06"] = "A",
        ["Grade_Tier07"] = "A",            
        ["Grade_Tier08"] = "B",
        ["Grade_Tier09"] = "B",
        ["Grade_Tier10"] = "B",
        ["Grade_Tier11"] = "C",
        ["Grade_Tier12"] = "C",
        ["Grade_Tier13"] = "C",
        ["Grade_Tier14"] = "D",
        ["Grade_Tier15"] = "D",            
        ["Grade_Tier16"] = "E",
        ["Grade_Failed"] = "E",            
    }
    return grade_names[grade]        
    end,
}

GameplayPlacement ={
    SplashesX = function(player)
    local st = GAMESTATE:GetCurrentStyle():GetStepsType();
    if st == "StepsType_Dance_Double" or st == "StepsType_Dance_Solo" then return _screen.cx
        else
            if player==PLAYER_1 then return THEME:GetMetric(Var "LoadingScreen","PlayerP1MiscX")
            elseif player==PLAYER_2 then return THEME:GetMetric(Var "LoadingScreen","PlayerP2MiscX")
            end                
        end
    end,
    ScoreFrameX = function(player)
        if aspectratio()=="16:9" then
            if player==PLAYER_1 then return THEME:GetMetric(Var "LoadingScreen","PlayerP1MiscX")-100
            elseif player==PLAYER_2 then return THEME:GetMetric(Var "LoadingScreen","PlayerP2MiscX")+100
            end
        elseif aspectratio()=="4:3" then
            if player==PLAYER_1 then return THEME:GetMetric(Var "LoadingScreen","PlayerP1MiscX")-170
            elseif player==PLAYER_2 then return THEME:GetMetric(Var "LoadingScreen","PlayerP2MiscX")+170
            end
        end
    end,
    ScoreDisplayX = function(player)
        if aspectratio()=="16:9" then
            if player==PLAYER_1 then return THEME:GetMetric(Var "LoadingScreen","PlayerP1MiscX")
            elseif player==PLAYER_2 then return THEME:GetMetric(Var "LoadingScreen","PlayerP2MiscX")
            end
        elseif aspectratio()=="4:3" then
            if player==PLAYER_1 then return SCREEN_LEFT+206
            elseif player==PLAYER_2 then return SCREEN_RIGHT-206
            end
        end
    end,
    StepsFrameX = function(player)
        if aspectratio()=="16:9" then
            if player==PLAYER_1 then return SCREEN_LEFT+45
            elseif player==PLAYER_2 then return SCREEN_RIGHT-45
            end
        elseif aspectratio()=="4:3" then
            if player==PLAYER_1 then return SCREEN_LEFT
            elseif player==PLAYER_2 then return SCREEN_RIGHT
            end
        end
    end,
    StepsFrameZoomX = function()
        if aspectratio()=="16:9" then return 1
        elseif aspectratio()=="4:3" then return 0.8
        end
    end,    
    StepsDisplayX = function(player)
        if aspectratio()=="16:9" then
            if player==PLAYER_1 then return THEME:GetMetric(Var "LoadingScreen","PlayerP1MiscX")-240
            elseif player==PLAYER_2 then return THEME:GetMetric(Var "LoadingScreen","PlayerP2MiscX")+240
            end
        elseif aspectratio()=="4:3" then
            if player==PLAYER_1 then return SCREEN_LEFT+59
            elseif player==PLAYER_2 then return SCREEN_RIGHT-59
            end
        end
    end,    
    StepsDisplayY = function(player)
        if notefield_prefs_config:get_data(player).reverse == -1 then
            return _screen.cy-280
        else
            return _screen.cy+263
        end
    end,
    CaloriesX = function(player)
        if aspectratio()=="16:9" then
            if player==PLAYER_1 then return SCREEN_LEFT+238+73
            elseif player==PLAYER_2 then return SCREEN_RIGHT-238-73
            end
        elseif aspectratio()=="4:3" then
            if player==PLAYER_1 then return SCREEN_LEFT+238-30+2
            elseif player==PLAYER_2 then return SCREEN_RIGHT-238+4
            end
        end
    end,    
    CaloriesY = function(player)
        if notefield_prefs_config:get_data(player).reverse == -1 then
            return _screen.cy-275
        else
            return _screen.cy+273
        end
    end, 
    ModiconsY = function(player)
        if notefield_prefs_config:get_data(player).reverse == -1 then
            return _screen.cy-280+24
        else
            return _screen.cy+237
        end
    end,
    PacemakerX = function(player)
        if aspectratio()=="16:9" then
            if player==PLAYER_1 then return SCREEN_LEFT+30
            elseif player==PLAYER_2 then return SCREEN_RIGHT-30
            end
        elseif aspectratio()=="4:3" then
            if player==PLAYER_1 then return SCREEN_LEFT+30
            elseif player==PLAYER_2 then return SCREEN_RIGHT-30
            end
        end
    end,     
    LifeX = function(player)
        if aspectratio()=="16:9" then
            if player==PLAYER_1 then return THEME:GetMetric(Var "LoadingScreen","PlayerP1MiscX")-20.5
            elseif player==PLAYER_2 then return THEME:GetMetric(Var "LoadingScreen","PlayerP2MiscX")+20.5
            end
        elseif aspectratio()=="4:3" then
            if player==PLAYER_1 then return THEME:GetMetric(Var "LoadingScreen","PlayerP1MiscX")-20.5-40
            elseif player==PLAYER_2 then return THEME:GetMetric(Var "LoadingScreen","PlayerP2MiscX")+20.5+40
            end
        end
    end,     
    LifeZoom = function()
        if aspectratio()=="16:9" then return 1
        elseif aspectratio()=="4:3" then return 0.875
        end
    end,
    PlayerZoom = function()
        if aspectratio()=="16:9" then return THEME:GetMetric("Common","ScreenHeight")/480
        elseif aspectratio()=="4:3" then return THEME:GetMetric("Common","ScreenHeight")/500
        end
    end,
}
