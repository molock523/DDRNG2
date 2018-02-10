return Def.ActorFrame { 
-- Caution Title + text
Def.ActorFrame{
InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25;zwrite,true;ztest,true;draworder,1;z,10);
    LoadFont("Common Normal")..{
        Text="Extreme Play Motions are Dangerous";
        InitCommand=cmd(horizalign,left;vertalign,top;addy,100;diffuse,color("#2e2e2e");zoom,0.65);
        OnCommand=cmd(cropright,1;sleep,0.8;linear,1;cropright,0);
        OffCommand=cmd(sleep,0.02;accelerate,0.5;addx,-50;diffusealpha,0);
    };
    LoadFont("Common Normal")..{
        Text="Violent Play is Dangerous";
        InitCommand=cmd(horizalign,left;vertalign,top;addy,120;diffuse,color("#2e2e2e");zoom,0.65);
        OnCommand=cmd(cropright,1;sleep,2;linear,1;cropright,0);
        OffCommand=cmd(sleep,0.04;accelerate,0.5;addx,-50;diffusealpha,0);
    };
    LoadFont("Common Light")..{
        Text="Be careful of the raised platform";
        InitCommand=cmd(horizalign,left;vertalign,top;addy,150;diffuse,color("#2e2e2e");zoom,0.5);
        OnCommand=cmd(cropright,1;sleep,3;linear,1;cropright,0);
        OffCommand=cmd(sleep,0.06;accelerate,0.5;addx,-50;diffusealpha,0);
    }; 
    LoadFont("Common Light")..{
        Text="when stepping on the dance stage";
        InitCommand=cmd(horizalign,left;vertalign,top;addy,165;diffuse,color("#2e2e2e");zoom,0.5);
        OnCommand=cmd(cropright,1;sleep,4;linear,1;cropright,0);
        OffCommand=cmd(sleep,0.08;accelerate,0.5;addx,-50;diffusealpha,0);
    }; 
};

-- Prompt
    Def.ActorFrame{
    InitCommand=cmd(xy,_screen.cx+(SCREEN_WIDTH/1.3*0.5)-25,_screen.cy+(SCREEN_HEIGHT/1.3*0.5)-25;zwrite,true;ztest,true;draworder,1;z,10); 
        LoadFont("Common Large Normal")..{
            Text="Let's Start!";
            InitCommand=cmd(horizalign,right;vertalign,bottom;diffuse,color("#ff0048");zoom,0.3);
            OnCommand=cmd(addx,50;diffusealpha,0;sleep,7;decelerate,0.8;addx,-50;diffusealpha,1);
            OffCommand=cmd(accelerate,0.5;addx,-50;diffusealpha,0);
        };
    };
    LoadActor("_mask_default_169")..{
        Condition=aspectratio()=="16:9";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };
    LoadActor("_mask_default_43")..{
        Condition=aspectratio()=="4:3";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };
};