local t = Def.ActorFrame{
    OffCommand=function(self)
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Cheer"))
    end;
};

--overlay
t[#t+1] = LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"))..{
    InitCommand=cmd(diffusealpha,0);
    OffCommand=cmd(sleep,5;accelerate,0.75;diffusealpha,1);
};

t[#t+1]= notefield_prefs_actor()..{
    OffCommand=cmd(decelerate,0.5;zoomx,0;zoomy,0.75;diffusealpha,0);
};

return t;