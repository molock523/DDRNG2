local t = {
	Def.ActorFrame{       
		ReverseChangedCommand = function(self, param)
			--SCREENMAN:SystemMessage(param.sign)
			MESSAGEMAN:Broadcast("ReverseChanged",{sign=param.sign})
		end       
	}
}

local function HoldJudge()
	return LoadActor(THEME:GetPathG("","HoldJudgment label"))..{
		InitCommand=function(self,param)
			self:visible(false):animate(false):zoom(0.5)
            if notefield_prefs_config:get_data(param.PlayerNumber).reverse == -1 then
                self:addy(-50)
            else
                self:addy(50)
            end
		end;
		ColumnJudgmentCommand=function(self, param)
			if param.tap_note_score or param.hold_note_score then
				if param.tap_note_score == "TapNoteScore_AvoidMine" or
                   param.hold_note_score == "HoldNoteScore_Held" then
					self:visible(true):setstate(0):stoptweening():diffusealpha(1):sleep(0.5):diffusealpha(0)
                elseif param.tap_note_score == "TapNoteScore_HitMine" or
                       param.hold_note_score == "HoldNoteScore_LetGo" then
                    self:visible(true):setstate(1):stoptweening():diffusealpha(1):sleep(0.5):diffusealpha(0)
				end
			end
		end;
	}
end

local function MarvStar()
	return LoadActor(THEME:GetPathG("","_notefield/_marvstar"))..{
        InitCommand=cmd(visible,false);
		ColumnJudgmentCommand=function(self, param)
			if param.tap_note_score then
				if param.tap_note_score == "TapNoteScore_W1" then
                    self:visible(true)
                    if notefield_prefs_config:get_data(param.PlayerNumber).reverse == -1 then
					self:zoom(0.5):accelerate(0.1):diffusealpha(1):addy(10):rotationz(10):decelerate(0.35):addy(100)
                        :rotationz(360):zoom(0.25):sleep(0.01):diffusealpha(0):addy(-110)
                    else
					self:zoom(0.5):accelerate(0.1):diffusealpha(1):addy(-10):rotationz(10):decelerate(0.35):addy(-100)
                        :rotationz(360):zoom(0.25):sleep(0.01):diffusealpha(0):addy(110)
                    end
				end
			end
		end;
	}
end

local function MineExplosion()
	return LoadActor(THEME:GetPathG("","_notefield/_mineexplosion"))..{
        InitCommand=function(self,param)
            self:visible(false)
            if notefield_prefs_config:get_data(param.PlayerNumber).reverse == -1 then
                self:vertalign(bottom):rotationx(180)
            else
                self:vertalign(top):rotationx(0)
            end
        end;
		ColumnJudgmentCommand=function(self, param)
			if param.tap_note_score then
				if param.tap_note_score == "TapNoteScore_HitMine" then
                    self:visible(true):finishtweening()
                        :blend("BlendMode_Add"):diffusealpha(1):zoomx(0):accelerate(0.05):zoomx(1):decelerate(0.25):zoomx(0.5)
                        :diffusealpha(0)
				end
			end
		end;
	}
end

t[#t+1] = HoldJudge()
t[#t+1] = MarvStar()
t[#t+1] = MineExplosion()

ColumnJudgmentCommand=function(self,param)
    if param.tap_note_score=="TapNoteScore_HitMine" then
        self:linear(0.05):diffusealpha(0):decelerate(0.8):diffusealpha(1)
    end
end

return t