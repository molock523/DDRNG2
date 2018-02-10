local gc = Var("GameCommand");

return Def.ActorFrame {
    Def.Quad{
        InitCommand=cmd(setsize,272,40;diffuse,color("#ffffff");faderight,0.75;horizalign,left;diffusealpha,0);    
        GainFocusCommand=cmd(diffuse,color("#e88dbd");diffusealpha,0.25);
        LoseFocusCommand=cmd(diffuse,color("#ffffff");diffusealpha,0.15);
        OnCommand=cmd(diffusealpha,0;sleep,1.5;linear,0.25;diffusealpha,0.15);
        OffCommand=cmd(linear,0.25;diffusealpha,0);
    };
    Def.Quad{
        InitCommand=cmd(setsize,272,2;diffuse,color("#ffffff");addy,-18;faderight,0.5;horizalign,left;diffusealpha,0);    
        GainFocusCommand=cmd(diffuse,color("#e88dbd");diffusealpha,1);
        LoseFocusCommand=cmd(diffuse,color("#ffffff");diffusealpha,0.25);
        OnCommand=cmd(diffusealpha,0;sleep,1.5;linear,0.25;diffusealpha,0.5);
        OffCommand=cmd(linear,0.25;diffusealpha,0);
    };    
	LoadFont("Common Normal") .. {
		Text=THEME:GetString("ScreenTitleMenu",Var("GameCommand"):GetText());
        InitCommand=cmd(horizalign,left;addx,10);
		GainFocusCommand=cmd(stoptweening;linear,0.125;zoom,0.75;diffuse,color("#ffffff"));
		LoseFocusCommand=cmd(stoptweening;linear,0.125;zoom,0.75;diffuse,color("#2e2e2e"));
        OnCommand=cmd(diffusealpha,0;sleep,1.5;linear,0.25;diffusealpha,1);
        OffCommand=cmd(linear,0.25;diffusealpha,0);      
	};
};