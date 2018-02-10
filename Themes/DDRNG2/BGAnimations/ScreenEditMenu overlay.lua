local menu_x=_screen.w/2-335
local menu_y=_screen.cy-200+20

local steps_item_space= _screen.h*.05
local steps_item_width= steps_item_space * .75
local steps_type_item_space= _screen.h*.06

local steps_display= setmetatable({disable_wrapping= true}, item_scroller_mt)
local function steps_transform(self, item_index, num_items)
	self.container:xy((item_index-.5) * steps_item_space, 15)
end
local function stype_transform(self, item_index, num_items)
	self.container:y((item_index-1) * steps_type_item_space)
end
local stype_item_mt= edit_pick_menu_steps_display_item(
	stype_transform, Def.BitmapText{
		Font= "Common Normal", InitCommand= function(self)
			self:zoom(.5):horizalign(left)
		end,
		SetCommand= function(self, param)
			self:settext(THEME:GetString("LongStepsType", ToEnumShortString(param.stype)))
		end,
																 },
	steps_transform, Def.BitmapText{
		Font= "Common Normal", InitCommand= function(self)
			self:zoom(.5)
		end,
		SetCommand= function(self, param)
			self:settext(param.steps:GetMeter())
				:diffuse(GameColor.Difficulty[param.steps:GetDifficulty()])
			width_limit_text(self, steps_item_width, .5)
		end,
})

local picker_width= _screen.w * .5
local spacer= _screen.h * .05
local jacket_size= _screen.h * .2
local jacket_x= _screen.w - spacer - (jacket_size / 2)
local jacket_y= _screen.h * .2
local banner_width= _screen.w - picker_width - jacket_size - (spacer * 3)
local banner_height= _screen.h * .2
local banner_x= jacket_x - spacer - (jacket_size / 2) - (banner_width / 2)
local banner_y= jacket_y
local bpm_x= _screen.w/2+335-100+10
local bpm_y= jacket_y + (jacket_size / 2)
local length_x= bpm_x
local length_y= bpm_y + (spacer / 2)
local title_x= banner_x - (banner_width / 2)
local title_y= bpm_y
local artist_x= title_x
local artist_y= length_y
local steps_display_x= _screen.w/2+335-100+10
local steps_display_y= title_y + (spacer * 1.5)
local steps_display_items= (_screen.h - steps_display_y) / steps_type_item_space

