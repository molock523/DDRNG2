local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame{
InitCommand=cmd(xy,THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")+30,_screen.cy);   
    -- intro
    Def.Quad{
    InitCommand=cmd(setsize,200/(0.75*0.75),66/0.75;diffuse,color("#000000");diffusealpha,0.15); 
    OnCommand=cmd(zoomy,0;sleep,4;sleep,0.2;linear,0.2;zoomy,1;sleep,9.5;linear,0.2;zoomy,0);
    };
    LoadFont("Common Bold")..{
    Text=THEME:GetString("ScreenHowToPlay","Title");
    InitCommand=cmd(zoom,0.75;addx,-100/0.75;addy,-30;horizalign,left;vertalign,top;diffusealpha,0);
    OnCommand=cmd(sleep,4;sleep,0.5;linear,0.1;diffusealpha,1;sleep,9;linear,0.2;diffusealpha,0);
    };    
    LoadFont("Common Normal")..{
    Text=THEME:GetString("ScreenHowToPlay","Intro");
    InitCommand=cmd(zoom,0.75*0.75;addx,-100/0.75;horizalign,left;vertalign,top;cropright,1);
    OnCommand=cmd(diffusealpha,1;sleep,4;sleep,0.5;cropright,1;linear,0.5;cropright,0;sleep,4;linear,0.2;diffusealpha,0);
    };
    LoadFont("Common Normal")..{
    Text=THEME:GetString("ScreenHowToPlay","Feet");
    InitCommand=cmd(zoom,0.75*0.75;addx,-100/0.75;horizalign,left;vertalign,top;cropright,1);
    OnCommand=cmd(diffusealpha,1;sleep,8.5;sleep,0.5;cropright,1;linear,0.5;cropright,0;sleep,4;linear,0.2;diffusealpha,0);
    };    
    -- tap    
    Def.Quad{
    InitCommand=cmd(setsize,200/(0.75*0.75),66/0.75;diffuse,color("#000000");diffusealpha,0.15);  
    OnCommand=cmd(zoomy,0;sleep,18.3;sleep,0.2;linear,0.2;zoomy,1;sleep,5;linear,0.2;zoomy,0);
    };
    LoadFont("Common Bold")..{
    Text=THEME:GetString("ScreenHowToPlay","Title");
    InitCommand=cmd(zoom,0.75;addx,-100/0.75;addy,-30;horizalign,left;vertalign,top;diffusealpha,0);
    OnCommand=cmd(sleep,18.3;sleep,0.5;linear,0.1;diffusealpha,1;sleep,4.5;linear,0.2;diffusealpha,0);
    };     
    LoadFont("Common Normal")..{
    Text=THEME:GetString("ScreenHowToPlay","Tap");
    InitCommand=cmd(zoom,0.75*0.75;addx,-100/0.75;horizalign,left;vertalign,top;cropright,1);
    OnCommand=cmd(diffusealpha,1;sleep,18.3;sleep,0.5;cropright,1;linear,0.5;cropright,0;sleep,4;linear,0.2;diffusealpha,0);
    };
    -- tap/step zone
    Def.ActorFrame{
        InitCommand=cmd(xy,-(200/(0.75*0.75)/2)-15,-200-48;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,18.3;sleep,0.2;linear,0.1;cropright,0;sleep,4;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,18.3;sleep,0.2;linear,0.1;cropbottom,0;sleep,4;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,(200/(0.75*0.75)/2)+15,-200+48;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,18.3;sleep,0.2;linear,0.1;cropleft,0;sleep,4;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,18.3;sleep,0.2;linear,0.1;croptop,0;sleep,4;linear,0.1;croptop,1);
        };
    };
    -- tap/pad
    Def.ActorFrame{
        InitCommand=cmd(addx,395-40;addy,157-24;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,18.3;sleep,0.2;linear,0.1;cropright,0;sleep,4;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,18.3;sleep,0.2;linear,0.1;cropbottom,0;sleep,4;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(addx,395+40;addy,157+24;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,18.3;sleep,0.2;linear,0.1;cropleft,0;sleep,4;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,18.3;sleep,0.2;linear,0.1;croptop,0;sleep,4;linear,0.1;croptop,1);
        };
    };    
    -- jump
    Def.Quad{
    InitCommand=cmd(setsize,200/(0.75*0.75),66/0.75;diffuse,color("#000000");diffusealpha,0.15); 
    OnCommand=cmd(zoomy,0;sleep,31.3;sleep,0.2;linear,0.2;zoomy,1;sleep,5;linear,0.2;zoomy,0);
    };
    LoadFont("Common Bold")..{
    Text=THEME:GetString("ScreenHowToPlay","Title");
    InitCommand=cmd(zoom,0.75;addx,-100/0.75;addy,-30;horizalign,left;vertalign,top;diffusealpha,0);
    OnCommand=cmd(sleep,31.3;sleep,0.5;linear,0.1;diffusealpha,1;sleep,4.5;linear,0.2;diffusealpha,0);
    };     
    LoadFont("Common Normal")..{
    Text=THEME:GetString("ScreenHowToPlay","Jump");
    InitCommand=cmd(zoom,0.75*0.75;addx,-100/0.75;horizalign,left;vertalign,top;cropright,1);
    OnCommand=cmd(diffusealpha,1;sleep,31.3;sleep,0.5;cropright,1;linear,0.5;cropright,0;sleep,4;linear,0.2;diffusealpha,0);
    };
    -- jump/pad
    Def.ActorFrame{
        InitCommand=cmd(addx,395-100-40;addy,157+30-24;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,31.3;sleep,0.2;linear,0.1;cropright,0;sleep,4;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,31.3;sleep,0.2;linear,0.1;cropbottom,0;sleep,4;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(addx,395-100+40;addy,157+30+24;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,31.3;sleep,0.2;linear,0.1;cropleft,0;sleep,4;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,31.3;sleep,0.2;linear,0.1;croptop,0;sleep,4;linear,0.1;croptop,1);
        };
    }; 
    Def.ActorFrame{
        InitCommand=cmd(addx,395+85-40;addy,157+30-24;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,31.3;sleep,0.2;linear,0.1;cropright,0;sleep,4;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,31.3;sleep,0.2;linear,0.1;cropbottom,0;sleep,4;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(addx,395+85+40;addy,157+30+24;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,31.3;sleep,0.2;linear,0.1;cropleft,0;sleep,4;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,31.3;sleep,0.2;linear,0.1;croptop,0;sleep,4;linear,0.1;croptop,1);
        };
    };     
    -- miss
    Def.Quad{
    InitCommand=cmd(setsize,200/(0.75*0.75),66/0.75;diffuse,color("#000000");diffusealpha,0.15);   
    OnCommand=cmd(zoomy,0;sleep,44.3;sleep,0.2;linear,0.2;zoomy,1;sleep,5;linear,0.2;zoomy,0);
    };
    LoadFont("Common Bold")..{
    Text=THEME:GetString("ScreenHowToPlay","Title");
    InitCommand=cmd(zoom,0.75;addx,-100/0.75;addy,-30;horizalign,left;vertalign,top;diffusealpha,0);
    OnCommand=cmd(sleep,44.3;sleep,0.5;linear,0.1;diffusealpha,1;sleep,4.5;linear,0.2;diffusealpha,0);
    };     
    LoadFont("Common Normal")..{
    Text=THEME:GetString("ScreenHowToPlay","Miss");
    InitCommand=cmd(zoom,0.75*0.75;addx,-100/0.75;horizalign,left;vertalign,top;cropright,1);
    OnCommand=cmd(diffusealpha,1;sleep,44.3;sleep,0.5;cropright,1;linear,0.5;cropright,0;sleep,4;linear,0.2;diffusealpha,0);
    };
    -- miss/life
    Def.ActorFrame{
        InitCommand=cmd(xy,-50-30,-325-26;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,44.3;sleep,0.2;linear,0.1;cropright,0;sleep,4;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,44.3;sleep,0.2;linear,0.1;cropbottom,0;sleep,4;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,-50+30,-325+26;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,44.3;sleep,0.2;linear,0.1;cropleft,0;sleep,4;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,44.3;sleep,0.2;linear,0.1;croptop,0;sleep,4;linear,0.1;croptop,1);
        };
    };    
    -- fail
    Def.Quad{
    InitCommand=cmd(setsize,200/(0.75*0.75),66/0.75;diffuse,color("#000000");diffusealpha,0.15); 
    OnCommand=cmd(zoomy,0;sleep,52.3;sleep,0.2;linear,0.2;zoomy,1;sleep,5;linear,0.2;zoomy,0);
    };
    LoadFont("Common Bold")..{
    Text=THEME:GetString("ScreenHowToPlay","Title");
    InitCommand=cmd(zoom,0.75;addx,-100/0.75;addy,-30;horizalign,left;vertalign,top;diffusealpha,0);
    OnCommand=cmd(sleep,52.3;sleep,0.5;linear,0.1;diffusealpha,1;sleep,4.5;linear,0.2;diffusealpha,0);
    };     
    LoadFont("Common Normal")..{
    Text=THEME:GetString("ScreenHowToPlay","Fail");
    InitCommand=cmd(zoom,0.75*0.75;addx,-100/0.75;horizalign,left;vertalign,top;cropright,1);
    OnCommand=cmd(diffusealpha,1;sleep,52.3;sleep,0.5;cropright,1;linear,0.5;cropright,0;sleep,4;linear,0.2;diffusealpha,0);
    };
    -- fail/dance gauge
    Def.ActorFrame{
        InitCommand=cmd(xy,-(200/(0.75*0.75)/2)-40-30-11,-325-26;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,left;vertalign,top);
            OnCommand=cmd(cropright,1;sleep,52.3;sleep,0.2;linear,0.1;cropright,0;sleep,4;linear,0.1;cropright,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,left;vertalign,top);
            OnCommand=cmd(cropbottom,1;sleep,52.3;sleep,0.2;linear,0.1;cropbottom,0;sleep,4;linear,0.1;cropbottom,1);
        };
    };
    Def.ActorFrame{
        InitCommand=cmd(xy,(200/(0.75*0.75)/2)+25+30-11,-325+26;diffuseshift;effectcolor2,color("#ffffff");effectcolor1,color("#c8006a");effectperiod,0.25);
        Def.Quad{
            InitCommand=cmd(setsize,20,2;horizalign,right;vertalign,bottom);
            OnCommand=cmd(cropleft,1;sleep,52.3;sleep,0.2;linear,0.1;cropleft,0;sleep,4;linear,0.1;cropleft,1);
        };
        Def.Quad{
            InitCommand=cmd(setsize,2,20;horizalign,right;vertalign,bottom);
            OnCommand=cmd(croptop,1;sleep,52.3;sleep,0.2;linear,0.1;croptop,0;sleep,4;linear,0.1;croptop,1);
        };
    };    
};
return t;