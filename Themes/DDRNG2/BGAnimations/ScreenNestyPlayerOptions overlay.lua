local menu_height= 300
local menu_width= 200
local menu_x= {
	[PLAYER_1]= _screen.w/2-335,
	[PLAYER_2]= _screen.w/2+335,
}
local menus= {}
for i, pn in ipairs(GAMESTATE:GetHumanPlayers()) do
	menus[pn]= setmetatable({}, nesty_menu_stack_mt)
end
local explanations= {}
local ready_indicators= {}

local mods_appearance= {
    nesty_options.bool_config_val(notefield_prefs_config, "hidden"),
	nesty_options.bool_config_val(notefield_prefs_config, "sudden"),
    nesty_options.bool_config_val(notefield_prefs_config, "stealth"),
}

local mods_boost= {
    nesty_options.bool_player_mod_val("boost"),
    nesty_options.bool_player_mod_val("brake"),
    nesty_options.bool_player_mod_val("wave"),
}

local mods_turn= {
	nesty_options.bool_player_mod_val("Mirror"),
	nesty_options.bool_player_mod_val("Left"),
	nesty_options.bool_player_mod_val("Right"),
	nesty_options.bool_player_mod_val("Shuffle"),
}

local life_type_enum= {"LifeType_Bar", "LifeType_Battery"}
local life_options= {
	nesty_options.enum_player_mod_single_val("bar_type", "LifeType_Bar", "LifeSetting"),
	nesty_options.enum_player_mod_single_val("battery_type", "LifeType_Battery", "LifeSetting"),
	nesty_options.float_player_mod_val("BatteryLives", 0, 0, 0, 1, 8, 4),
}

local mods_config={
	{name= "noteskin", translatable= true, menu= nesty_option_menus.noteskins},      
	nesty_options.choices_config_val(player_config, "ScreenFilter", {"Off", "Dark", "Darker", "Darkest"}),  
    nesty_options.bool_config_val(player_config, "Guidelines"),
    nesty_options.bool_config_val(player_config, "CalorieDisplay"),
    nesty_options.bool_config_val(player_config, "EXScore"),
    nesty_options.bool_config_val(player_config, "StageStars"),
    nesty_options.choices_config_val(player_config, "Target", {"Off", "Personal", "Local", "World"}),
    nesty_options.bool_config_val(player_config, "Pacemaker"), 
   -- nesty_options.choices_config_val(player_config, "Announcer", {"On", "Combo", "Cheer", "Off"}),
    --nesty_options.choices_config_val(player_config, "Character", {"Off","Afro","Alice","Babylon","Bonnie","Concent","Emi","Gus","Jenny","Julio","Rage","Rinon","Ruby","Yuni","Zero","Zukin"}),    
}

local base_options={}
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
if PROFILEMAN:IsPersistentProfile(pn) then
    base_options= {
        notefield_prefs_speed_mod_menu("Multiple"), 
        nesty_options.submenu("Appearance", mods_appearance),
        nesty_options.submenu("Turn", mods_turn),
        nesty_options.bool_config_val(notefield_prefs_config, "dark"),
        nesty_options.float_config_toggle_val(notefield_prefs_config, "reverse", -1, 1),  
        {name= "noteskin_params", translatable= true, menu= nesty_option_menus.menu,
         args= gen_noteskin_param_menu, req_func= show_noteskin_param_menu},    
        nesty_options.bool_player_mod_val("Little"),
        nesty_options.bool_player_mod_val("NoHolds"),
        nesty_options.bool_player_mod_val("NoJumps"),
        nesty_options.bool_player_mod_val("NoMines"),
        nesty_options.bool_player_mod_val("NoRolls"),
        nesty_options.submenu("life_options", life_options),
        nesty_options.submenu("Special Options", mods_config),
    }
else
    base_options= {
        notefield_prefs_speed_mod_menu("Multiple"), 
        nesty_options.submenu("Appearance", mods_appearance),
        nesty_options.submenu("Turn", mods_turn),
        nesty_options.bool_config_val(notefield_prefs_config, "dark"),
        nesty_options.float_config_toggle_val(notefield_prefs_config, "reverse", -1, 1),  
        {name= "noteskin_params", translatable= true, menu= nesty_option_menus.menu,
         args= gen_noteskin_param_menu, req_func= show_noteskin_param_menu},    
        nesty_options.bool_player_mod_val("Little"),
        nesty_options.bool_player_mod_val("NoHolds"),
        nesty_options.bool_player_mod_val("NoJumps"),
        nesty_options.bool_player_mod_val("NoMines"),
        nesty_options.bool_player_mod_val("NoRolls"),
        nesty_options.submenu("life_options", life_options),
    }
end
end

local player_ready= {}

local function exit_if_both_ready()
	for i, pn in ipairs(GAMESTATE:GetHumanPlayers()) do
		if not player_ready[pn] then return end
	end
	SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
end

local prev_explanation= {}
local function update_explanation(pn)
	local cursor_item= menus[pn]:get_cursor_item()
	if cursor_item then
		local new_expl= cursor_item.name or cursor_item.text
		local expl_com= "change_explanation"
		if cursor_item.explanation then
			new_expl= cursor_item.explanation
			expl_com= "translated_explanation"
		end
		if new_expl ~= prev_explanation[pn] then
			prev_explanation[pn]= new_expl
			explanations[pn]:playcommand(expl_com, {text= new_expl})
		end
	end
end