local menu_params= {
	name= "menu", x=menu_x, y=menu_y, width=200,
	translation_section= "ScreenEditMenu",
	menu_sounds= {
		pop= THEME:GetPathS("Common", "Cancel"),
		push= THEME:GetPathS("_common", "row"),
		act= THEME:GetPathS("Common", "value"),
		move= THEME:GetPathS("_switch", "down"),
		move_up= THEME:GetPathS("_switch", "up"),
		move_down= THEME:GetPathS("_switch", "down"),
		inc= THEME:GetPathS("_switch", "up"),
		dec= THEME:GetPathS("_switch", "down"),
	},
	num_displays= 1, el_height= 20, display_params= {
		no_status= true,
		height=300, el_zoom= 0.55,
		item_mt= cons_option_item_mt, item_params= {
    frame_commands={
        OnCommand=cmd(setsize,200,19;diffuse,color("#eaeaea"));
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
	text_width= .85,
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
		},
	},
}

local frame= Def.ActorFrame{
    commonpanel(310-20,SCREEN_HEIGHT/1.3-20,10,0.5,color("#f2f2f2"),color("#2e2e2e"))..{
        InitCommand=cmd(xy,menu_x,_screen.cy;zoom,0.75);
    };
    commonpanel(310-20,SCREEN_HEIGHT/1.3-20,10,0.5,color("#f2f2f2"),color("#2e2e2e"))..{
        InitCommand=cmd(xy,_screen.w/2+335,_screen.cy;zoom,0.75);
    };  
	edit_menu_selection_changedMessageCommand=
		edit_pick_menu_update_steps_display_info(steps_display),
	edit_pick_menu_actor(menu_params),
    --explanation
    Def.Quad{
        InitCommand=function(self)
        self:xy(menu_x,_screen.cy+142+20-10+3):setsize(200,66)
            :diffuse(color("#000000")):diffusealpha(0.15):zoomy(1)
        end;
        OffCommand=cmd(linear,0.2;diffusealpha,0);
    },
	Def.BitmapText{
		Font= "Common Normal", InitCommand= function(self)
			self:xy(_screen.w/2+335,_screen.cy-180)
				:zoom(.55)
				:vertalign(top):diffuse(color("#ffffff"))
                :settext(THEME:GetString("ScreenEditMenu","InformationTitle"))
		end,
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
	Def.BitmapText{
		Font= "Common Normal", InitCommand= function(self)
			self:xy(menu_x-(100)+10,_screen.cy+133)
				:wrapwidthpixels(200/.6):zoom(.5)
				:horizalign(left):vertalign(top):diffuse(color("#ffffff"))
                :settext(THEME:GetString("ScreenEditMenu","Explanation"))
		end,
        OffCommand=cmd(linear,0.2;diffusealpha,0);
	},
	Def.Banner{
		Name= "jacket", InitCommand= function(self)
			self:Center():scaletoclipped(220,220)
		end,
		edit_menu_selection_changedMessageCommand= function(self, params)
        local song = params.song
        local group = params.group
			if group then
                self:LoadFromSongGroup(params.group)
			elseif song then
                if song:GetJacketPath()~=nil then self:Load(song:GetJacketPath())
                elseif song:GetBackgroundPath()~=nil then self:Load(song:GetBackgroundPath())
                else self:Load(THEME:GetPathG("Common fallback","jacket"));
                end
			end
		end,
	},
	Def.BitmapText{
		Name= "length", Font= "Common Normal", InitCommand= function(self)
			self:xy(length_x, length_y):horizalign(left):zoom(.5)
		end,
		edit_menu_selection_changedMessageCommand= function(self, params)
			if params.group then
				self:visible(false)
			elseif params.song then
				self:settext(SecondsToMSS(params.song:MusicLengthSeconds()))
				self:visible(true)
			end
		end,
	},
	Def.BitmapText{
		Name= "bpm", Font= "Common Normal", InitCommand= function(self)
			self:xy(bpm_x, bpm_y):horizalign(left):zoom(.5)
		end,
		edit_menu_selection_changedMessageCommand= function(self, params)
			if params.group then
				self:visible(false)
			elseif params.song then
				local display_bpm= params.song:GetDisplayBpms()
				if display_bpm[1] == display_bpm[2] then
					self:settextf("%d BPM", display_bpm[1])
				else
					self:settextf("%d - %d BPM", math.round(display_bpm[1]), math.round(display_bpm[2]))
				end
				self:visible(true)
			end
		end,
	},
	Def.BitmapText{
 		Name= "title", Font= "Common Bold", InitCommand= function(self)
			self:xy(_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+105,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2)
            :horizalign(left):vertalign(top)
		end,
		edit_menu_selection_changedMessageCommand= function(self, params)
			if params.group then
				self:settext(": "..params.group)
			elseif params.song then
				self:settext(": "..params.song:GetDisplayMainTitle())
			end
		end,
	},
	Def.BitmapText{
 		Name= "artist", Font= "Common Bold", InitCommand= function(self)
			self:xy(_screen.cx-(SCREEN_WIDTH/1.3*0.5)+25+120,_screen.cy-(SCREEN_HEIGHT/1.3*0.5)+25-2+30)
            :horizalign(left):vertalign(top):zoom(.5)
		end,
		edit_menu_selection_changedMessageCommand= function(self, params)
			if params.group then
				self:visible(false)
			elseif params.song then
				self:settext(params.song:GetDisplayArtist())
				self:visible(true)
			end
		end,
	},
	steps_display:create_actors("steps_display", steps_display_items, stype_item_mt, steps_display_x, steps_display_y),
}

return frame
