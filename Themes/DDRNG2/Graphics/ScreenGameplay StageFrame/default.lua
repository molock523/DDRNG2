local t = Def.ActorFrame{
    Def.Quad{
        InitCommand=cmd(diffuse,color("#000000");setsize,SCREEN_WIDTH,62);
        OnCommand=cmd(playcommand,"Set";zoomy,0;sleep,0.15;linear,0.15;zoomy,1);
        OffCommand=cmd(sleep,0.9;accelerate,0.15;zoomy,0);
        SetCommand=function(self,param)
        local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
            if style == "TwoPlayersTwoSides" or style == "OnePlayerTwoSides" or style == "TwoPlayersSharedSides" then
                self:fadeleft(0);
                self:faderight(0);
            else
                if GAMESTATE:GetMasterPlayerNumber(1) then
                    self:fadeleft(0);
                    self:faderight(1);
                elseif GAMESTATE:GetMasterPlayerNumber(2) then
                    self:fadeleft(1);
                    self:faderight(0);
                else
                    self:fadeleft(0);
                    self:faderight(0);
                end
            end
            self:diffusealpha(0.5);
        end;
    };
	LoadActor("Frame")..{
		InitCommand=cmd();
        OnCommand=cmd(zoomy,0;sleep,0.3;decelerate,0.15;zoomy,1);
        OffCommand=cmd(sleep,0.75;accelerate,0.15;zoomy,0);
	};
	
};

return t;