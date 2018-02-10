local t = Def.ActorFrame {
OffFocusedCommand=function(self)
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectStyle_CommentVersus"))
end;
};
t[#t+1] = Def.ActorFrame {
    OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1);  
    OffUnfocusedCommand=cmd(diffuse,color("0.75,0.75,0.75,1");accelerate,0.8;addx,-_screen.w/4;diffusealpha,0);
    OffFocusedCommand=cmd(accelerate,0.8;addx,-_screen.w/7;diffusealpha,0);
    GainFocusCommand=cmd(diffuse,color("1,1,1,1"));
    LoseFocusCommand=cmd(diffuse,color("0.8,0.8,0.8,1"));     
    --Default
    LoadActor(THEME:GetPathG("","_machine/pads_overlay.png"))..{
        InitCommand=cmd(vertalign,bottom;addy,100;diffusealpha,1);
        OnCommand=cmd(glowshift;effectperiod,1);
        GainFocusCommand=cmd(diffusealpha,0.5);
        LoseFocusCommand=cmd(diffusealpha,0);
    };     
    LoadFont("Common Large Bold")..{
        Text="VERSUS\nPLAY";
        OnCommand=cmd(horizalign,left;vertalign,bottom;addy,-30;addx,-492/2);
        GainFocusCommand=cmd(diffuse,color("1,1,1,1"));
        LoseFocusCommand=cmd(diffuse,color("0.75,0.75,0.75,1"));  
    };    
    Def.Sprite{
        InitCommand=cmd(addx,-80;vertalign,bottom;addy,50);  
        OnCommand=function(self)
            if GAMESTATE:GetMasterPlayerNumber(PLAYER_1) then
                self:Load(THEME:GetPathG("","_characters/afro.png"));
            elseif GAMESTATE:GetMasterPlayerNumber(PLAYER_2) then
                self:Load(THEME:GetPathG("","_characters/emi.png"));
                self:addy(30);
            end
        end;       
    };
    Def.Sprite{
        InitCommand=cmd(addx,50;vertalign,bottom);  
        OnCommand=function(self)
            if GAMESTATE:GetMasterPlayerNumber(PLAYER_1) then
                self:Load(THEME:GetPathG("","_characters/emi.png"));
                self:addy(60);
            elseif GAMESTATE:GetMasterPlayerNumber(PLAYER_2) then
                self:Load(THEME:GetPathG("","_characters/afro.png"));
            end
        end;         
    };
    LoadFont("Common Normal")..{
        Text="Play with a friend\nusing one standard arrow dance pad each";
        OnCommand=cmd(horizalign,right;vertalign,top;addy,120;addx,492/2);
        GainFocusCommand=cmd(diffusealpha,1;croptop,1;cropright,1;linear,0.2;croptop,0;cropright,0);
        LoseFocusCommand=cmd(diffusealpha,0);
        OffCommand=cmd(diffusealpha,0);
    };   
};    		
return t;