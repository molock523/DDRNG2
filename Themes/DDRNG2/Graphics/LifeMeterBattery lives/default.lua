local player = Var "Player"

local t = Def.ActorFrame{

	-- Danger
	LoadActor(THEME:GetPathG("StreamDisplay","danger"))..{
		InitCommand=function(self)
			self:texcoordvelocity(1.5,0)
			self:zoom(1)
			self:visible(false)
		end;
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then
                if params.LivesLeft <= 1 then
                    self:visible(true)
                else
                    self:visible(false)
                end
            end
		end;
	};
	-- Normal
	LoadActor(THEME:GetPathG("StreamDisplay","normal"))..{
		InitCommand=function(self)
			self:texcoordvelocity(0.8,0)
			self:zoom(1)
			self:visible(false)
		end;
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then
                if params.LivesLeft >= 2 then
                    self:visible(true)
                else
                    self:visible(false)
                end
            end
		end;
	};
	-- Hot
	LoadActor(THEME:GetPathG("StreamDisplay","hot"))..{
		InitCommand=function(self)
			self:texcoordvelocity(0.8,0)
			self:zoom(1)
			self:visible(true)
		end;
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then
				if params.LivesLeft >= 4 then
					self:visible(true)
				else
					self:visible(false)
				end
			end
		end;
	};    
	-- Crop 4
	Def.Quad{
		InitCommand=cmd(horizalign,right;x,374/2;diffusetopedge,color("#707171");diffusebottomedge,color("#404040"));
		BeginCommand=function(self,params)
			local screen = SCREENMAN:GetTopScreen();
			local glifemeter = screen:GetLifeMeter(player);
			assert(glifemeter);
            if glifemeter:GetTotalLives() >= 4 then
                self:zoomto(0,28);
            elseif glifemeter:GetTotalLives() == 3 then
                self:zoomto(374/2-187,28);
            elseif glifemeter:GetTotalLives() == 2 then
                self:zoomto(374/3-187,28);
            elseif glifemeter:GetTotalLives() == 1 then
                self:zoomto(374/4-187,28);
            elseif glifemeter:GetTotalLives() == 0 then
                self:zoomto(374,28);
            end
		end;
		LifeChangedMessageCommand=function(self,params)
			if params.Player ~= player then return end;
			self:finishtweening();
			self:accelerate(0.2);
			if params.LivesLeft > 4 then 
				self:zoomto(0,28);
			else
				self:zoomto(374-(params.LivesLeft)*374/4,28);
			end;
		end;
	};
	LoadActor(THEME:GetPathG("LifeMeterBar","over/Glow"))..{
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.5);
	};    
	Def.Sprite {
		BeginCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local glifemeter = screen:GetLifeMeter(player);
			assert(glifemeter);
			local style = GAMESTATE:GetCurrentStyle():GetStyleType()
            if glifemeter:GetTotalLives() >= 5 then
                self:Load(THEME:GetPathG("LifeMeterBattery","lives/Frame_8"));
            else
                self:Load(THEME:GetPathG("LifeMeterBattery","lives/Frame_4"));
            end
		end;
	};
};

return t;