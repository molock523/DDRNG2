local t = Def.ActorFrame {
OffFocusedCommand=function(self)
        local num = math.random(1,6);
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectPlayMode_CommentStarter"..num))
        theme_config:get_data().Mode = "Starter"
        theme_config:set_dirty()
        theme_config:save()        
end;
};
t[#t+1] = Def.ActorFrame {
    OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1);
    OffUnfocusedCommand=cmd(diffuse,color("0.75,0.75,0.75,1");accelerate,0.8;addx,-_screen.w/4;diffusealpha,0);
    OffFocusedCommand=cmd(accelerate,0.8;addx,-_screen.w/7;diffusealpha,0);
    GainFocusCommand=cmd(diffuse,color("1,1,1,1"));
    LoseFocusCommand=cmd(diffuse,color("0.8,0.8,0.8,1"));     
    --Default    
    LoadFont("Common Large Bold")..{
        Text="STARTER\nMODE";
        OnCommand=cmd(horizalign,right;vertalign,bottom;addx,492/2);
        GainFocusCommand=cmd(diffuse,color("1,1,1,1"));
        LoseFocusCommand=cmd(diffuse,color("0.75,0.75,0.75,1"));          
    };
    LoadActor(THEME:GetPathG("","_characters/babylon.png"))..{
        InitCommand=cmd(addx,-30;zoom,0.75;addy,-100;vertalign,bottom,addy,50);  
    };
    LoadActor(THEME:GetPathG("","_characters/emi.png"))..{
        InitCommand=cmd(addx,30;vertalign,bottom;addy,50);  
    };
    LoadFont("Common Normal")..{
        Text="New to DDR?\nLearn how to play here!";
        OnCommand=cmd(horizalign,right;vertalign,top;addy,120;addx,492/2);
        GainFocusCommand=cmd(diffusealpha,1;croptop,1;cropright,1;linear,0.2;croptop,0;cropright,0);
        LoseFocusCommand=cmd(diffusealpha,0);
        OffCommand=cmd(diffusealpha,0);
    };    
};	
return t;