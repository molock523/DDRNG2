local sort_wheel = setmetatable({disable_wrapping = false}, item_scroller_mt)
local sort_orders={};
if GAMESTATE:GetSortOrder()=="SortOrder_Group" then
	
	sort_orders = {"Title","BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity","Genre","Group",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_Title" then
	sort_orders = {"BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity","Genre","Group","Title",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_BPM" then
	sort_orders = {"BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity","Genre","Group","Title","BPM",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_BeginnerMeter" then
	sort_orders = {"EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity","Genre","Group","Title","BPM","BeginnerMeter",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_EasyMeter" then
	sort_orders = {"MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity","Genre","Group","Title","BPM","BeginnerMeter","EasyMeter",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_MediumMeter" then
	sort_orders = {"HardMeter","ChallengeMeter","TopGrades","Popularity","Genre","Group","Title","BPM","BeginnerMeter","EasyMeter","MediumMeter",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_HardMeter" then
	sort_orders = {"ChallengeMeter","TopGrades","Popularity","Genre","Group","Title","BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_ChallengeMeter" then
	sort_orders = {"TopGrades","Popularity","Genre","Group","Title","BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_TopGrades" then
	sort_orders = {"Popularity","Genre","Group","Title","BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_Popularity" then
	sort_orders = {"Genre","Group","Title","BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity",}
elseif GAMESTATE:GetSortOrder()=="SortOrder_Genre" then
	sort_orders = {"Group","Title","BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity","Genre",}
else
	sort_orders = {"Group","Title","BPM","BeginnerMeter","EasyMeter","MediumMeter","HardMeter","ChallengeMeter","TopGrades","Popularity","Genre",}
end;

local function input(event)
	if not event.PlayerNumber or not event.button then
		return false
	end
	if event.type ~= "InputEventType_Release" then
		local overlay = SCREENMAN:GetTopScreen():GetChild("Overlay")
		if event.GameButton == "MenuRight" then
			sort_wheel:scroll_by_amount(1)
			overlay:GetChild("change_sound"):play()
		elseif event.GameButton == "MenuLeft" then
			sort_wheel:scroll_by_amount(-1)
			overlay:GetChild("change_sound"):play()
		elseif event.GameButton == "Start" then
			overlay:GetChild("start_sound"):play()
			MESSAGEMAN:Broadcast('Sort',{order=sort_wheel:get_actor_item_at_focus_pos().info})
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		elseif event.GameButton == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		end
	end
	return false
end

local wheel_item_mt = {
	__index = {
		create_actors = function(self, name)
			self.name=name
			local af = Def.ActorFrame{
				Name=name,
				InitCommand=function(subself)
					self.container = subself
					subself:MaskDest()
				end,
                OnCommand=function(self)
                    self:diffusealpha(0):sleep(0.8):linear(0.2):diffusealpha(1)
                end,
                OffCommand=function(self)
                    self:linear(0.2):diffusealpha(0)
                end,                
			}
			af[#af+1] = Def.Quad{
				InitCommand=function(subself)
                    self.bar= subself
                    subself:setsize(200,26)
				end,
			}            
			af[#af+1] = LoadFont("Common Normal")..{
				Text="",
				InitCommand=function(subself)
					self.text= subself
                    subself:zoom(0.5)
				end,
			}
			return af
		end,
		transform = function(self, item_index, num_items, has_focus)
			self.container:finishtweening()
			if has_focus then
				self.bar:diffusealpha(1):diffuse(color("#2e2e2e"))
                self.text:diffuse(color("#FFFFFF"))
			else
				self.bar:diffusealpha(1):diffuse(color("#eaeaea"))
                self.text:diffuse(color("#2e2e2e"))
			end
			self.container:y(28 * (item_index - math.ceil(num_items/2)))          
		end,
		set = function(self, info)
			self.info= info
			if not info then self.text:settext("") return end
			self.text:settext(THEME:GetString("ScreenSortList", info))
		end
	}
}

local t = Def.ActorFrame {
	InitCommand=function(self)
		sort_wheel:set_info_set(sort_orders, 1)
		sort_wheel.focus_pos = 5
		sort_wheel:scroll_by_amount(0)
		self:queuecommand("Capture")
	end,
	CaptureCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(input)
	end,
    -- blur hack
    LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"))..{
    OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,0.5);
    OffCommand=cmd(sleep,1.2;linear,0.2;diffusealpha,0);
    };
    commonpanel(310-20,524/2,10,0.5,color("#f2f2f2"),color("#eaeaea"))..{
        InitCommand=cmd(Center);  
    };
	Def.Quad {
		InitCommand=cmd(Center; zoomto,300,_screen.h/2; y,0; MaskSource )
	},   
	sort_wheel:create_actors( "sort_wheel", 9, wheel_item_mt, _screen.cx, _screen.cy )..{
        InitCommand=cmd(draworder,5);
    },
}
t[#t+1] = LoadActor( THEME:GetPathS("_options", "next") )..{ Name="change_sound", SupportPan = false }
t[#t+1] = LoadActor( THEME:GetPathS("MusicWheel", "sort") )..{ Name="start_sound", SupportPan = false }

return t