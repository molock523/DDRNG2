local aspectsize;
if aspectratio()=="16:9" then
    aspectsize = SCREEN_WIDTH-324
elseif aspectratio()=="4:3" then
    aspectsize = SCREEN_WIDTH-40
end

return Def.ActorFrame {
    commonpanel(aspectsize,524,10,0.5,color("#f2f2f2"),color("#ffffff"))..{
        InitCommand=cmd(Center);
    };
    LoadActor("_mask_map_169")..{
        Condition=aspectratio()=="16:9";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };
    LoadActor("_mask_map_43")..{
        Condition=aspectratio()=="4:3";
        InitCommand=cmd(FullScreen;draworder,999;zwrite,true;z,-10;blend,"BlendMode_NoEffect");
    };    
    Def.Quad{
        InitCommand=cmd(xy,_screen.cx,_screen.cy-(SCREEN_HEIGHT/1.3)*0.5+50+66-2.5;vertalign,bottom;setsize,200,66;diffuse,color("#000000");diffusealpha,0.15);
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,_screen.w/2-335,_screen.cy;zoom,0.75);
    	LoadFont("Common Bold")..{
            Text="Player 1";
            InitCommand=cmd(maxwidth,270;zoom,0.8;horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+20;diffuse,PlayerColor(PLAYER_1));
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };
        Def.Quad{
            InitCommand=cmd(horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+50;setsize,90,5;diffuse,PlayerColor(PLAYER_1));
            OnCommand=cmd(cropright,1;sleep,1.7;linear,0.2;cropright,0);
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };        
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,_screen.w/2+335,_screen.cy;zoom,0.75);
    	LoadFont("Common Bold")..{
            Text="Player 2";
            InitCommand=cmd(maxwidth,270;zoom,0.8;horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+20;diffuse,PlayerColor(PLAYER_2));
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };
        Def.Quad{
            InitCommand=cmd(horizalign,left;vertalign,top;xy,-135,-(SCREEN_HEIGHT/1.3)*0.5+50;setsize,90,5;diffuse,PlayerColor(PLAYER_2));
            OnCommand=cmd(cropright,1;sleep,1.7;linear,0.2;cropright,0);
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };        
    };
};