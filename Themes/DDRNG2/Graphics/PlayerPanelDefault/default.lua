local t = Def.ActorFrame{};

t[#t+1] = Def.Quad{
    InitCommand=cmd(setsize,310-20,SCREEN_HEIGHT/1.3-20;diffuse,color("#000000");diffusealpha,0.025);
    OnCommand=cmd(zoomy,0;sleep,0.5;sleep,0.5;linear,0.2;zoomy,1);
    OffCommand=cmd(sleep,0.7;linear,0.2;zoomy,0);
};

t[#t+1] = Def.ActorFrame{
    InitCommand=cmd(xy,-155,-(SCREEN_HEIGHT/1.3)*0.5);
    Def.Quad{
        InitCommand=cmd(setsize,20,2;diffuse,color("#2e2e2e");horizalign,left;vertalign,top);
        OnCommand=cmd(cropright,1;sleep,0.5;sleep,0.7;linear,0.1;cropright,0);
        OffCommand=cmd(sleep,0.5;linear,0.1;cropright,1);
    };
    Def.Quad{
        InitCommand=cmd(setsize,2,20;diffuse,color("#2e2e2e");horizalign,left;vertalign,top);
        OnCommand=cmd(cropbottom,1;sleep,0.5;sleep,0.7;linear,0.1;cropbottom,0);
        OffCommand=cmd(sleep,0.5;linear,0.1;cropbottom,1);
    };
};
t[#t+1] = Def.ActorFrame{
    InitCommand=cmd(xy,155,(SCREEN_HEIGHT/1.3)*0.5);
    Def.Quad{
        InitCommand=cmd(setsize,20,2;diffuse,color("#2e2e2e");horizalign,right;vertalign,bottom);
        OnCommand=cmd(cropleft,1;sleep,0.5;sleep,0.7;linear,0.1;cropleft,0);
        OffCommand=cmd(sleep,0.5;linear,0.1;cropleft,1);
    };
    Def.Quad{
        InitCommand=cmd(setsize,2,20;diffuse,color("#2e2e2e");horizalign,right;vertalign,bottom);
        OnCommand=cmd(croptop,1;sleep,0.5;sleep,0.7;linear,0.1;croptop,0);
        OffCommand=cmd(sleep,0.5;linear,0.1;croptop,1);
    };
};
return t