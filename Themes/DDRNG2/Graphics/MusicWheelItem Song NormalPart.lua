local sBannerPath = THEME:GetPathG("Common", "fallback jacket");
local sJacketPath = THEME:GetPathG("Common", "fallback jacket");
local bAllowJackets = true
local song;
local group;

function arrangeXPosition(myself, index)
	if index%3==0 then
		myself:x(-300);
	elseif index%3==1 then
		myself:x(0);
	else
		myself:x(300);
	end;
end

--technika2/3 style hack ;)
function arrangeYPosition(myself, index)
	if index%3==0 then
		myself:y(100);
	elseif index%3==1 then
		myself:y(0);
	else
		myself:y(-100);
	end;
end

--main backing
local t = Def.ActorFrame {
SetMessageCommand=function(self,params)
    if MusicWheelType() == "MusicWheelGrid" then 
        arrangeXPosition(self,params.Index);
        arrangeYPosition(self,params.Index);
    end
end;
--banner   
	Def.Sprite {
		Name="Banner";
		InitCommand=function(self)
            if MusicWheelType() == "MusicWheelGrid" then self:scaletoclipped(300,300):cropbottom(0.1)
            elseif MusicWheelType() == "MusicWheelList" then self:scaletoclipped(50,50):x(-150):horizalign(right):draworder(99)
            elseif MusicWheelType() == "MusicWheelX2" then self:scaletoclipped(220,220)
            end
        end;
		SetMessageCommand=function(self,params)
			local song = params.Song or params.Course
			if song then
                if MusicWheelType()=="MusicWheelOld-style" then
                    self:Load(THEME:GetPathG("MusicWheelOld-style","bar.png"))
                else
                    if params.Course then
                        if song:GetBackgroundPath()~=nil then self:Load(song:GetBackgroundPath())
                        else self:Load(THEME:GetPathG("Common fallback","jacket"));
                        end
                    else
                        if song:GetJacketPath()~=nil then self:Load(song:GetJacketPath())
                        elseif song:GetBackgroundPath()~=nil then self:Load(song:GetBackgroundPath())
                        else self:Load(THEME:GetPathG("Common fallback","jacket"));
                        end
                    end
                end 
            end
		end;
	};
    -- cursor
	Def.Quad {
		Name="Cursor";
        Condition=MusicWheelType()=="MusicWheelGrid";
		InitCommand=cmd(setsize,300,300;blend,"BlendMode_Add";diffuse,color("#FFFFFF");diffusealpha,0.5;cropbottom,0.1;visible,false);
		SetMessageCommand=function(self,params)
            (cmd(diffuseshift;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0.5;effectclock,'beatnooffset'))(self);
            if params.HasFocus then
                self:visible(true);
            else
                self:visible(false);
            end
		end;
	};    
    --info
    Def.ActorFrame{
    Condition=MusicWheelType()~="MusicWheelX2";
    InitCommand=function(self) if MusicWheelType()=="MusicWheelGrid" then self:addy(150*0.4) end end;
        Def.Quad{
            Condition=MusicWheelType()~="MusicWheelOld-style";
            InitCommand=function(self)
                if MusicWheelType()=="MusicWheelGrid" then self:setsize(300,50):shadowlengthy(-1):shadowcolor(color("#eaeaea"))
                elseif MusicWheelType()=="MusicWheelList" then 
                    self:setsize(395,50):fadetop(1):horizalign(left):x(-150):draworder(1)
                end
            end;
            SetMessageCommand=function(self,params)
            local song = params.Song or params.Course
            if song then
                if params.HasFocus then
                    if MusicWheelType()=="MusicWheelList" then self:setsize(395,3):y(25):x(-150):horizalign(left) end
                    self:diffuse(color(GroupColour(song:GetGroupName())))
                else
                    if MusicWheelType()=="MusicWheelGrid" then self:diffuse(color("#2e2e2e"))
                    else self:diffuse(color("#2e2e2e")):diffusealpha(0.05):setsize(395,50):y(0) end
                end
            end
		end;
        };
        LoadFont(MusicWheelFont())..{
            InitCommand=function(self) 
                if MusicWheelType()=="MusicWheelGrid" then self:vertalign(top):horizalign(center):addy(-4)
                elseif MusicWheelType()=="MusicWheelList" then self:horizalign(left):addx(-60):zoom(0.7)
                else self:horizalign(left):addx(-70):zoom(0.5) end
                self:maxwidth(280)
            end;
            SetMessageCommand=function(self,params)
			local song = params.Song or params.Course
                if song then
                    if params.HasFocus then
                        if params.Song then 
                            if MusicWheelType()=="MusicWheelGrid" then self:diffuse(color("#ffffff"))
                            elseif MusicWheelType()=="MusicWheelList" then self:diffuse(color("#2e2e2e"))
                            end
                        elseif params.Course then self:diffuse(color("#2e2e2e")) end
                    else
                        if params.Song then self:diffuse(color(GroupColour(song:GetGroupName())));
                        elseif params.Course then self:diffuse(color(CourseColour(song:GetDisplayFullTitle()))); end
                    end              
                    if params.Song then self:settext(song:GetDisplayMainTitle());
                    elseif params.Course then self:settext(song:GetDisplayFullTitle()); end
                end;
            end;
        };        
    };
    -- new
    Def.ActorFrame{
        SetMessageCommand=function(self,params)
            if params.Song and not params.Course then 
                if PROFILEMAN:IsSongNew(params.Song) then self:visible(true) else self:visible(false) end
            end
        end;
        Def.Quad{
            SetMessageCommand=function(self,params)
                if MusicWheelType()~="MusicWheelGrid" then 
                    self:visible(false) 
                else 
                    self:setsize(300,50):diffuse(color("#000000")):y(-150):vertalign(top):diffusealpha(0.5):fadeleft(1)
                end
            end;
        }; 
        LoadFont("Common Bold")..{
        Text= "NEW!!";
            SetMessageCommand=function(self,params)
                if MusicWheelType()=="MusicWheelGrid" then
                    self:y(-150+25):horizalign(right):x(150-10):shadowlength(2)
                else
                    self:y(-20):x(-150+20):zoom(0.5):draworder(999):shadowlength(0):horizalign(left)
                end
                if params.HasFocus then 
                    self:rainbowscroll(true):playcommand("Glow") 
                else
                    self:rainbowscroll(false):stopeffect()
                end
            end;
            GlowCommand=cmd(diffuseshift;effectcolor2,color("1,1,1,0.5");effectcolor1,color("1,1,1,0.25");effectclock,'beat');
        };
    }; 
};
return t;