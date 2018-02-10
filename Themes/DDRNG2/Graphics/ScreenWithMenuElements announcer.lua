local t = Def.ActorFrame {};

local screenname = Var ("LoadingScreen");

if screenname == "ScreenStarterSelectMusic" then screenname = "ScreenSelectMusic" end;

local num = 1
if screenname == "ScreenSelectStyle" then
    num = math.random(1,4);
elseif screenname == "ScreenSelectPlayMode" then
    num = math.random(1,2);
elseif screenname == "ScreenSelectMusic" then
    num = math.random(1,11);
elseif screenname == "ScreenGameplay" then
    num = math.random(1,9);
end;

t[#t+1] = Def.ActorFrame {
OnCommand=function(self)
SOUND:PlayOnce(THEME:GetPathS("","Announcer/"..screenname.."_Intro"..num))
end;
};

return t;
