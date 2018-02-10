local menu_height= 300
local menu_width= 200
local menu_x=_screen.w/2-335
local menu= setmetatable({}, nesty_menu_stack_mt)

local explanations= {}
local ready_indicators= {}

local appearance_options= {
    nesty_options.choices_config_val(theme_config, "UIColor", {"Light", "Dark"}),
	nesty_options.choices_config_val(theme_config, "MusicWheel", {"Grid", "List", "X2", "Old-style"}),
}

local arcade_options= {
    nesty_options.bool_config_val(theme_config, "Announcer"), 
    nesty_options.bool_config_val(theme_config, "ShowSelectProfile"), 
}

local console_options= {
    nesty_options.choices_config_val(theme_config, "ConsoleType", {"Home", "e-AMUSEMENT", "No e-AMUSEMENT"}),
}

local base_options={
    nesty_options.submenu("Appearance Options", appearance_options),
    nesty_options.submenu("Arcade Options", arcade_options),
    nesty_options.submenu("Console Options", console_options),
}

local player_ready= {}

local function exit_if_both_ready()
		if not player_ready then return end
	SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
end

local prev_explanation= {}
local function update_explanation()
	local cursor_item= menu:get_cursor_item()
	if cursor_item then
		local new_expl= cursor_item.name or cursor_item.text
		local expl_com= "change_explanation"
		if cursor_item.explanation then
			new_expl= cursor_item.explanation
			expl_com= "translated_explanation"
		end
		if new_expl ~= prev_explanation then
			prev_explanation= new_expl
			explanations[pn]:playcommand(expl_com, {text= new_expl})
		end
	end
end

local function input(event)
	if event.type == "InputEventType_Release" then return end
	local button= event.GameButton
	if not button then return end
	local menu_action= menu:interpret_code(button)
	if menu_action == "close" then
		local metrics_need_to_be_reloaded= theme_config:check_dirty()
		theme_config:save()
		if metrics_need_to_be_reloaded then
			THEME:ReloadMetrics()
		end
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
	end
end

local frame= Def.ActorFrame{
	OnCommand= function(self)
		menu:push_menu_stack(nesty_option_menus.menu, base_options, "Exit Menu")
		menu:update_cursor_pos()
		SCREENMAN:GetTopScreen():AddInputCallback(input)
	end,
}
local item_params= {
    frame_commands={
        OnCommand=cmd(setsize,menu_width,19;diffuse,color("#eaeaea"));
        GainFocusCommand=cmd(diffuse,color("#2e2e2e"));
        LoseFocusCommand=cmd(diffuse,color("#eaeaea"));
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    },
	text_commands= {
		Font= "Common Normal", OnCommand=cmd(diffuse,color("#2e2e2e"));
        GainFocusCommand=cmd(diffuse,color("#ffffff"));
        LoseFocusCommand=cmd(diffuse,color("#2e2e2e"));
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
	text_width= .7,
	value_text_commands= {
		Font= "Common Normal", OnCommand=cmd(diffuse,color("#2e2e2e"));
        GainFocusCommand=cmd(diffuse,color("#ffffff"));
        LoseFocusCommand=cmd(diffuse,color("#2e2e2e"));
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
	value_width= .25,
	type_images= {
		bool= THEME:GetPathG("", "menu_icons/bool"),
		choice= THEME:GetPathG("", "menu_icons/bool"),
		menu= THEME:GetPathG("", "menu_icons/menu"),
	},
	value_image_commands= {
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
}
    frame[#frame+1] = LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"))..{
    OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,0.5;draworder,-1);
    OffCommand=cmd(sleep,0.2;linear,0.5;diffusealpha,0);
    };
	frame[#frame+1]= menu:create_actors{
		x= menu_x, y= _screen.cy-200+20, width= menu_width, height= menu_height,
		translation_section= "OptionNames",
		num_displays= 1, pn= pn, el_height= 20,
		menu_sounds= {
			pop= THEME:GetPathS("_options", "menus"),
			push= THEME:GetPathS("_options", "menus"),
			act= THEME:GetPathS("_options", "change"),
			move= THEME:GetPathS("_options", "next"),
			move_up= THEME:GetPathS("_options", "next"),
			move_down= THEME:GetPathS("_options", "next"),
			inc= THEME:GetPathS("_options", "change"),
			dec= THEME:GetPathS("_options", "change"),
		},
		display_params= {
			el_zoom= .55, 
            item_params= item_params, 
            item_mt= nesty_items.value,
            heading_actor= Def.ActorFrame{
                OffCommand=cmd(linear,0.2;diffusealpha,0);
                Def.Quad{
                    InitCommand=cmd(setsize,200/0.55,19/0.55;addy,30/0.55;diffuse,PlayerColor(PLAYER_1))
                },
                Def.BitmapText{
                    Font= "Common Bold", 
                    OnCommand=cmd(diffuse,color("#ffffff");addy,30/0.55;addx,-menu_width/2/0.55+5;horizalign,left); 
                    SetCommand=function(self,params)
                    if params.text ~= "" or nil then
                        self:settext(params.text..":")
                    else
                        self:settext("Menu")
                    end
                    end;
                },               
            },
            status_actor= Def.BitmapText{
                Font= "Common Bold", 
                OnCommand=cmd(diffuse,color("#ffffff");addy,10;addx,menu_width/2-10;horizalign,right); 
                OffCommand=cmd(linear,0.2;diffusealpha,0);
                SetCommand=function(self,params)
                    self:settext(params.text)
                end;
            }, 
			on= function(self)
				self:diffusealpha(0):sleep(0.75):linear(0.2):diffusealpha(1):draworder(1)
			end
            },
	}
    --explanation
    frame[#frame+1]= Def.Quad{
        InitCommand=function(self)
        explanations= self
        self:xy(menu_x,_screen.cy+142+20-10+3):setsize(menu_width,66)
            :diffuse(color("#000000")):diffusealpha(0.15):zoomy(1)
        end;
        show_readyCommand=cmd(linear,0.2;zoomy,0);
        hide_readyCommand=cmd(linear,0.2;zoomy,1);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    }
	frame[#frame+1]= Def.BitmapText{
		Font= "Common Normal", InitCommand= function(self)
			explanations= self
			self:xy(menu_x-(menu_width/2)+10,_screen.cy+133)
				:wrapwidthpixels(menu_width/.6):zoom(.5)
				:horizalign(left):vertalign(top):diffuse(color("#ffffff"))
		end,
		change_explanationCommand= function(self, param)
			local text=""
			if THEME:HasString("notefield_explanations", param.text) then
				text= THEME:GetString("notefield_explanations", param.text)
			end
			self:playcommand("translated_explanation", {text= text})
		end,
		translated_explanationCommand= function(self, param)
			self:stoptweening():settext(param.text):cropright(1):linear(.5):cropright(0)
		end,
        show_readyCommand=cmd(linear,0.2;diffusealpha,0);
        hide_readyCommand=cmd(linear,0.2;diffusealpha,1);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	}
	frame[#frame+1]= Def.BitmapText{
		Font= "Common Bold", Text= "READY", InitCommand= function(self)
			ready_indicators= self
			self:xy(menu_x,_screen.cy+150):zoom(0.8):diffuse(PlayerColor(pn)):diffusealpha(0)
		end,
		show_readyCommand= function(self)
			self:stoptweening():decelerate(.2):diffusealpha(1)
		end,
		hide_readyCommand= function(self)
			self:stoptweening():accelerate(.2):diffusealpha(0)
		end,
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	}    

return frame
