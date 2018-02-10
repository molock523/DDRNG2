local c;
local cf;
local player = Var "Player";
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local Pulse = THEME:GetMetric("Combo", "PulseCommand");
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand");

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom");
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom");
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt");

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom");
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom");

local t = Def.ActorFrame {
	Def.ActorFrame {
		Name="ComboFrame";
		LoadFont( "combo", "marv" ) .. {
			Name="NumberW1";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
            OffCommand= THEME:GetMetric("Combo", "NumberOffCommand");
		};
		LoadFont( "combo", "perf" ) .. {
			Name="NumberW2";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
            OffCommand= THEME:GetMetric("Combo", "NumberOffCommand");
		};
		LoadFont( "combo", "great" ) .. {
			Name="NumberW3";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
            OffCommand= THEME:GetMetric("Combo", "NumberOffCommand");
		};
		LoadFont( "combo", "good" ) .. {
			Name="NumberW4";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
            OffCommand= THEME:GetMetric("Combo", "NumberOffCommand");
		};
		LoadFont( "combo", "normal") .. {
			Name="NumberNormal";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
            OffCommand= THEME:GetMetric("Combo", "NumberOffCommand");
		};
		LoadActor("label")..{
			Name="Label";
			InitCommand=cmd(animate,false;zoom,0.5;addx,12);
			OnCommand = THEME:GetMetric("Combo", "LabelOnCommand");
            OffCommand= THEME:GetMetric("Combo", "LabelOffCommand");
		};
	};
	InitCommand = function(self)
    self:draworder(notefield_draw_order.under_field)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();

		cf.NumberW1:visible(false);
		cf.NumberW2:visible(false);
		cf.NumberW3:visible(false);
		cf.NumberW4:visible(false);
		cf.NumberNormal:visible(false);
		cf.Label:visible(false);
		cf.Label:setstate(4);
	end;
	ComboCommand=function(self, param)
		if param.Misses then
			cf.NumberW1:visible(false);
			cf.NumberW2:visible(false);
			cf.NumberW3:visible(false);
			cf.NumberW4:visible(false);
			cf.NumberNormal:visible(false);
			cf.Label:visible(false);
			cf.Label:setstate(4);
			return;
		end
		local iCombo = param.Misses or param.Combo;
		if not iCombo or iCombo < ShowComboAt then
			cf.NumberW1:visible(false);
			cf.NumberW2:visible(false);
			cf.NumberW3:visible(false);
			cf.NumberW4:visible(false);
			cf.NumberNormal:visible(false);
			cf.Label:visible(false);
			return;
		end
        if not player_config:get_data(player).Announcer == "Off" then
            if player_config:get_data(player).Announcer ~= "Cheer" then
                if  iCombo%120==0 or iCombo%220==0 or iCombo%320==0 or iCombo%420==0 or
                    iCombo%520==0 or iCombo%620==0 or iCombo%720==0 or iCombo%820==0 or
                    iCombo%920==0 or iCombo%1020==0 then
                    SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Cheer"))
                end
            elseif player_config:get_data(player).Announcer ~= "On" then
                if  iCombo%60==0 or iCombo%160==0 or iCombo%260==0 or iCombo%360==0 or
                    iCombo%460==0 or iCombo%560==0 or iCombo%660==0 or iCombo%760==0 or
                    iCombo%860==0 or iCombo%960==0 or iCombo%1060==0 then
                    SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_CommentHot"..math.random(1,9)))
                end
            elseif player_config:get_data(player).Announcer ~= "Combo" then            
                if iCombo%100==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment100"..math.random(1,2)))
                elseif iCombo%200==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment200"..math.random(1,2)))
                elseif iCombo%300==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment300"..math.random(1,2)))
                elseif iCombo%400==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment400"..math.random(1,2)))
                elseif iCombo%500==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment500"..math.random(1,2)))
                elseif iCombo%600==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment600"..math.random(1,2)))
                elseif iCombo%700==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment700"..math.random(1,2)))
                elseif iCombo%800==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment800"..math.random(1,2)))
                elseif iCombo%900==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment900"..math.random(1,2)))
                elseif iCombo%1000==0 then SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenGameplay_Comment1000"..math.random(1,2)))
                end
            end 
        end

		cf.Label:visible(true);
		cf.Label:setstate(4);

		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom );
		param.Zoom = clamp( param.Zoom, NumberMinZoom, NumberMaxZoom );

		param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom );
		param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom );

		cf.NumberW1:settext( string.format("%i", iCombo) );
		cf.NumberW2:settext( string.format("%i", iCombo) );
		cf.NumberW3:settext( string.format("%i", iCombo) );
		cf.NumberW4:settext( string.format("%i", iCombo) );
		cf.NumberNormal:settext( string.format("%i", iCombo) );
		-- FullCombo Rewards
		if param.FullComboW1 then
		
			cf.NumberW1:visible(true);
			cf.NumberW2:visible(false);
			cf.NumberW3:visible(false);
			cf.NumberW4:visible(false);
			cf.NumberNormal:visible(false);
			
			cf.Label:visible(true);
			cf.Label:setstate(0);
			
		elseif param.FullComboW2 then
		
			cf.NumberW1:visible(false);
			cf.NumberW2:visible(true);
			cf.NumberW3:visible(false);
			cf.NumberW4:visible(false);
			cf.NumberNormal:visible(false);
			
			cf.Label:visible(true);
			cf.Label:setstate(1);
			
		elseif param.FullComboW3 then
		
			cf.NumberW1:visible(false);
			cf.NumberW2:visible(false);
			cf.NumberW3:visible(true);
			cf.NumberW4:visible(false);
			cf.NumberNormal:visible(false);
			
			cf.Label:visible(true);
			cf.Label:setstate(2);
			
		elseif param.FullComboW4 then
		
			cf.NumberW1:visible(false);
			cf.NumberW2:visible(false);
			cf.NumberW3:visible(false);
			cf.NumberW4:visible(true);
			cf.NumberNormal:visible(false);
			
			cf.Label:visible(true);
			cf.Label:setstate(3);
			
		elseif param.Combo then
		
			cf.NumberW1:visible(false);
			cf.NumberW2:visible(false);
			cf.NumberW3:visible(false);
			cf.NumberW4:visible(false);
			cf.NumberNormal:visible(true);
			
			cf.Label:visible(true);
			cf.Label:setstate(4);
			
		else
		
			cf.NumberW1:visible(false);
			cf.NumberW2:visible(false);
			cf.NumberW3:visible(false);
			cf.NumberW4:visible(false);
			cf.NumberNormal:visible(false);
			
			cf.Label:visible(false);
			
		end
		Pulse( cf.NumberW1, param );
		Pulse( cf.NumberW2, param );
		Pulse( cf.NumberW3, param );
		Pulse( cf.NumberW4, param );
		Pulse( cf.NumberNormal, param );
		PulseLabel( cf.Label, param );
        
	end;
};

return t;