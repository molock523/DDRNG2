local t = Def.ActorFrame {};

local screen_name= Var("LoadingScreen")


if screen_name ~= "ScreenSelectProfile" or "ScreenProfileCustomize" then
t[#t+1] = Def.ActorFrame {
InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25;zwrite,true;ztest,true;draworder,1;z,10); 
-- icon
    LoadActor(THEME:GetPathG("","header_icons/"..screen_name or "None"))..{
        InitCommand=function(self)
            self:diffuse(color("#ffffff")):zoom(0.3):addx(9):addy(9)
        end;
        OnCommand=cmd(rotationz,-90;zoom,0.15;diffusealpha,0;sleep,0.9;spring,0.3;zoom,0.25;diffusealpha,1;rotationz,0);
        OffCommand=cmd(accelerate,0.5;addx,-50;diffusealpha,0);        
    };
-- text
    LoadFont("Common Large Bold")..{
        Name="HeaderText";       
        InitCommand=cmd(horizalign,left;vertalign,top;diffuse,color("#ffffff");zoom,0.3);
        OffCommand=cmd(accelerate,0.5;addx,-50;diffusealpha,0);
        OnCommand=function(self)
            self:settext(Screen.String("HeaderText"));
            self:addx(SCREEN_WIDTH/4):diffusealpha(0):decelerate(0.8):addx(-SCREEN_WIDTH/4):diffusealpha(1):accelerate(0.15):addx(35);           
        end;
        UpdateScreenHeaderMessageCommand=function(self,param)
            self:settext(param.Header);
        end;
    };
};
    
t.BeginCommand=function(self) self:SetUpdateFunction( Update ); end
end
return t;
