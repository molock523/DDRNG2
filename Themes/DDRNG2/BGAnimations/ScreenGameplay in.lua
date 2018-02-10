local t = Def.ActorFrame{};

--overlay
t[#t+1] = LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"))..{
    InitCommand=cmd(diffusealpha,1);
    OnCommand=cmd(accelerate,0.75;diffusealpha,0);
};

t[#t+1] = Def.Banner{
    OnCommand=cmd(diffusealpha,1;playcommand,"Set";sleep,3;accelerate,0.75;zoomx,0.8;zoomy,0.5;diffusealpha,0);    
    SetCommand=function(self)
        if song then
            if song:GetJacketPath()~=nil then
                self:Load(song:GetJacketPath())
            elseif song:GetBackgroundPath()~=nil then
                self:Load(song:GetBackgroundPath())
            else
                self:Load(THEME:GetPathG("","Common fallback jacket"))
            end
        end
    end;
};

return t;