local function input(event)
	local pn= event.PlayerNumber
	if not pn then return end
	if not menus[pn] then return end
	if menu_stack_generic_input(menus, event)
	and event.type == "InputEventType_FirstPress" then
		if event.GameButton == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen")
		else
			player_ready[pn]= true
            ready_indicators[pn]:playcommand("show_ready")
            explanations[pn]:playcommand("show_ready")          
			exit_if_both_ready()
		end
	else
		if player_ready[pn] and not menus[pn]:can_exit_screen() then
			player_ready[pn]= false
			ready_indicators[pn]:playcommand("hide_ready")
            explanations[pn]:playcommand("hide_ready")
		end
	end
	update_explanation(pn)
end

local frame= Def.ActorFrame{
	OnCommand= function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(input)
        local num = math.random(1,2); 
        SOUND:PlayOnce(THEME:GetPathS("","Announcer/ScreenSelectPlayerOptions_Intro"..num))
		for pn, menu in pairs(menus) do
			menu:push_menu_stack(nesty_option_menus.menu, base_options, "play_song")
			menu:update_cursor_pos()
			update_explanation(pn)
		end
	end,
}
local item_params= {
    frame_commands={
        OnCommand=cmd(setsize,menu_width,19;diffuse,color("#ffffff");faderight,0.75;diffusealpha,0.15);
        GainFocusCommand=cmd(diffusealpha,0.25);
        LoseFocusCommand=cmd(diffusealpha,0.15);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    },
    line_commands={
        OnCommand=cmd(setsize,menu_width,2;diffuse,color("#ffffff");addy,-19/2+2;faderight,0.5;diffusealpha,0.5);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    },    
	text_commands= {
		Font= "Common Normal", 
        OnCommand=cmd(diffuse,color("#2e2e2e"));
        GainFocusCommand=cmd(diffuse,color("#6e6e6e"));
        LoseFocusCommand=cmd(diffuse,color("#2e2e2e"));
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
	text_width= .7,
	value_text_commands= {
		Font= "Common Normal", 
        OnCommand=cmd(diffuse,color("#2e2e2e");diffusealpha,0.5);
        GainFocusCommand=cmd(diffusealpha,1);
        LoseFocusCommand=cmd(diffusealpha,0.75);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
	value_width= .25,
	type_images= {
        
		bool= THEME:GetPathG("", "menu_icons/bool"),
		choice= THEME:GetPathG("", "menu_icons/bool"),
		menu= THEME:GetPathG("", "menu_icons/menu"),
	},
	value_image_commands= {
        OnCommand=cmd(diffuse,color("#2e2e2e");diffusealpha,0.5);
        GainFocusCommand=cmd(diffusealpha,1);
        LoseFocusCommand=cmd(diffusealpha,0.5);        
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
}
    frame[#frame+1] = LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"))..{
    OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,0.5;draworder,-1);
    OffCommand=cmd(sleep,0.2;linear,0.5;diffusealpha,0);
    };
for pn, menu in pairs(menus) do
    frame[#frame+1]= commonpanel(310-20,SCREEN_HEIGHT/1.3-20,10,0.5,color("#f2f2f2"),PlayerColor(pn))..{
        InitCommand=cmd(xy,menu_x[pn],_screen.cy;zoom,0.75);
    };
	frame[#frame+1]= Def.ActorFrame{
        InitCommand=cmd(xy,menu_x[pn]-100,_screen.cy-362*0.5-12;zoom,0.75);
        LoadFont("Common Bold") .. {
            InitCommand=cmd(maxwidth,270;zoom,0.8;horizalign,left;vertalign,top;diffuse,PlayerColor(pn));
            OnCommand=function(self)
                if pn== PLAYER_1 then
                    self:settext("Player 1");
                else
                    self:settext("Player 2");
                end
                self:diffusealpha(0):linear(0.2):diffusealpha(1);
            end;
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };
        Def.Quad{
            InitCommand=cmd(horizalign,left;vertalign,top;setsize,90,5;addy,30;diffuse,PlayerColor(pn));
            OnCommand=cmd(cropright,1;linear,0.2;cropright,0);
            OffCommand=cmd(stoptweening;linear,0.1;zoomy,0;diffusealpha,0);
        };
        Def.Sprite{
            InitCommand=function(self)
                self:vertalign(top):horizalign(right)
                    :scaletoclipped(38,38):xy(135+130+4,0)
                    :Load(THEME:GetPathG("","_charicons/"..GetCharacter()))
            end;
            OnCommand=cmd(diffusealpha,0;sleep,0.5;linear,0.2;diffusealpha,1);
            OffCommand=cmd(linear,0.2;diffusealpha,0);
        };        
    }    
	frame[#frame+1]= menu:create_actors{
		x= menu_x[pn], y= _screen.cy-200+20, width= menu_width, height= menu_height,
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
                    InitCommand=cmd(setsize,200/0.55,19/0.55;addy,30/0.55;diffuse,PlayerColor(pn))
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
        explanations[pn]= self
        self:xy(menu_x[pn],_screen.cy+142+20-10+3):setsize(menu_width,66)
            :diffuse(color("#000000")):diffusealpha(0.15):zoomy(1)
        end;
        show_readyCommand=cmd(linear,0.2;zoomy,0);
        hide_readyCommand=cmd(linear,0.2;zoomy,1);
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    }
	frame[#frame+1]= Def.BitmapText{
		Font= "Common Normal", InitCommand= function(self)
			explanations[pn]= self
			self:xy(menu_x[pn]-(menu_width/2)+10,_screen.cy+133)
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
			ready_indicators[pn]= self
			self:xy(menu_x[pn],_screen.cy+150):zoom(0.8):diffuse(PlayerColor(pn)):diffusealpha(0)
		end,
		show_readyCommand= function(self)
			self:stoptweening():decelerate(.2):diffusealpha(1)
		end,
		hide_readyCommand= function(self)
			self:stoptweening():accelerate(.2):diffusealpha(0)
		end,
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	}    
end

return frame
