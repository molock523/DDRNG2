return function(button_list, stepstype, skin_params)
	local ret = {}
	local rots  = {
		Left      = 90,
		Down      = 0,
		Up        = 180,
		Right     = 270,
	}
	local tap_redir= {}
	for i, button in ipairs(button_list) do
		local column_frame= Def.ActorFrame{
            InitCommand=function(self) self:draworder(notefield_draw_order.explosion) end,
			WidthSetCommand= function(self, param)
				param.column:set_layer_fade_type(self, "FieldLayerFadeType_Explosion")
			end,             
			Def.Sprite{
				Texture= "Down Tap Explosion", 
                InitCommand= function(self)
                    self:rotationz(rots[button] or 0)
                        :draworder(1)
                        :blend("BlendMode_Add")
                        :diffusealpha(0)
                end,
                HoldCommand=cmd(diffusealpha,0);
				ColumnJudgmentCommand= function(self, param)
                    if param.tap_note_score == "TapNoteScore_AvoidMine" or 
                    param.tap_note_score == "TapNoteScore_W5" or 
                    param.tap_note_score == "TapNoteScore_Miss" then
                        self:finishtweening()
                    else
                        self:stoptweening()
                            :zoom(1):diffusealpha(1):linear(0.06):zoom(1.1):linear(0.06):diffusealpha(0)
                    end
				end,
			},
			Def.Sprite{
				Texture= "Down Hold Explosion", 
                InitCommand= function(self)
                    self:rotationz(rots[button] or 0)
                        :draworder(999)
                        :blend("BlendMode_Add")
                        :diffusealpha(0)
                end,
                HoldCommand= function(self, param)
                    if param.start then
                        self:finishtweening()
                            :zoom(1.2):diffusealpha(1):visible(true)
                    elseif param.finished then
                        self:stopeffect():linear(0.06):diffusealpha(0)
                    else
                        self:zoom(1.2)
                    end
                end,
			},
			Def.Sprite{
                Texture= "Down Roll Explosion", 
                Frame0000=0;
                Delay0000=0.05;
                Frame0001=1;
                Delay0001=0.05;
                Frame0002=2;
                Delay0002=0.05;
                Frame0003=3;
                Delay0003=0.05;
                Frame0004=4;
                Delay0004=0.05;
                Frame0005=5;
                Delay0005=0.05;
                Frame0006=6;
                Delay0006=0.05;
                Frame0007=7;
                Delay0007=0.05;
                InitCommand= function(self)
                        self:draworder(999):blend("BlendMode_Add"):diffusealpha(0):fadebottom(0.2)
                end,
                HoldCommand= function(self, param)
                    if param.type == "TapNoteSubType_Roll" then
                        if param.start then
                            self:finishtweening()
                                :zoom(0.75):diffusealpha(1):visible(true)
                        elseif param.finished then
                            MESSAGEMAN:Broadcast("RollHit")
                            self:stopeffect():linear(0.06):diffusealpha(0)
                        else
                            self:zoom(0.75)
                        end
                    end
                end,
			},
		}
		ret[i]= column_frame
	end
	return ret
end
