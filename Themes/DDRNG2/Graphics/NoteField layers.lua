local layers= {
	Def.Quad{
		InitCommand= function(self)
			self:diffuse(color("#000000")):SetHeight(4096):draworder(notefield_draw_order.board)
		end,
		PlayerStateSetCommand= function(self, param)
			local pn= param.PlayerNumber
			local filter= player_config:get_data(pn).ScreenFilter
            if filter=="Dark" then
                self:diffusealpha(0.25)
            elseif filter=="Darker" then
                self:diffusealpha(0.5)
            elseif filter=="Darkest" then
                self:diffusealpha(0.75)
            else
                self:diffusealpha(0)
            end
		end,
		WidthSetCommand= function(self, param)
			self:SetWidth(param.width+8)         
		end,       
	}
}

return layers
