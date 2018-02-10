return Def.ActorFrame { 
    LoadActor("_mask_default_169")..{
        Condition=aspectratio()=="16:9";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };
    LoadActor("_mask_default_43")..{
        Condition=aspectratio()=="4:3";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };
    Def.ActorFrame{
    InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25;zwrite,true;ztest,true;draworder,1;z,10);
        LoadFont("Common Normal")..{
            Text=THEME:GetString("ScreenWarning","Text");
            InitCommand=function(self)
                if UIColor() == "Light" then
                    self:diffuse(color("#2e2e2e"));
                else
                    self:diffuse(color("#eaeaea"));
                end
            self:horizalign(left):vertalign(top):addy(100):zoom(0.65);
            end;
            OnCommand=cmd(cropright,1;sleep,1;linear,1;cropright,0);
            OffCommand=cmd(sleep,0.02;accelerate,0.5;addx,-50;diffusealpha,0);        
        };      
    };       
};