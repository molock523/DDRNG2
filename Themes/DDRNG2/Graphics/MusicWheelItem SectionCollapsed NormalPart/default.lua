local group;

--arrange song position devide by 3
function arrangeXPosition(myself, index)
	if index%3==0 then
		myself:x(-300);
	elseif index%3==1 then
		myself:x(0);
	else
		myself:x(300);
	end;
end

function arrangeXPosition2(myself, index, offset)
	if index%3==0 then
		myself:x(-300+offset);
	elseif index%3==1 then
		myself:x(0+offset);
	else
		myself:x(300+offset);
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

function arrangeYPosition2(myself, index, offset)
	if index%3==0 then
		myself:y(100+offset);
	elseif index%3==1 then
		myself:y(0+offset);
	else
		myself:y(-100+offset);
	end;
end

local t = Def.ActorFrame{
SetMessageCommand=function(self,params)
    if MusicWheelType() == "MusicWheelGrid" then 
        arrangeXPosition(self,params.Index);
        arrangeYPosition(self,params.Index);
    end
end; 
    Def.Sprite{
        Name="underlay";
        InitCommand=function(self)
            if MusicWheelType() == "MusicWheelGrid" then
                self:Load(THEME:GetPathG("MusicWheelItem","SectionCollapsed NormalPart/underlay_grid"))
            elseif MusicWheelType() == "MusicWheelList" then
                self:Load(THEME:GetPathG("MusicWheelItem","SectionCollapsed NormalPart/underlay_list"))
            end
        end;
    };  
    Def.Banner{
		Name="SongBanner";
		InitCommand=cmd(scaletoclipped,200,200);
		SetMessageCommand=function(self,params)
		group = params.Text;
		if group then
			self:LoadFromSongGroup(group)
            if MusicWheelType() == "MusicWheelList" then self:scaletoclipped(50,50):x(-150+10):horizalign(right)
            else self:scaletoclipped(200,200)
            end
		end
		end;
	};
    Def.Sprite{
        Name="overlay";
        InitCommand=function(self,params)
            if MusicWheelType() == "MusicWheelGrid" then
                self:Load(THEME:GetPathG("MusicWheelItem","SectionCollapsed NormalPart/overlay_grid")):animate(false)
                if params.HasFocus then self:setstate(1)
                else self:setstate(0)
                end
            elseif MusicWheelType() == "MusicWheelList" then
                self:Load(THEME:GetPathG("MusicWheelItem","SectionCollapsed NormalPart/overlay_list"))
            end
        end;
    }; 
	LoadFont("Common Normal")..{
	InitCommand=cmd(addy,58;maxwidth,200;diffuse,color("#000000"));
	SetMessageCommand=function(self, params)
		local song = params.Song;
		group = params.Text;
		if group=='DanceDanceRevolution 1stMIX' then
			self:settext("DDR 1stMIX");
		elseif group=='DanceDanceRevolution 2ndMIX' then
			self:settext("DDR 2ndMIX");
		elseif group=='DanceDanceRevolution 3rdMIX' or group=='DanceDanceRevolution 3rdMIX + VER.Korea' then
			self:settext("DDR 3rdMIX");
		elseif group=='DanceDanceRevolution 4thMIX' then
			self:settext("DDR 4thMIX");
		elseif group=='DanceDanceRevolution 5thMIX' then
			self:settext("DDR 5thMIX");
		elseif group=='DanceDanceRevolution 6thMIX MAX' then
			self:settext("DDR MAX");
		elseif group=='DanceDanceRevolution 7thMIX MAX2' then
			self:settext("DDR MAX2");
		elseif group=='DanceDanceRevolution 8thMIX EXTREME' then
			self:settext("DDR EXTREME");
		elseif group=='DanceDanceRevolution SuperNOVA' then
			self:settext("DDR SuperNOVA");
		elseif group=='DanceDanceRevolution SuperNOVA2' then
			self:settext("DDR SuperNOVA2");
		elseif group=='DanceDanceRevolution X' then
			self:settext("DDR X");
		elseif group=='DanceDanceRevolution X2' then
			self:settext("DDR X2");
		elseif group=='DanceDanceRevolution X3' or group=='DanceDanceRevolution X3 VS 2ndMIX' then
			self:settext("DDR X3");
		elseif group=='DDR 2013' then
			self:settext("DDR 2013");
		elseif group=='DDR 2014' then
			self:settext("DDR 2014");
        elseif group=='DDR Next Generation' then
            self:settext("DDR NG");
        elseif group=='DDR Next Generation 2' then
            self:settext("DDR NG2");
		else
			self:settext(group);
		end
        if MusicWheelType() == "MusicWheelGrid" then
            self:y(58):zoom(1)
        elseif MusicWheelType() == "MusicWheelList" then self:y(0):zoom(0.7) 
        elseif MusicWheelType()=="MusicWheelOld-style" then self:y(0):zoom(1)
        else self:zoom(0)
        end
        if params.HasFocus then self:diffuse(color("#ffffff")) 
        else self:diffuse(color("#000000")) end            
		end;
	};
};
return t;