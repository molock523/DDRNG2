return function(button_list, stepstype, skin_parameters)
	local ret= {}
	local rots= {Left= 90, Down= 0, Up= 180, Right= 270}
	for i, button in ipairs(button_list) do
		ret[i]= Def.ActorFrame{
			InitCommand= function(self)
				self:rotationz(rots[button] or 0):effectclock("beat")
					:draworder(notefield_draw_order.receptor)
			end,
			WidthSetCommand= function(self, param)
				param.column:set_layer_fade_type(self, "FieldLayerFadeType_Receptor")
			end,
			BeatUpdateCommand= function(self, param)
				self:glow{1, 1, 1, (1 - param.beat)}
				if param.pressed then
					self:playcommand("Press")
				elseif param.lifted then
					self:playcommand("Lift")
				end
			end,
			Def.Sprite{
				Texture= "receptor 2x1", 
                InitCommand=function(self)
                    self:animate(false);
                end,
			},
			Def.Sprite{
				Texture= "press",
                InitCommand= function(self)
					self:visible(false):diffusealpha(0)
				end,
				PressCommand= function(self)
					self:visible(true):finishtweening():zoom(1):diffusealpha(1)
				end,
				LiftCommand= function(self)
					self:stoptweening():decelerate(0.2):diffusealpha(0):zoom(1.02)
				end,
				hideCommand= function(self)
					self:visible(false)
				end,                
			},            
		}
	end
	return ret
end
