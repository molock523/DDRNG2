local t = Def.ActorFrame {
GainFocusCommand=cmd(diffuse,color("1,1,1,1"));
LoseFocusCommand=cmd(diffuse,color("0.8,0.8,0.8,1"));
OffFocusedCommand=function(self)
    theme_config:get_data().Console[ConsoleType] = 2
    theme_config:set_dirty()
    theme_config:save()
end;
	LoadFont("Common Normal")..{
        Text="Arcade"; 
    };
    LoadFont("Common Normal")..{
        Text="An standard arcade setup";
        InitCommand=cmd(addy,50;zoom,0.7;vertalign,top);
        OnCommand=cmd(cropright,1);
        GainFocusCommand=cmd(stoptweening;cropright,1;diffusealpha,1;linear,0.2;cropright,0);
        LoseFocusCommand=cmd(stoptweening;diffusealpha,0);       
        OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
    };    
};

return t;