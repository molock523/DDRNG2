local stage = GAMESTATE:GetCurrentStage()
local song = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();

local t = Def.ActorFrame {};

t[#t+1] = Def.Banner{
    InitCommand=cmd(scaletoclipped,400,400;Center);
    OnCommand=cmd(playcommand,"Set";addz,_screen.w/8;diffusealpha,0;decelerate,0.8;addz,-_screen.w/8;diffusealpha,1);
    SetCommand=function(self)
        if song then
            if GAMESTATE:IsCourseMode() then
                if song:GetBackgroundPath()~=nil then
                    self:Load(song:GetBackgroundPath())
                else
                    self:Load(THEME:GetPathG("","Common fallback jacket"))
                end
            else
                if song:GetJacketPath()~=nil then
                    self:Load(song:GetJacketPath())
                elseif song:GetBackgroundPath()~=nil then
                    self:Load(song:GetBackgroundPath())
                else
                    self:Load(THEME:GetPathG("","Common fallback jacket"))
                end
            end
        end
    end;
};
t[#t+1] = Def.ActorFrame{
    InitCommand=cmd();
    OffCommand=cmd(linear,0.2;diffusealpha,0);
    -- stage
    LoadFont("Common Bold")..{
        Text=THEME:GetString("ScreenStageInformation",stage);   
        InitCommand=function(self)
            if aspectratio()=="16:9" then
                self:horizalign(right):vertalign(bottom):y(_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+32+20)
            elseif aspectratio()=="4:3" then
                self:horizalign(left):vertalign(bottom):y(_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+32-20):wrapwidthpixels(100)
            end
            self:zoom(1):rotationz(-90):x(_screen.cx-(SCREEN_WIDTH/1.3*0.5)-11+10-2)
        end;
        OnCommand=cmd(cropright,1;sleep,0.2;linear,0.2;cropright,0);   
    };    
    LoadFont("Common Bold")..{
        Text=": "..song:GetDisplayFullTitle();
        InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+105+10,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2;horizalign,left;vertalign,top;zoom,1);
        OnCommand=cmd(cropright,1;sleep,1.5;linear,0.2;cropright,0);
    };
    LoadFont("Common Bold")..{
        Text="";
        InitCommand=cmd(xy,_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+120+10,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2+30;horizalign,left;vertalign,top;zoom,0.5);
        OnCommand=cmd(cropbottom,1;sleep,1.7;linear,0.2;cropbottom,0);
        SetCommand=function(self)
            if not GAMESTATE:IsCourseMode() then
                self:settext(song:GetDisplayArtist())
            end
        end;
    };
};

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
    if theme_config:get_data().Mode ~= "Starter" then
        t[#t+1] = LoadActor("info.lua", pn);
    end
end

return t
