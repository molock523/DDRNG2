return Def.ActorFrame {
    Def.Quad {
        InitCommand=cmd(Center;setsize,SCREEN_WIDTH,SCREEN_HEIGHT);
        OnCommand=function(self)
            if UIColor() == "Light" then
                self:diffusetopedge(color("#dadada")):diffusebottomedge(color("#f0f0f0"));
            else
                self:diffusetopedge(color("#303030")):diffusebottomedge(color("#808080"));
            end
        end;
    };
    Def.Quad {
        InitCommand=cmd(CenterX;y,_screen.cy+SCREEN_HEIGHT/3;setsize,SCREEN_WIDTH,SCREEN_HEIGHT/2;fadetop,0.25);
        OnCommand=cmd(diffusetopedge,color("#f0f0f0");diffusebottomedge,color("#cccccc");diffusealpha,0.5);
    };
    LoadActor("light")..{
        InitCommand=cmd(Center;diffusealpha,0.25);  
    };
};